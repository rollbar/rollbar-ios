//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import "RollbarPayloadTruncator.h"

@import RollbarCommon;

@implementation RollbarPayloadTruncator

static const unsigned long payloadTotalBytesLimit = 512 * 1024;

static NSString *const pathToRaw = @"body.crash_report.raw";

static NSString *const pathToFrames = @"body.trace.frames";
static const unsigned long payloadHeadFramesToKeep = 10;
static const unsigned long payloadTailFramesToKeep = 10;

static NSString *const pathToCrashThreads = @"body.message.extra.crash.threads";
static const unsigned long payloadHeadCrashThreadsToKeep = 10;
static const unsigned long payloadTailCrashThreadsToKeep = 10;

static const unsigned long maxStringBytesLimit = 1024;
static const unsigned long minStringBytesLimit = 256;

static const unsigned long minRawStringByteLimit = 3072;

static NSString *const pathToTrace = @"body.trace";
static NSString *const pathToTraceChain = @"body.trace_chain";
static const unsigned long maxExceptionMessageChars = 256;
static const unsigned long maxTraceFrames = 1;

+(void)truncatePayloads:(NSArray*)payloads {
    [RollbarPayloadTruncator truncatePayloads:payloads toMaxByteSize:payloadTotalBytesLimit];
}

+(void)truncatePayloads:(NSArray*)payloads
          toMaxByteSize:(unsigned long)maxByteSize {
    [payloads enumerateObjectsUsingBlock: ^(id item, NSUInteger idx, BOOL *stop) {
        
        [RollbarPayloadTruncator truncatePayload:item toTotalBytes:maxByteSize];
    }];
}

+(void)truncatePayload:(NSMutableDictionary*)payload {
    [RollbarPayloadTruncator truncatePayload:payload toTotalBytes:payloadTotalBytesLimit];
}

+(void)truncatePayload:(NSMutableDictionary*)payload
          toTotalBytes:(unsigned long) limit {
    BOOL continueTruncation =
        [RollbarPayloadTruncator truncatePayload:payload
                                    toTotalBytes:limit
                                 byReducingItems:pathToFrames
                               keepingHeadsCount:payloadHeadFramesToKeep
                               keepingTailsCount:payloadTailFramesToKeep
         ];
    if (continueTruncation) {
        continueTruncation =
            [RollbarPayloadTruncator truncatePayload:payload
                                        toTotalBytes:limit
                                     byReducingItems:pathToCrashThreads
                                   keepingHeadsCount:payloadHeadCrashThreadsToKeep
                                   keepingTailsCount:payloadTailCrashThreadsToKeep
             ];
    }

    unsigned long stringLimit = maxStringBytesLimit;
    while (continueTruncation && (stringLimit >= minStringBytesLimit)) {
        continueTruncation = [RollbarPayloadTruncator truncatePayload:payload
                                                         toTotalBytes:limit
                                                byLimitingStringBytes:stringLimit
                              ];
        stringLimit /= 2;
    }

    if (continueTruncation) {
        continueTruncation = [RollbarPayloadTruncator truncatePayload:payload
                                                         toTotalBytes:limit
                                            withExceptionMessageLimit:maxExceptionMessageChars
                                                  andTraceFramesLimit:maxTraceFrames
                              ];
    }

    if (continueTruncation) {
        [RollbarPayloadTruncator limitRawCrashReportInPayload:payload];
    }
}

+(void)limitRawCrashReportInPayload:(NSMutableDictionary *)payload {
    id raw = [payload valueForKeyPath:pathToRaw];
    if (!raw || raw == [NSNull null]) {
        return;
    }
    if ([raw isKindOfClass:[NSMutableString class]] && ![RollbarPayloadTruncator isMutable:raw]) {
        NSMutableString *mutableRaw = [raw mutableCopy];
        payload[@"body"][@"crash_report"][@"raw"] = mutableRaw;
        [mutableRaw setString:[RollbarPayloadTruncator truncateString:mutableRaw
                                                         toTotalBytes:minRawStringByteLimit]];
    } else {
        [raw setString:[RollbarPayloadTruncator truncateString:raw
                                                         toTotalBytes:minRawStringByteLimit]];
    }
}

+(BOOL)   truncatePayload:(NSMutableDictionary*)payload
             toTotalBytes:(unsigned long) payloadLimit
withExceptionMessageLimit:(unsigned long)exeptionMessageLimit
      andTraceFramesLimit:(unsigned long)traceFramesLimit {
    
    if (![RollbarPayloadTruncator isTruncationNeeded:payload forLimit:payloadLimit]) {
        return FALSE;  //payload is small enough, no need to truncate further...
    }
    
    id value = [payload valueForKeyPath:pathToTraceChain];
    if (value == [NSNull null] || value == nil)
    {
        value = [NSMutableArray arrayWithObject:[payload valueForKeyPath:pathToTrace]];
    }
    
    if (value == nil || value == [NSNull null]) {
        return TRUE;
    }
    
    NSMutableArray *traces = (NSMutableArray *) value;
    [traces enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *exception = [item objectForKey:@"exception"];
        if (nil != exception) {
            [exception removeObjectForKey:@"description"];
            NSMutableString *message = [exception objectForKey:@"message"];
            if (nil != message && message.length > exeptionMessageLimit) {
                [exception setObject:[message substringWithRange:NSMakeRange(0, exeptionMessageLimit)] forKey:@"message"];
            }
        }
        NSMutableArray *frames = [item objectForKey:@"frames"];
        if (frames) {
            [frames removeObjectsInRange:NSMakeRange(traceFramesLimit, frames.count - traceFramesLimit)];
        }
    }];
    
    return TRUE;
}

+(BOOL)truncatePayload:(NSMutableDictionary*)payload
          toTotalBytes:(unsigned long) payloadLimit
 byLimitingStringBytes:(unsigned long)stringBytesLimit {
    
    if (![RollbarPayloadTruncator isTruncationNeeded:payload forLimit:payloadLimit]) {
        return FALSE;  //payload is small enough, no need to truncate further...
    }
    
    [RollbarPayloadTruncator itereateObjectStructure:payload
                               whileTuncatingStrings:stringBytesLimit
     ];
    return TRUE;
}

+(void)itereateObjectStructure:(id)obj whileTuncatingStrings:(unsigned long)stringBytesLimit {
    
    if ([obj isKindOfClass:[NSMutableString class]] && [RollbarPayloadTruncator isMutable:obj]) {
        //truncate the string obj:
        [obj setString:[RollbarPayloadTruncator truncateString:obj
                                                  toTotalBytes:stringBytesLimit]
         ];
    } else if ([obj isKindOfClass:[NSArray class]]) {
        //recurse the collection obj's items:
        [obj enumerateObjectsUsingBlock: ^(id item, NSUInteger idx, BOOL *stop) {
            [RollbarPayloadTruncator itereateObjectStructure:item
                                       whileTuncatingStrings:stringBytesLimit
             ];
        }];
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        //recurse the collection obj's items:
        [obj enumerateKeysAndObjectsUsingBlock: ^(id key, id item, BOOL *stop) {
            if (![key isEqualToString:@"raw"]) {
                if ([item isKindOfClass:[NSMutableString class]] && ![RollbarPayloadTruncator isMutable:item]) {
                    NSMutableString *mutableItem = [item mutableCopy];
                    [obj setObject:mutableItem forKey:key];
                    [RollbarPayloadTruncator itereateObjectStructure:mutableItem
                                               whileTuncatingStrings:stringBytesLimit];
                } else {
                    [RollbarPayloadTruncator itereateObjectStructure:item
                                               whileTuncatingStrings:stringBytesLimit];
                }
            }
        }];
    } else if ([obj isKindOfClass:[NSSet class]]) {
        //recurse the collection obj's items:
        [obj enumerateObjectsUsingBlock: ^(id item, BOOL *stop) {
            [RollbarPayloadTruncator itereateObjectStructure:item
                                       whileTuncatingStrings:stringBytesLimit
             ];
        }];
    } else {
        //nothing really...
    }
}

+(BOOL)isMutable:(id)str {
    NSString *copy = [str copy];
    return copy != str;
}

+(BOOL)truncatePayload:(NSMutableDictionary*)payload
          toTotalBytes:(unsigned long) payloadLimit
       byReducingItems:(NSString*)pathToItems
     keepingHeadsCount:(unsigned long)headsCount
     keepingTailsCount:(unsigned long)tailsCount {
    
    if (![RollbarPayloadTruncator isTruncationNeeded:payload forLimit:payloadLimit]) {
        return FALSE;  //payload is small enough, no need to truncate further...
    }
    
//    NSMutableArray *items = [payload mutableArrayValueForKeyPath:pathToItems];
//    if (items.count <= (headsCount + tailsCount)) {
//        return TRUE;
//    }
//
//    unsigned long totalItemsToRemove = items.count - headsCount - tailsCount;
//    [items removeObjectsInRange:NSMakeRange(headsCount, totalItemsToRemove)];
//
//    return TRUE;

    id value = [payload valueForKeyPath:pathToItems];
    if (value == [NSNull null] || [value isKindOfClass:[NSNull class]]) {
        return TRUE;
    }
    
    if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *items = ((NSArray *)value).mutableCopy;
        if (items.count <= (headsCount + tailsCount)) {
            return TRUE;
        }
        
        unsigned long totalItemsToRemove = items.count - headsCount - tailsCount;
        [items removeObjectsInRange:NSMakeRange(headsCount, totalItemsToRemove)];
    }

    
    return TRUE;
}

+(BOOL)isTruncationNeeded:(NSMutableDictionary*)payload forLimit:(unsigned long)payloadBytesLimit {
    
    NSData *jsonPayload = [NSJSONSerialization rollbar_dataWithJSONObject:payload
                                                          options:0
                                                            error:nil
                                                             safe:true
                           ];
    return (payloadBytesLimit < jsonPayload.length);
}

+(unsigned long)measureTotalEncodingBytes:(NSString*)string {
    
    return [RollbarPayloadTruncator measureTotalEncodingBytes:string
                                                usingEncoding:(NSUTF8StringEncoding)
            ];
}

+(unsigned long)measureTotalEncodingBytes:(NSString*)string
                            usingEncoding:(NSStringEncoding)encoding {

    NSUInteger totalBytes = [string lengthOfBytesUsingEncoding:encoding];
    
    return totalBytes;
}

+(NSString*)truncateString:(NSString*)inputString
              toTotalBytes:(unsigned long)totalBytesLimit {
    
    unsigned long currentStringEncoodingBytes =
        [RollbarPayloadTruncator measureTotalEncodingBytes:inputString];
    
    // let's take care if the trivial cases first:
    
    if (currentStringEncoodingBytes <= totalBytesLimit) {
        // no need to truncate:
        return inputString;
    }
    
    NSString *ellipsis = @"...";
    const unsigned long totalEllipsisEncodingBytes =
        [RollbarPayloadTruncator measureTotalEncodingBytes:ellipsis];
    if (totalEllipsisEncodingBytes >= totalBytesLimit) {
        // we have to have at least the ellipsis as a reasult of a string truncation:
        return ellipsis;
    }
    
    // let's try getting to the best fit target as close as possible in one shot:

    NSUInteger cutOffCodeUnitIndex = (totalBytesLimit - totalEllipsisEncodingBytes);
    if (cutOffCodeUnitIndex >= inputString.length) {
        cutOffCodeUnitIndex = inputString.length - 1; // valid index == no trouble down the road...
    }
    NSRange cutOffCharRange = [inputString rangeOfComposedCharacterSequenceAtIndex:cutOffCodeUnitIndex];
    NSRange truncationRange = NSMakeRange(0, cutOffCharRange.location);
    NSString *truncatedSting = [inputString substringWithRange:truncationRange];
    NSMutableString *result = [NSMutableString stringWithString:truncatedSting];
    
    // let's get even closer to the best fit target as much as possible:

    currentStringEncoodingBytes = [RollbarPayloadTruncator measureTotalEncodingBytes:result];
    while (currentStringEncoodingBytes > (totalBytesLimit - totalEllipsisEncodingBytes)) {
        cutOffCharRange = [result rangeOfComposedCharacterSequenceAtIndex:(result.length - 1)];
        [result deleteCharactersInRange:cutOffCharRange];
        currentStringEncoodingBytes = [RollbarPayloadTruncator measureTotalEncodingBytes:result];
    }
    
    // add truncation signs:
    [result appendString:ellipsis];
    
    return result;
}

@end

