//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

@import Foundation;

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
