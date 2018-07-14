//
//  RollbarPayloadTruncator.m
//  Rollbar
//
//  Created by Andrey Kornich on 2018-07-12.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import "RollbarPayloadTruncator.h"
#import <Foundation/Foundation.h>

@implementation RollbarPayloadTruncator

+(void)truncatePayloads:(NSArray*)payloads
          toMaxByteSize:(int)maxByteSize {
    
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
        
        [result replaceCharactersInRange:
         NSMakeRange(result.length - bytesToRemove, bytesToRemove) withString:@""
         ];
        [result appendString:ellipsis];
        
        currentStringEncoodingBytes = [RollbarPayloadTruncator measureTotalEncodingBytes:result];
    }
    
    return result;
}

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

