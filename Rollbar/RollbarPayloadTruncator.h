//
//  RollbarPayloadTruncator.h
//  Rollbar
//
//  Created by Andrey Kornich on 2018-07-12.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RollbarPayloadTruncator : NSObject

+(void)truncatePayload:(NSMutableDictionary*)payload;

+(void)truncatePayloads:(NSArray*)payloads
          toMaxByteSize:(unsigned long)maxByteSize;

+(void)truncatePayload:(NSMutableDictionary*)payload
          toTotalBytes:(unsigned long) limit;

+(unsigned long)measureTotalEncodingBytes:(NSString*)string
                            usingEncoding:(NSStringEncoding)encoding;
+(unsigned long)measureTotalEncodingBytes:(NSString*)string;

+(NSString*)truncateString:(NSString*)inputString
              toTotalBytes:(unsigned long)totalBytesLimit;

@end
