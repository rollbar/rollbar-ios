//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#import "DeployApiCallResult.h"
#import "DataTransferObject+Protected.h"

@implementation DeployApiCallResult

static NSString * const DFK_OUTCOME = @"outcome";
static NSString * const DFK_DESCRIPTION = @"description";

- (DeployApiCallOutcome)outcome {
    return [self safelyGetIntegerByKey:DFK_OUTCOME];
}

- (NSString *)description {
    return [self safelyGetStringByKey:DFK_DESCRIPTION];
}

- (instancetype)initWithResponse:(NSHTTPURLResponse*)httpResponse
                            data:(NSData*)data
                           error:(NSError*)error
                      forRequest:(NSURLRequest*)request {
    
    const NSUInteger dictionaryCapacity = 3;
    NSMutableDictionary *dataSeed = [NSMutableDictionary dictionaryWithCapacity:dictionaryCapacity];
    if (error) {
        [dataSeed setObject:[NSNumber numberWithInt:DeployApiCallError] forKey:DFK_OUTCOME];
        
        NSMutableString *description =
        [NSMutableString stringWithFormat:@"Rollbar Deploy API communication error: %@",
         [error localizedDescription]
         ];
        [dataSeed setObject:description forKey:DFK_DESCRIPTION];
    }
    if (nil != httpResponse) {
        if (200 == httpResponse.statusCode) {
            [dataSeed setObject:[NSNumber numberWithInt:DeployApiCallSuccess] forKey:DFK_OUTCOME];
        }
        else {
            [dataSeed setObject:[NSNumber numberWithInt:DeployApiCallError] forKey:DFK_OUTCOME];
        }
        NSMutableString *description =
        [NSMutableString stringWithFormat:@"HTTP Status Code: %ldi and Description: %@",
         (long)httpResponse.statusCode,
         [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]
         ];
        if (data) {
            [description appendFormat:@"\n\rResponse data:\n\r\%@",
             [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]
             ];
        }
        [dataSeed setObject:description forKey:DFK_DESCRIPTION];
    }

    self = [super initWithDictionary:dataSeed];

    return self;
}

@end

@implementation DeploymentRegistrationResult

static NSString * const DFK_DEPLOYMENT_ID = @"deploymentId";

- (NSString *)deploymentId {
    return [self safelyGetStringByKey:DFK_DEPLOYMENT_ID];
}

//- (instancetype)initWithResponse:(NSHTTPURLResponse*)httpResponse
//                            data:(NSData*)data
//                           error:(NSError*)error
//                      forRequest:(NSURLRequest*)request {
//    
//    self = [super initWithResponse:httpResponse
//                              data:data
//                             error:error
//                        forRequest:request
//            ];
////    if (nil != self) {
////        if ((nil == error) && (nil != httpResponse) && (200 == httpResponse.statusCode)) {
////            NSDictionary *dataStruct = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
////            if (nil != dataStruct) {
////                NSNumber *deploy_id = dataStruct[@"data"][@"deploy_id"];
////                [self setString:[deploy_id stringValue] forKey:DFK_DEPLOYMENT_ID];
////            }
////        }
////    }
//    return self;
//}

@end

@implementation DeploymentDetailsResult

static NSString * const DFK_DEPLOYMENT = @"deployment";

- (DeploymentDetails *)deployment {
    id data = [self safelyGetDictionaryByKey:DFK_DEPLOYMENT];
    id dto = [[DeploymentDetails alloc] initWithDictionary:data];
    return dto;
}

//- (instancetype)initWithResponse:(NSHTTPURLResponse*)httpResponse
//                            data:(NSData*)data
//                           error:(NSError*)error
//                      forRequest:(NSURLRequest*)request {
//
//    self = [super initWithResponse:httpResponse
//                              data:data
//                             error:error
//                        forRequest:request
//            ];
////    if (nil != self) {
////        if ((nil == error) && (nil != httpResponse) && (200 == httpResponse.statusCode)) {
////            NSDictionary *dataStruct =
////            [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
////            //NSLog(@"%@", dataStruct);
////            if (nil != dataStruct) {
////                DeploymentDetails *deploymentDetails =
////                [[DeploymentDetails alloc] initWithJSONData:dataStruct[@"result"]];
////                [self setDataTransferObject:deploymentDetails forKey:DFK_DEPLOYMENT];
////            }
////        }
////    }
//    return self;
//}

@end

@implementation DeploymentDetailsPageResult

static NSString * const DFK_DEPLOYMENTS = @"deployments";
static NSString * const DFK_PAGE_NUMBER = @"page";

- (NSArray<DeploymentDetails *> *)deployments {
    NSArray *deploys = [self safelyGetArrayByKey:DFK_DEPLOYMENTS];
    NSMutableArray<DeploymentDetails *> *deployments =
    [NSMutableArray<DeploymentDetails *> arrayWithCapacity:deploys.count];
    [deploys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DeploymentDetails *deploymentDetails =
        [[DeploymentDetails alloc] initWithJSONData:obj];
        [deployments addObject:deploymentDetails];
    }];
    return deployments;
}

- (NSUInteger)pageNumber {
    return [self safelyGetUIntegerByKey:DFK_PAGE_NUMBER];
}

//- (instancetype)initWithResponse:(NSHTTPURLResponse*)httpResponse
//                            data:(NSData*)data
//                           error:(NSError*)error
//                      forRequest:(NSURLRequest*)request {
//
//    self = [super initWithResponse:httpResponse
//                              data:data
//                             error:error
//                        forRequest:request
//            ];
////    if (nil != self) {
////        if ((nil == error) && (nil != httpResponse) && (200 == httpResponse.statusCode)) {
////            NSDictionary *dataStruct =
////            [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
////            //NSLog(@"%@", dataStruct);
////            if (nil != dataStruct) {
////                NSNumber *pageNumber = dataStruct[@"result"][@"page"];
////                [self setNumber:pageNumber forKey:DFK_PAGE_NUMBER];
////
////                NSArray *deploys = dataStruct[@"result"][@"deploys"];
////                NSMutableArray<DeploymentDetails *> *deployments =
////                [NSMutableArray<DeploymentDetails *> arrayWithCapacity:deploys.count];
////                [deploys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////                    DeploymentDetails *deploymentDetails =
////                    [[DeploymentDetails alloc] initWithJSONData:obj];
////                    [deployments addObject:deploymentDetails];
////                }];
////                [self setArray:deployments forKey:DFK_DEPLOYMENTS];
////            }
////        }
////    }
//    return self;
//}

@end
