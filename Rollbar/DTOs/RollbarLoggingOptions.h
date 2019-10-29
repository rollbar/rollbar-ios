//
//  RollbarLoggingOptions.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-28.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"
#import "RollbarLevel.h"
#import "CaptureIpType.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarLoggingOptions : DataTransferObject

#pragma mark - properties

@property (nonatomic) RollbarLevel logLevel;
@property (nonatomic) RollbarLevel crashLevel;
@property (nonatomic) NSUInteger maximumReportsPerMinute;
@property (nonatomic) CaptureIpType captureIp;
@property (nonatomic, copy) NSString *codeVersion;
@property (nonatomic, copy) NSString *framework;
@property (nonatomic, copy) NSString *requestId;

#pragma mark - initializers

- (id)initWithLogLevel:(RollbarLevel)logLevel
            crashLevel:(RollbarLevel)crashLevel
maximumReportsPerMinute:(NSUInteger)maximumReportsPerMinute;
- (id)initWithLogLevel:(RollbarLevel)logLevel
            crashLevel:(RollbarLevel)crashLevel;

@end

NS_ASSUME_NONNULL_END
