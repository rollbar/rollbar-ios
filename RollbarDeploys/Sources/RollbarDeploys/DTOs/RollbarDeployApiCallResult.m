//  Copyright © 2018 Rollbar. All rights reserved.

#import "RollbarDeployApiCallResult.h"
#import "RollbarDeploymentDetails.h"

@import RollbarCommon;

#pragma mark - RollbarDeployApiCallResult

@implementation RollbarDeployApiCallResult

static NSString * const DFK_OUTCOME = @"outcome";
static NSString * const DFK_DESCRIPTION = @"description";

- (RollbarDeployApiCallOutcome)outcome {
    return [self safelyGetIntegerByKey:DFK_OUTCOME];
}

- (NSString *)description {
    return [self safelyGetStringByKey:DFK_DESCRIPTION];
}

- (instancetype)initWithResponse:(NSHTTPURLResponse*)httpResponse
                            data:(NSData*)data
                           error:(NSError*)error
                      forRequest:(NSURLRequest*)request {
    
    self = [self initWithResponse:httpResponse
                extraResponseData:data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] : nil
                            error:error
                       forRequest:request];
    return self;
}

- (instancetype)initWithResponse:(NSHTTPURLResponse*)httpResponse
                extraResponseData:(id)extraResponseData
                           error:(NSError*)error
                      forRequest:(NSURLRequest*)request {
    
    const NSUInteger dictionaryCapacity = 3;
    NSMutableDictionary *dataSeed = [NSMutableDictionary dictionaryWithCapacity:dictionaryCapacity];
    if (error) {
        [dataSeed setObject:[NSNumber numberWithInt:RollbarDeployApiCall_Error] forKey:DFK_OUTCOME];
        
        NSMutableString *description =
        [NSMutableString stringWithFormat:@"Rollbar Deploy API communication error: %@",
         [error localizedDescription]
         ];
        [dataSeed setObject:description forKey:DFK_DESCRIPTION];
    }
    if (nil != httpResponse) {
        if (200 == httpResponse.statusCode) {
            [dataSeed setObject:[NSNumber numberWithInt:RollbarDeployApiCall_Success] forKey:DFK_OUTCOME];
        }
        else {
            [dataSeed setObject:[NSNumber numberWithInt:RollbarDeployApiCall_Error] forKey:DFK_OUTCOME];
        }
        NSMutableString *description =
        [NSMutableString stringWithFormat:@"HTTP Status Code: %ldi and Description: %@",
         (long)httpResponse.statusCode,
         [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]
         ];
        if (extraResponseData) {
            [description appendFormat:@"\n\rResponse data:\n\r\%@", extraResponseData];
        }
        [dataSeed setObject:description forKey:DFK_DESCRIPTION];
    }

    self = [super initWithDictionary:dataSeed];

    return self;
}

@end

#pragma mark - RollbarDeploymentRegistrationResult

@implementation RollbarDeploymentRegistrationResult

static NSString * const DFK_DEPLOYMENT_ID = @"deploymentId";

- (NSString *)deploymentId {
    return [self safelyGetStringByKey:DFK_DEPLOYMENT_ID];
}

- (instancetype)initWithResponse:(NSHTTPURLResponse*)httpResponse
                            data:(NSData*)data
                           error:(NSError*)error
                      forRequest:(NSURLRequest*)request {
    
    id dataObj = nil;
    if (data) {
        dataObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    if (dataObj) {
        self = [super initWithResponse:httpResponse
                     extraResponseData:dataObj
                                 error:error
                            forRequest:request];
    }
    else {
        self = [super initWithResponse:httpResponse
                                  data:data
                                 error:error
                            forRequest:request];
    }
    if (self && dataObj && !error && httpResponse && (200 == httpResponse.statusCode)) {
        [self setString:[NSString stringWithFormat:@"%@", dataObj[@"data"][@"deploy_id"]]
                 forKey:DFK_DEPLOYMENT_ID];
    }
    return self;
}

@end

#pragma mark - RollbarDeploymentDetailsResult

@implementation RollbarDeploymentDetailsResult

static NSString * const DFK_DEPLOYMENT = @"deployment";

- (RollbarDeploymentDetails *)deployment {
    id data = [self safelyGetDictionaryByKey:DFK_DEPLOYMENT];
    id dto = [[RollbarDeploymentDetails alloc] initWithDictionary:data];
    return dto;
}

- (instancetype)initWithResponse:(NSHTTPURLResponse*)httpResponse
                            data:(NSData*)data
                           error:(NSError*)error
                      forRequest:(NSURLRequest*)request {

    id dataObj = nil;
    if (data) {
        dataObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    if (dataObj) {
        self = [super initWithResponse:httpResponse
                     extraResponseData:dataObj
                                 error:error
                            forRequest:request];
    }
    else {
        self = [super initWithResponse:httpResponse
                                  data:data
                                 error:error
                            forRequest:request];
    }
    if (self && dataObj && !error && httpResponse && (200 == httpResponse.statusCode)) {
        RollbarDeploymentDetails *deploymentDetails =
        [[RollbarDeploymentDetails alloc] initWithDictionary:dataObj[@"result"]];
        [self setDataTransferObject:deploymentDetails
                             forKey:DFK_DEPLOYMENT];
    }
    return self;
}

@end

#pragma mark - RollbarDeploymentDetailsPageResult

@implementation RollbarDeploymentDetailsPageResult

static NSString * const DFK_DEPLOYMENTS = @"deployments";
static NSString * const DFK_PAGE_NUMBER = @"page";

- (NSArray<RollbarDeploymentDetails *> *)deployments {
    NSArray *deploys = [self safelyGetArrayByKey:DFK_DEPLOYMENTS];
    return deploys;
}

- (NSUInteger)pageNumber {
    return [self safelyGetUIntegerByKey:DFK_PAGE_NUMBER];
}

- (instancetype)initWithResponse:(NSHTTPURLResponse*)httpResponse
                            data:(NSData*)data
                           error:(NSError*)error
                      forRequest:(NSURLRequest*)request {

    id dataObj = nil;
    if (data) {
        dataObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    if (dataObj) {
        self = [super initWithResponse:httpResponse
                     extraResponseData:dataObj
                                 error:error
                            forRequest:request];
    }
    else {
        self = [super initWithResponse:httpResponse
                                  data:data
                                 error:error
                            forRequest:request];
    }
    if (self && dataObj && !error && httpResponse && (200 == httpResponse.statusCode)) {

        NSNumber *pageNumber = dataObj[@"result"][@"page"];
        [self setNumber:pageNumber forKey:DFK_PAGE_NUMBER];
        
        NSArray *deploys = dataObj[@"result"][@"deploys"];
        NSMutableArray<RollbarDeploymentDetails *> *deployments =
        [NSMutableArray<RollbarDeploymentDetails *> arrayWithCapacity:deploys.count];
        
        [deploys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RollbarDeploymentDetails *deploymentDetails = [[RollbarDeploymentDetails alloc] initWithDictionary:obj];
            [deployments addObject:deploymentDetails];
        }];
        
        [self setArray:deployments forKey:DFK_DEPLOYMENTS];
    }
    return self;
}

@end

