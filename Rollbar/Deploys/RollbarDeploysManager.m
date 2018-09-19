//
//  RollbarDeploysManager.m
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#include <sys/utsname.h>
#import "NSJSONSerialization+Rollbar.h"
#import "RollbarDeploysManager.h"

#define IS_IOS7_OR_HIGHER (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)

@interface RollbarDeploysManager()
@property (readwrite, retain) NSString *writeAccessToken;
@property (readwrite, retain) NSString *readAccessToken;
@end

@implementation RollbarDeploysManager

- (id)initWithWriteAccessToken:(NSString *)writeAccessToken
               readAccessToken:(NSString *)readAccessToken
deploymentRegistrationObserver:(NSObject<DeploymentRegistrationObserver>*)deploymentRegistrationObserver
     deploymentDetailsObserver:(NSObject<DeploymentDetailsObserver>*)deploymentDetailsObserver
 deploymentDetailsPageObserver:(NSObject<DeploymentDetailsPageObserver>*)deploymentDetailsPageObserver {
    self = [super init];
    if (nil != self) {
        self.writeAccessToken = writeAccessToken;
        self.readAccessToken = readAccessToken;
        _deploymentRegistrationObserver = deploymentRegistrationObserver;
        _deploymentDetailsObserver = deploymentDetailsObserver;
        _deploymentDetailsPageObserver = deploymentDetailsPageObserver;
    }
    return self;
}

- (id)init {
    return [self initWithWriteAccessToken:nil
                          readAccessToken:nil
           deploymentRegistrationObserver:nil
                deploymentDetailsObserver:nil
            deploymentDetailsPageObserver:nil
            ];
}

- (void)getDeploymentWithDeployId:(NSString *)deployId {
    NSString * const url = @"https://api.rollbar.com/api/1/deploy/";
    
    NSString * const getUrl =
        [NSString stringWithFormat:@"%@%@/?access_token=%@",url,deployId,self.readAccessToken];
    [self sendGetRequestToUrl:getUrl];
}

- (void)getDeploymentsPageNumber:(NSUInteger)pageNumber {
    NSString * const url = @"https://api.rollbar.com/api/1/deploys/";
    
    NSString * const getUrl =
    [NSString stringWithFormat:@"%@?access_token=%@&page=%lu",url,self.readAccessToken,(unsigned long)pageNumber];
//    [NSString stringWithFormat:@"%@?access_token=%@&environment=%@&page=%lu",url,self.readAccessToken,environmentId,(unsigned long)pageNumber];
    [self sendGetRequestToUrl:getUrl];
}

- (void)registerDeployment:(Deployment *)deployment {
    NSString * const url = @"https://api.rollbar.com/api/1/deploy/";
    //NSString * const readAccessToken = @"8c2982e875544037b51870d558f51ed3";
    
    NSMutableDictionary *params =
        [[NSMutableDictionary alloc] initWithDictionary:deployment.asJSONData];
    [params setObject:self.writeAccessToken forKey:@"access_token"];
    [self sendPostRequest:params toUrl:url];
}

-(BOOL)sendGetRequestToUrl:(NSString *)urlString {
//-(BOOL)sendGetRequest:(NSDictionary *)params toUrl:(NSString *)urlString {
//    responseData = [[NSMutableData alloc]init];
//    NSMutableString *paramString = [NSMutableString stringWithString:@"?"];
//    NSArray *keys = [params allKeys];
//    for (NSString *key in keys) {
//        [paramString appendFormat:@"%@=%@&", key, [params valueForKey:key]];
//    }
//    NSString *urlRequest =
//        [NSString stringWithFormat:@"%@%@", urlString, [paramString substringToIndex:[paramString length]-1]];
//    NSMutableURLRequest *request =
//        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequest]];
//    [request setHTTPMethod:@"GET"];
//    [[NSURLConnection alloc] initWithRequest:request
//                                    delegate:self];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[params valueForKey:@"access_token"] forHTTPHeaderField:@"X-Rollbar-Access-Token"];
//
//    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:params
//                                                          options:NSJSONWritingPrettyPrinted
//                                                            error:nil
//                                                             safe:true];
//    [request setHTTPBody:jsonPayload];
    
    __block BOOL result = NO;
    if (IS_IOS7_OR_HIGHER) {
        // This requires iOS 7.0+
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        //        if (self.configuration.httpProxyEnabled
        //            || self.configuration.httpsProxyEnabled) {
        //
        //            NSDictionary *connectionProxyDictionary =
        //            @{
        //              @"HTTPEnable"   : [NSNumber numberWithInt:self.configuration.httpProxyEnabled],
        //              @"HTTPProxy"    : self.configuration.httpProxy,
        //              @"HTTPPort"     : self.configuration.httpProxyPort,
        //              @"HTTPSEnable"  : [NSNumber numberWithInt:self.configuration.httpsProxyEnabled],
        //              @"HTTPSProxy"   : self.configuration.httpsProxy,
        //              @"HTTPSPort"    : self.configuration.httpsProxyPort
        //              };
        //
        //            NSURLSessionConfiguration *sessionConfig =
        //            [NSURLSessionConfiguration ephemeralSessionConfiguration];
        //            sessionConfig.connectionProxyDictionary = connectionProxyDictionary;
        //            session = [NSURLSession sessionWithConfiguration:sessionConfig];
        //        }
        
        NSURLSessionDataTask *dataTask =
        [session dataTaskWithRequest:request
                   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                       result = [self checkResponse:response error:error data:data forRequest:request];
                       dispatch_semaphore_signal(sem);
                   }];
        [dataTask resume];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    } else {
        // Using method sendSynchronousRequest, deprecated since iOS 9.0
        NSError *error;
        NSHTTPURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        result = [self checkResponse:response error:error data:data forRequest:request];
    }
    
    return result;

}

-(BOOL)sendPostRequest:(NSDictionary *)params toUrl:(NSString *)urlString {

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[params valueForKey:@"access_token"] forHTTPHeaderField:@"X-Rollbar-Access-Token"];
    
    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:params
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:nil
                                                             safe:true];
    [request setHTTPBody:jsonPayload];
    
    __block BOOL result = NO;
    if (IS_IOS7_OR_HIGHER) {
        // This requires iOS 7.0+
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        
        NSURLSession *session = [NSURLSession sharedSession];
        
//        if (self.configuration.httpProxyEnabled
//            || self.configuration.httpsProxyEnabled) {
//
//            NSDictionary *connectionProxyDictionary =
//            @{
//              @"HTTPEnable"   : [NSNumber numberWithInt:self.configuration.httpProxyEnabled],
//              @"HTTPProxy"    : self.configuration.httpProxy,
//              @"HTTPPort"     : self.configuration.httpProxyPort,
//              @"HTTPSEnable"  : [NSNumber numberWithInt:self.configuration.httpsProxyEnabled],
//              @"HTTPSProxy"   : self.configuration.httpsProxy,
//              @"HTTPSPort"    : self.configuration.httpsProxyPort
//              };
//        
//            NSURLSessionConfiguration *sessionConfig =
//            [NSURLSessionConfiguration ephemeralSessionConfiguration];
//            sessionConfig.connectionProxyDictionary = connectionProxyDictionary;
//            session = [NSURLSession sessionWithConfiguration:sessionConfig];
//        }
        
        NSURLSessionDataTask *dataTask =
        [session dataTaskWithRequest:request
                   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                       result = [self checkResponse:response error:error data:data forRequest:request];
                       dispatch_semaphore_signal(sem);
                   }];
        [dataTask resume];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    } else {
        // Using method sendSynchronousRequest, deprecated since iOS 9.0
        NSError *error;
        NSHTTPURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        result = [self checkResponse:response error:error data:data forRequest:request];
    }
    
    return result;
}

- (BOOL)checkResponse:(NSURLResponse*)response
                error:(NSError*)error
                 data:(NSData*)data
           forRequest:(NSMutableURLRequest*)request {
    
    if ((nil == request) || (nil == request.URL)) {
        return NO;
    }
    
    NSString *requestHttpMethod = request.HTTPMethod;
    NSString *requestUrl = request.URL.absoluteString;
    
    if (([requestHttpMethod caseInsensitiveCompare:@"POST"] == NSOrderedSame)
        && [requestUrl hasSuffix:@"/deploy/"]) {
        //call deploy reqistration callback...
    }
    else if (([requestHttpMethod caseInsensitiveCompare:@"GET"] == NSOrderedSame)
             && [requestUrl hasSuffix:@"/deploy/"]) {
        //call deploy details by deploy ID callback...
    }
    else if (([requestHttpMethod caseInsensitiveCompare:@"GET"] == NSOrderedSame)
             && [requestUrl hasSuffix:@"/deploys/"]) {
        //call deploys page callback...
    }

    
    if (error) {
        NSLog(@"There was an error reporting to Rollbar");
        NSLog(@"Error: %@", [error localizedDescription]);
    } else {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if ([httpResponse statusCode] == 200) {
            NSLog(@"Success");
            
            NSDictionary *headers = httpResponse.allHeaderFields;
            NSLog(@"Response: %@", httpResponse);

            if (data) {
                // decode data:
                NSLog(@"Response data: %@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
            }

            return YES;
        } else {
            NSLog(@"There was a problem reporting to Rollbar");
            if (data) {
                NSLog(@"Response: %@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
            }
        }
    }
    return NO;
}
@end
