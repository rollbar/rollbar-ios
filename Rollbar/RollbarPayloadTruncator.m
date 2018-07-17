//
//  RollbarPayloadTruncator.m
//  Rollbar
//
//  Created by Andrey Kornich on 2018-07-12.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import "RollbarPayloadTruncator.h"
#import "NSJSONSerialization+Rollbar.h"
#import <Foundation/Foundation.h>

@implementation RollbarPayloadTruncator

static const unsigned long payloadTotalBytesLimit = 512 * 1024;

static NSString *const pathToFrames = @"body.trace.frames";
static const unsigned long payloadHeadFramesToKeep = 10;
static const unsigned long payloadTailFramesToKeep = 10;

static NSString *const pathToCrashThreads = @"body.message.extra.crash.threads";
static const unsigned long payloadHeadCrashThreadsToKeep = 10;
static const unsigned long payloadTailCrashThreadsToKeep = 10;

+(void)truncatePayloads:(NSArray*)payloads
          toMaxByteSize:(int)maxByteSize {
    
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
    
//    unsigned long totalPayloadBytes = [NSJSONSerialization measureJSONDataByteSize:jsonPayload];
//    if (totalPayloadBytes > limit) {
//        NSArray *keyPaths = @[@"body.message.extra.crash.threads", @"body.trace.frames"];
//        for (NSString *keyPath in keyPaths) {
//            NSArray *obj = [payload valueForKeyPath:keyPath];
//            if (obj) {
//                [self truncatePayload:data forKeyPath:keyPath];
//                break;
//            }
//        }
//    }
}

+(BOOL)truncatePayload:(NSMutableDictionary*)payload
          toTotalBytes:(unsigned long) payloadLimit
 byLimitingStringBytes:(unsigned long)stringBytsLimit {
    
    if (![RollbarPayloadTruncator isTruncationNeeded:payload forLimit:payloadLimit]) {
        return FALSE;  //payload is small enough, no need to truncate further...
    }
    
    return FALSE;
}

+(BOOL)truncatePayload:(NSMutableDictionary*)payload
          toTotalBytes:(unsigned long) payloadLimit
       byReducingItems:(NSString*)pathToItems
     keepingHeadsCount:(unsigned long)headsCount
     keepingTailsCount:(unsigned long)tailsCount {
    
//    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:payload
//                                                          options:0
//                                                            error:nil
//                                                             safe:true
//                           ];
//    //unsigned long totalPayloadBytes = [NSJSONSerialization measureJSONDataByteSize:jsonPayload];    
//    if (jsonPayload.length <= limit) {
//        return FALSE;  //payload is small enough, no need to truncate further...
//    }
//    
    if (![RollbarPayloadTruncator isTruncationNeeded:payload forLimit:payloadLimit]) {
        return FALSE;  //payload is small enough, no need to truncate further...
    }
    
    NSMutableArray *items = [payload mutableArrayValueForKeyPath:pathToItems];
    if (items.count <= (headsCount + tailsCount)) {
        return TRUE;
    }
    
    unsigned long totalItemsToRemove = items.count - headsCount - tailsCount;
    [items removeObjectsInRange:NSMakeRange(headsCount, totalItemsToRemove)];
    
//    [RollbarPayloadTruncator createMutablePayloadWithData:payload forPath:pathToItems];
//    NSMutableArray *items = [payload valueForKeyPath:pathToItems]; //[payload mutableArrayValueForKeyPath:pathToItems];
//    BOOL isMutable = [items isKindOfClass: [NSMutableArray class]];
//    [payload setValue:@[] forKeyPath:pathToItems];
//
//    if (items.count <= (headsCount + tailsCount)) {
//        return TRUE;
//    }
//
//    unsigned long totalItemsToRemove = items.count - headsCount - tailsCount;
//    //[items  removeObjectsInRange:NSMakeRange(headsCount, totalItemsToRemove)];
//    [items removeObjectsInRange:NSMakeRange(headsCount, totalItemsToRemove)];
//    [payload setValue:items forKeyPath:pathToItems];
    
    return TRUE;
}

+(BOOL)isTruncationNeeded:(NSMutableDictionary*)payload forLimit:(unsigned long)payloadBytesLimit {
    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:payload
                                                          options:0
                                                            error:nil
                                                             safe:true
                           ];
    //unsigned long totalPayloadBytes = [NSJSONSerialization measureJSONDataByteSize:jsonPayload];
    //return (payloadBytesLimit < totalPayloadBytes);
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
              toTotalBytes:(int)totalBytesLimit {
    
    unsigned long currentStringEncoodingBytes =
        [RollbarPayloadTruncator measureTotalEncodingBytes:inputString];
    if (currentStringEncoodingBytes <= totalBytesLimit)
    {
        // no need to truncate:
        return inputString;
    }
    
    NSString *ellipsis = @"...";
    unsigned long totalEllipsisEncodingBytes =
        [RollbarPayloadTruncator measureTotalEncodingBytes:ellipsis];
    unsigned long bytesToRemove =
        currentStringEncoodingBytes - totalBytesLimit + totalEllipsisEncodingBytes;

    NSMutableString *result =
        [NSMutableString stringWithString:
         [inputString substringToIndex:inputString.length - bytesToRemove - 1]
         ];
    [result appendString:ellipsis];
    currentStringEncoodingBytes = [RollbarPayloadTruncator measureTotalEncodingBytes:result];
    while (totalBytesLimit < currentStringEncoodingBytes) {
        
        bytesToRemove =
            currentStringEncoodingBytes - totalBytesLimit + totalEllipsisEncodingBytes;
        
        [result deleteCharactersInRange:NSMakeRange(result.length - bytesToRemove, bytesToRemove)];
        [result appendString:ellipsis];
        
        currentStringEncoodingBytes = [RollbarPayloadTruncator measureTotalEncodingBytes:result];
    }
    
    return result;
}

//+(void)createMutablePayloadWithData:(NSMutableDictionary *)data
//                            forPath:(NSString *)path {
//    NSArray *pathComponents = [path componentsSeparatedByString:@"."];
//    NSString *currentPath = @"";
//
//    for (int i=0; i<pathComponents.count; i++) {
//        NSString *part = pathComponents[i];
//        currentPath = i == 0 ? part : [NSString stringWithFormat:@"%@.%@", currentPath, part];
//        id val = [data valueForKeyPath:currentPath];
//        if (!val) return;
//        if ([val isKindOfClass:[NSArray class]] && ![val isKindOfClass:[NSMutableArray class]]) {
//            NSMutableArray *newVal = [NSMutableArray arrayWithArray:val];
//            [data setValue:newVal forKeyPath:currentPath];
//        } else if ([val isKindOfClass:[NSDictionary class]] && ![val isKindOfClass:[NSMutableDictionary class]]) {
//            NSMutableDictionary *newVal = [NSMutableDictionary dictionaryWithDictionary:val];
//            [data setObject:newVal forKey:currentPath];
//        }
//    }
//}

/*
- (id)initWithPayload:(NSDictionary*)payload
maxPayloadSizeInBytes:(int)maxPayloadSizeInBytes {
    return self;
}

- (id)initWithPayloads:(NSArray*)payloads
 maxPayloadSizeInBytes:(int)maxPayloadSizeInBytes {
    return self;
}

- (void)truncate {
    return;
}
*/

@end

