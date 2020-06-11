//
//  RollbarTelemetryNetworkBody.h
//  Rollbar
//
//  Created by Andrey Kornich on 2020-02-28.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#import "RollbarTelemetryBody.h"
#import "RollbarHttpMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarTelemetryNetworkBody : RollbarTelemetryBody

#pragma mark - Properties

@property (nonatomic) RollbarHttpMethod method;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *statusCode;

#pragma mark - Initializers

-(instancetype)initWithMethod:(RollbarHttpMethod)method
                          url:(nonnull NSString *)url
                   statusCode:(nonnull NSString *)statusCode
                    extraData:(nullable NSDictionary *)extraData
NS_DESIGNATED_INITIALIZER;

-(instancetype)initWithMethod:(RollbarHttpMethod)method
                          url:(nonnull NSString *)url
                   statusCode:(nonnull NSString *)statusCode;

- (instancetype)initWithArray:(NSArray *)data
NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithDictionary:(NSDictionary *)data
NS_DESIGNATED_INITIALIZER;

- (instancetype)init
NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
