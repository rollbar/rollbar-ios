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
               readAccessToken:(NSString *)readAccessToken {
    self = [super init];
    if (nil != self) {
        self.writeAccessToken = writeAccessToken;
        self.readAccessToken = readAccessToken;
    }
    return self;
}

- (id)init {
    return [self initWithWriteAccessToken:nil readAccessToken:nil];
}

- (void)getDeploymentUsing:(NSString *)deployId {
    //...
}

- (void)getDeploymentsPageForEnvironment:(NSString *)environmentId
                         usingPageNumber:(NSUInteger)pageNumber {
    //...
}

- (void)registerDeployment:(Deployment *)deployment {
    NSString * const url = @"https://api.rollbar.com/api/1/deploy/";
    //NSString * const writeAccessToken = @"2d6e0add5d9b403d9126b4bcea7e0199"; //@"17965fa5041749b6bf7095a190001ded";
    NSString * const readAccessToken = @"8c2982e875544037b51870d558f51ed3";
    
    NSMutableDictionary *params =
        [[NSMutableDictionary alloc] initWithDictionary:deployment.asJSONData];
    [params setObject:self.writeAccessToken forKey:@"access_token"];
    [self sendPostRequest:params toUrl:url];
}

-(void)sendGetRequest:(NSDictionary *)params toUrl:(NSString *)urlString {
    responseData = [[NSMutableData alloc]init];
    NSMutableString *paramString = [NSMutableString stringWithString:@"?"];
    NSArray *keys = [params allKeys];
    for (NSString *key in keys) {
        [paramString appendFormat:@"%@=%@&", key, [params valueForKey:key]];
    }
    NSString *urlRequest =
        [NSString stringWithFormat:@"%@%@", urlString, [paramString substringToIndex:[paramString length]-1]];
    NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequest]];
    [request setHTTPMethod:@"GET"];
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:self];
}

-(BOOL)sendPostRequest:(NSDictionary *)params toUrl:(NSString *)urlString {
//    responseData = [[NSMutableData alloc]init];
//    NSMutableString *paramString = [NSMutableString stringWithString:@""];
//    NSArray *keys = [params allKeys];
//    for (NSString *key in keys) {
//        [paramString appendFormat:@"%@=%@&", key, [params valueForKey:key]];
//    }
//    NSString *postString = @"";
//    if ([paramString length] > 0)
//        postString = [paramString substringToIndex:[paramString length]-1];
//    NSMutableURLRequest *request =
//        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
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
    //if (true) {
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
                       result = [self checkPayloadResponse:response error:error data:data];
                       dispatch_semaphore_signal(sem);
                   }];
        [dataTask resume];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    } else {
        // Using method sendSynchronousRequest, deprecated since iOS 9.0
        NSError *error;
        NSHTTPURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        result = [self checkPayloadResponse:response error:error data:data];
    }
    
    return result;
}

- (BOOL)checkPayloadResponse:(NSURLResponse*)response
                       error:(NSError*)error
                        data:(NSData*)data {
    if (error) {
        NSLog(@"There was an error reporting to Rollbar");
        NSLog(@"Error: %@", [error localizedDescription]);
    } else {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if ([httpResponse statusCode] == 200) {
            NSLog(@"Success");
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
// HTTP communication callbacks:
////////////////////////////////

//#define WEBSERVICENOTIFICATIONSUCCESS @"WebserviceConnectSuccess"
//#define WEBSERVICENOTIFICATIONERROR @"WebserviceConnectError"
//
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"Received Response - WebServiceConnect");
//    [responseData setLength:0];
//}
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [responseData appendData:data];
//    NSString*tmp = [[NSString alloc] initWithData:responseData
//                                         encoding:NSUTF8StringEncoding];
//    NSLog(@"Resonse so far:  %@", tmp);
//}
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:WEBSERVICENOTIFICATIONERROR
//                                                        object: error ];
//}
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSString *res = [[NSString alloc] initWithData:responseData
//                                          encoding:NSUTF8StringEncoding];
//    NSLog(@"Results:  '%@'", res);
//    [[NSNotificationCenter defaultCenter] postNotificationName:WEBSERVICENOTIFICATIONSUCCESS
//                                                        object:res];
//}
//- (NSURLRequest *)connection:(NSURLConnection *)connection
//             willSendRequest:(NSURLRequest *)request
//            redirectResponse:(NSURLResponse *)redirectResponse;
//{
//    NSLog(@"Redirecting:  %@", request.URL);
//    return request;
//}
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
//                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
//    NSLog(@"Cache response...");
//    return nil;
//}
@end
