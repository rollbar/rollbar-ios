//
//  RollbarPayloadTruncator.h
//  Rollbar
//
//  Created by Andrey Kornich on 2018-07-12.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RollbarPayloadTruncator : NSObject

+(void)truncatePayloads:(NSArray*)payloads
          toMaxByteSize:(int)maxByteSize;

+(void)truncatePayload:(NSMutableDictionary*)payload
          toTotalBytes:(unsigned long) limit;

+(unsigned long)measureTotalEncodingBytes:(NSString*)string
                            usingEncoding:(NSStringEncoding)encoding;
+(unsigned long)measureTotalEncodingBytes:(NSString*)string;

+(NSString*)truncateString:(NSString*)inputString
              toTotalBytes:(int)totalBytesLimit;

/*
@property (readonly) int maxPayloadSizeInBytes;

- (id)initWithPayload:(NSDictionary*)payload
maxPayloadSizeInBytes:(int)maxPayloadSizeInBytes;

- (id)initWithPayloads:(NSArray*)payloads
 maxPayloadSizeInBytes:(int)maxPayloadSizeInBytes;

- (void)truncate;
*/

@end
