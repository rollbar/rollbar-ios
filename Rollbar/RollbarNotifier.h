//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "RollbarConfiguration.h"

@interface RollbarNotifier : NSObject 

@property (atomic, strong) RollbarConfiguration *configuration;

- (id)initWithAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration*)configuration isRoot:(BOOL)isRoot;

- (void)processSavedItems;

- (void)logCrashReport:(NSString*)crashReport;
- (void)log:(NSString*)level
    message:(NSString*)message
  exception:(NSException*)exception
       data:(NSDictionary*)data
    context:(NSString*)context;

/**
 Sends an item batch in a blocking manner.

 @param payload an item to send
 @param nextOffset the offset in the item queue file of the
 item immediately after this batch. If the send is successful
 or the retry limit is hit, nextOffset will be saved to the
 queueState as the offset to use for the next batch

 @return YES if this batch should be discarded if it was
 successful or a retry limit was hit. Otherwise NO is returned if this
 batch should be retried.
 */
- (BOOL)sendItem:(NSDictionary*)payload nextOffset:(NSUInteger)nextOffset;


/**
 Sends a fully composed JSON payload.

 @param payload complete Rollbar payload as JSON string

 @return YES if successful. NO if not.
 */
- (BOOL)sendPayload:(NSData*)payload;

// Update configuration methods
- (void)updateAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration *)configuration isRoot:(BOOL)isRoot;
- (void)updateConfiguration:(RollbarConfiguration*)configuration isRoot:(BOOL)isRoot;
- (void)updateAccessToken:(NSString*)accessToken;
- (void)updateReportingRate:(NSUInteger)maximumReportsPerMinute;

@end
