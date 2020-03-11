//
//  HttpMethod.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "HttpMethod.h"

@implementation HttpMethodUtil

+ (NSString *) HttpMethodToString:(HttpMethod)value {
    switch (value) {
        case Head:
            return @"HEAD";
        case Get:
            return @"GET";
        case Post:
            return @"POST";
        case Put:
            return @"Put";
        case Patch:
            return @"PATCH";
        case Delete:
            return @"DELETE";
        case Connect:
            return @"CONNECT";
        case Options:
            return @"OPTIONS";
        case Trace:
            return @"TRACE";
        default:
            return @"UNKNOWN";
    }
}

+ (HttpMethod) HttpMethodFromString:(NSString *)value {
    if (NSOrderedSame == [value caseInsensitiveCompare:@"HEAD"]) {
        return Head;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"GET"]) {
        return Get;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"POST"]) {
        return Post;
    }
    if (NSOrderedSame == [value caseInsensitiveCompare:@"PUT"]) {
        return Put;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"PATCH"]) {
        return Patch;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"DELETE"]) {
        return Delete;
    }
    if (NSOrderedSame == [value caseInsensitiveCompare:@"CONNECT"]) {
        return Connect;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"OPTIONS"]) {
        return Options;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"TRACE"]) {
        return Trace;
    }
    else {
        return Trace; // default case...
    }
}

@end
