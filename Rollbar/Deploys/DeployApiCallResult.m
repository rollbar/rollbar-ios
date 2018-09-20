//
//  ApiCallResult.m
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

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

+ (id)createForRequest:(NSURLRequest*)request
          withResponse:(NSHTTPURLResponse*)httpResponse
                  data:(NSData*)data
                 error:(NSError*)error {
    
    if ((nil == request) || (nil == request.URL)) {
        return nil;
    }
    
    NSString *requestHttpMethod = request.HTTPMethod;
    NSString *requestUrl = request.URL.absoluteString;
    if (([requestHttpMethod caseInsensitiveCompare:@"POST"] == NSOrderedSame)
        && [requestUrl hasSuffix:@"/deploy/"]) {
        //call deploy reqistration callback...
    }
    else if (([requestHttpMethod caseInsensitiveCompare:@"GET"] == NSOrderedSame)
             && [requestUrl hasSuffix:@"/deploy/"]) {
        return [[DeploymentRegistrationResult alloc] initWithResponse:httpResponse
                                                                 data:data
                                                                error:error
                                                           forRequest:request
                ];
    }
    else if (([requestHttpMethod caseInsensitiveCompare:@"GET"] == NSOrderedSame)
             && [requestUrl hasSuffix:@"/deploys/"]) {
        //call deploys page callback...
    }
    
    return nil;
}

// Designated Initializer:
- (id)initWithResponse:(NSHTTPURLResponse*)httpResponse
                  data:(NSData*)data
                 error:(NSError*)error
            forRequest:(NSURLRequest*)request {
    self = [super init];
    if (nil != self) {
        if (error) {
            [self.dataDictionary setObject:[NSNumber numberWithInt:Outcome_Error]
                                    forKey:PROPERTY_outcome];
            NSString *description =
            [NSString stringWithFormat:@"Rollbar Deploy API communication error: %@",[error localizedDescription]];
            [self.dataDictionary setObject:description
                                    forKey:PROPERTY_description];
        }
        if (nil != httpResponse) {
            if (200 == httpResponse.statusCode) {
                [self.dataDictionary setObject:[NSNumber numberWithInt:Outcome_Success]
                                        forKey:PROPERTY_outcome];
            }
            else {
                [self.dataDictionary setObject:[NSNumber numberWithInt:Outcome_Error]
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

static NSString * const PROPERTY_deplyment = @"deployment";

- (DeploymentDetails *)deployment {
    return (DeploymentDetails *) [self.dataDictionary objectForKey:PROPERTY_deplyment];
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
            NSLog(@"%@", dataStruct);
            if (nil != dataStruct) {
                DeploymentDetails *deploymentDetails =
                [[DeploymentDetails alloc] initWithJSONData:dataStruct];
                [self.dataDictionary setObject:deploymentDetails
                                        forKey:PROPERTY_deplyment
                 ];
            }
        }
    }
    return self;
}

@end

@implementation DeploymentDetailsPageResult

static NSString * const PROPERTY_deplyments = @"deployments";

- (NSSet<DeploymentDetails *> *)deployments {
    return (NSSet<DeploymentDetails *> *) [self.dataDictionary objectForKey:PROPERTY_deplyments];
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
            //            [self.dataDictionary setObject:[NSNumber numberWithInt:Outcome_Error]
            //                                    forKey:PROPERTY_outcome];
        }
    }
    return self;
}

@end

