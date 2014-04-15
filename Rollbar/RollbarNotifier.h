//
//  RollbarNotifier.h
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RollbarConfiguration.h"

@interface RollbarNotifier : NSObject

@property (atomic, strong) RollbarConfiguration *configuration;

- (id)initWithAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration*)configuration isRoot:(BOOL)isRoot;

- (void)processSavedItems;

- (void)logCrashReport:(NSString*)crashReport;
- (void)log:(NSString*)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;

/**
 Sends an item batch in a blocking manner.
 
 @param itemData an array of items to be sent in this batch
 @param accessToken the access token used for this batch
 @param nextOffset the offset in the item queue file of the
 item immediately after this batch. If the send is successful
 or the retry limit is hit, nextOffset will be saved to the
 queueState as the offset to use for the next batch
 
 @return YES if this batch should be discarded if it was
 successful or a retry limit was hit. Otherwise NO is returned if this
 batch should be retried.
 */
- (BOOL)sendItems:(NSArray*)itemData withAccessToken:(NSString*)accessToken nextOffset:(NSUInteger)nextOffset;

@end
