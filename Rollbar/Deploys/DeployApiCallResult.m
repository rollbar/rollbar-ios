//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#import "DeployApiCallResult.h"

@implementation DeployApiCallResult

static NSString * const PROPERTY_outcome = @"outcome";
static NSString * const PROPERTY_description = @"description";

- (DeployApiCallOutcome)outcome {
    return [[self.dataDictionary objectForKey:PROPERTY_outcome] intValue];
}

- (NSString *)description {
    return (NSString *) [self.dataDictionary objectForKey:PROPERTY_description];
}

// Designated Initializer:
- (id)initWithResponse:(NSHTTPURLResponse*)httpResponse
                  data:(NSData*)data
                 error:(NSError*)error
            forRequest:(NSURLRequest*)request {
    self = [super init];
    if (nil != self) {
        if (error) {
            [self.dataDictionary setObject:[NSNumber numberWithInt:DeployApiCallError]
                                    forKey:PROPERTY_outcome];
            NSString *description =
            [NSString stringWithFormat:@"Rollbar Deploy API communication error: %@",[error localizedDescription]];
            [self.dataDictionary setObject:description
                                    forKey:PROPERTY_description];
        }
        if (nil != httpResponse) {
            if (200 == httpResponse.statusCode) {
                [self.dataDictionary setObject:[NSNumber numberWithInt:DeployApiCallSuccess]
                                        forKey:PROPERTY_outcome];
            }
            else {
                [self.dataDictionary setObject:[NSNumber numberWithInt:DeployApiCallError]
                                        forKey:PROPERTY_outcome];
            }
            NSMutableString *description =
            [NSMutableString stringWithFormat:@"HTTP Status Code: %ldi and Description: %@",(long)httpResponse.statusCode,[NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]];
            if (data) {
                [description appendFormat:@"\n\rResponse data:\n\r\%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
            }
            [self.dataDictionary setObject:description
                                    forKey:PROPERTY_description];
        }
    }
    return self;
}

@end

@implementation DeploymentRegistrationResult

static NSString * const PROPERTY_deplymentId = @"deploymentId";

- (NSString *)deploymentId {
    return (NSString *) [self.dataDictionary objectForKey:PROPERTY_deplymentId];
}

// Designated Initializer:
- (id)initWithResponse:(NSHTTPURLResponse*)httpResponse
                  data:(NSData*)data
                 error:(NSError*)error
            forRequest:(NSURLRequest*)request {
    
    self = [super initWithResponse:httpResponse
                              data:data
                             error:error
                        forRequest:request
            ];
    if (nil != self) {
        if ((nil == error) && (nil != httpResponse) && (200 == httpResponse.statusCode)) {
            NSDictionary *dataStruct =
            [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (nil != dataStruct) {
                NSNumber *deploy_id = dataStruct[@"data"][@"deploy_id"];
                [self.dataDictionary setObject:[deploy_id stringValue]
                                        forKey:PROPERTY_deplymentId];
            }
        }
    }
    return self;
}

@end

@implementation DeploymentDetailsResult

static NSString * const PROPERTY_deployment = @"deployment";

- (DeploymentDetails *)deployment {
    return (DeploymentDetails *) [self.dataDictionary objectForKey:PROPERTY_deployment];
}

// Designated Initializer:
- (id)initWithResponse:(NSHTTPURLResponse*)httpResponse
                  data:(NSData*)data
                 error:(NSError*)error
            forRequest:(NSURLRequest*)request {
    
    self = [super initWithResponse:httpResponse
                              data:data
                             error:error
                        forRequest:request
            ];
    if (nil != self) {
        if ((nil == error) && (nil != httpResponse) && (200 == httpResponse.statusCode)) {
            NSDictionary *dataStruct =
            [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"%@", dataStruct);
            if (nil != dataStruct) {
                DeploymentDetails *deploymentDetails =
                [[DeploymentDetails alloc] initWithJSONData:dataStruct[@"result"]];
                [self.dataDictionary setObject:deploymentDetails
                                        forKey:PROPERTY_deployment
                 ];
            }
        }
    }
    return self;
}

@end

@implementation DeploymentDetailsPageResult

static NSString * const PROPERTY_deployments = @"deployments";
static NSString * const PROPERTY_pageNumber = @"page";

- (NSSet<DeploymentDetails *> *)deployments {
    return (NSSet<DeploymentDetails *> *) [self.dataDictionary objectForKey:PROPERTY_deployments];
}
- (NSNumber*)pageNumber {
    return (NSNumber*) [self.dataDictionary objectForKey:PROPERTY_pageNumber];
}

// Designated Initializer:
- (id)initWithResponse:(NSHTTPURLResponse*)httpResponse
                  data:(NSData*)data
                 error:(NSError*)error
            forRequest:(NSURLRequest*)request {
    
    self = [super initWithResponse:httpResponse
                              data:data
                             error:error
                        forRequest:request
            ];
    if (nil != self) {
        if ((nil == error) && (nil != httpResponse) && (200 == httpResponse.statusCode)) {
            NSDictionary *dataStruct =
            [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"%@", dataStruct);
            if (nil != dataStruct) {
                NSNumber *pageNumber = dataStruct[@"result"][@"page"];
                [self.dataDictionary setObject:pageNumber
                                        forKey:PROPERTY_pageNumber
                 ];
                NSArray *deploys = dataStruct[@"result"][@"deploys"];
                NSMutableSet<DeploymentDetails *> *deployments =
                [[NSMutableSet<DeploymentDetails *> alloc] initWithCapacity:deploys.count];
                [deploys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    DeploymentDetails *deploymentDetails =
                    [[DeploymentDetails alloc] initWithJSONData:obj];
                    [deployments addObject:deploymentDetails];
                }];
                [self.dataDictionary setObject:deployments
                                        forKey:PROPERTY_deployments
                 ];
            }
        }
    }
    return self;
}

@end
