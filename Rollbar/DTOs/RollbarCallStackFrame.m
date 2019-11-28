//
//  RollbarCallStackFrame.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-27.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarCallStackFrame.h"

static NSString * const DFK_FILENAME = @"filename";
static NSString * const DFK_LINE_NO = @"lineno";
static NSString * const DFK_COL_NO = @"colno";
static NSString * const DFK_METHOD = @"method";
static NSString * const DFK_CODE = @"code";
static NSString * const DFK_CLASS_NAME = @"class_name";
static NSString * const DFK_CONTEXT = @"context";
static NSString * const DFK_ARGSPEC = @"argspec";
static NSString * const DFK_VARARGSPEC = @"varargspec";
static NSString * const DFK_KEYWORDSPEC = @"keywordspec";
static NSString * const DFK_LOCALS = @"locals";
// depricated:
static NSString * const DFK_ARGS = @"args";
static NSString * const DFK_KWARGS = @"kwargs";

@implementation RollbarCallStackFrame

@end
