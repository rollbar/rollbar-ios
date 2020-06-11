//
//  RollbarHttpMethod.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarHttpMethod.h"

@implementation RollbarHttpMethodUtil

+ (NSString *) HttpMethodToString:(RollbarHttpMethod)value {
    switch (value) {
        case RollbarHttpMethod_Head:
            return @"HEAD";
        case RollbarHttpMethod_Get:
            return @"GET";
        case RollbarHttpMethod_Post:
            return @"POST";
        case RollbarHttpMethod_Put:
            return @"Put";
        case RollbarHttpMethod_Patch:
            return @"PATCH";
        case RollbarHttpMethod_Delete:
            return @"DELETE";
        case RollbarHttpMethod_Connect:
            return @"CONNECT";
        case RollbarHttpMethod_Options:
            return @"OPTIONS";
        case RollbarHttpMethod_Trace:
            return @"TRACE";
        default:
            return @"UNKNOWN";
    }
}

+ (RollbarHttpMethod) HttpMethodFromString:(NSString *)value {
    if (NSOrderedSame == [value caseInsensitiveCompare:@"HEAD"]) {
        return RollbarHttpMethod_Head;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"GET"]) {
        return RollbarHttpMethod_Get;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"POST"]) {
        return RollbarHttpMethod_Post;
    }
    if (NSOrderedSame == [value caseInsensitiveCompare:@"PUT"]) {
        return RollbarHttpMethod_Put;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"PATCH"]) {
        return RollbarHttpMethod_Patch;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"DELETE"]) {
        return RollbarHttpMethod_Delete;
    }
    if (NSOrderedSame == [value caseInsensitiveCompare:@"CONNECT"]) {
        return RollbarHttpMethod_Connect;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"OPTIONS"]) {
        return RollbarHttpMethod_Options;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"TRACE"]) {
        return RollbarHttpMethod_Trace;
    }
    else {
        return RollbarHttpMethod_Trace; // default case...
    }
}

@end
