//  Copyright © 2018 Rollbar. All rights reserved.

#import "RollbarDeployApiCallOutcome.h"

@import Foundation;
@import RollbarCommon;

@class RollbarDeploymentDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - RollbarDeployApiCallResult

/// Models result of Deploy API call/request
@interface RollbarDeployApiCallResult : RollbarDTO

/// API call's outcome
@property (readonly) RollbarDeployApiCallOutcome outcome;

/// API call's result description
@property (readonly, copy, nullable) NSString *description;

/// Initialize this DTO instance with valid JSON NSDictionary seed
/// @param data valid JSON NSDictionary seed
- (instancetype)initWithDictionary:(NSDictionary *)data NS_UNAVAILABLE;

/// Initialize this DTO instance with valid JSON NSArray seed
/// @param data valid JSON NSArray seed
- (instancetype)initWithArray:(NSArray *)data NS_UNAVAILABLE;

/// Initialize empty DTO
- (instancetype)init NS_UNAVAILABLE;

/// Designated initializer
/// @param httpResponse HTTP response object
/// @param extraResponseData extra response info
/// @param error error (if any)
/// @param request corresponding HTTP request
- (instancetype)initWithResponse:(nullable NSHTTPURLResponse *)httpResponse
               extraResponseData:(nullable id)extraResponseData
                           error:(nullable NSError *)error
                      forRequest:(nonnull NSURLRequest *)request
NS_DESIGNATED_INITIALIZER;

/// Convenience initializer
/// @param httpResponse HTTP response object
/// @param data extra response data
/// @param error error (if any)
/// @param request  corresponding HTTP request
- (instancetype)initWithResponse:(nullable NSHTTPURLResponse *)httpResponse
                            data:(nullable NSData *)data
                           error:(nullable NSError *)error
                      forRequest:(nonnull NSURLRequest *)request;

@end



#pragma mark - RollbarDeploymentRegistrationResult

/// Models result of a deployment registration request
@interface RollbarDeploymentRegistrationResult : RollbarDeployApiCallResult

/// Deployment ID
@property (readonly, copy, nonnull) NSString *deploymentId;

@end



#pragma mark - RollbarDeploymentDetailsResult

/// Models result of a deployment details request
@interface RollbarDeploymentDetailsResult : RollbarDeployApiCallResult

/// Deployment details object
@property (readonly, retain, nullable) RollbarDeploymentDetails *deployment;

@end



#pragma mark - RollbarDeploymentDetailsPageResult

/// Models result of a deployment details page request
@interface RollbarDeploymentDetailsPageResult : RollbarDeployApiCallResult

/// Deployment details objects
@property (readonly, retain, nullable) NSArray<RollbarDeploymentDetails *> *deployments;

/// Deployment details page number
@property (readonly) NSUInteger pageNumber;

@end

NS_ASSUME_NONNULL_END
