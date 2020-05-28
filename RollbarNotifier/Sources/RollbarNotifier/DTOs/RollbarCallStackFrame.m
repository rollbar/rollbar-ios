//
//  RollbarCallStackFrame.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-27.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarCallStackFrame.h"
//@import RollbarCommon;
#import "RollbarCallStackFrameContext.h"

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

@implementation RollbarCallStackFrame

#pragma mark - Properties

-(nonnull NSString *)filename {
    return [self getDataByKey:DFK_FILENAME];
}

-(void)setFilename:(nonnull NSString *)value {
    [self setData:value byKey:DFK_FILENAME];
}

-(nullable NSNumber *)lineno {
    return [self getDataByKey:DFK_LINE_NO];
}

-(void)setLineno:(nullable NSNumber *)value {
    [self setData:value byKey:DFK_LINE_NO];
}

-(nullable NSNumber *)colno {
    return [self getDataByKey:DFK_COL_NO];
}

-(void)setColno:(nullable NSNumber *)value {
    [self setData:value byKey:DFK_COL_NO];
}

-(nullable NSString *)method {
    return [self getDataByKey:DFK_METHOD];
}

-(void)setMethod:(nullable NSString *)value {
    [self setData:value byKey:DFK_METHOD];
}

-(nullable NSString *)code {
    return [self getDataByKey:DFK_CODE];
}

-(void)setCode:(nullable NSString *)value {
    [self setData:value byKey:DFK_CODE];
}

-(nullable NSString *)className {
    return [self getDataByKey:DFK_CLASS_NAME];
}

-(void)setClassName:(nullable NSString *)value {
    [self setData:value byKey:DFK_CLASS_NAME];
}

-(nullable RollbarCallStackFrameContext *)context {
    NSDictionary *data = [self getDataByKey:DFK_CONTEXT];
    if (data) {
        return [[RollbarCallStackFrameContext alloc] initWithDictionary:data];
    }
    return nil;
}

-(void)setContext:(nullable RollbarCallStackFrameContext *)context {
    [self setData:context.jsonFriendlyData byKey:DFK_CONTEXT];
}

-(nullable NSArray<NSString *> *)argspec {
    return [self getDataByKey:DFK_ARGSPEC];
}

-(void)setArgspec:(nullable NSArray<NSString *> *)value {
    [self setData:value byKey:DFK_ARGSPEC];
}

-(nullable NSArray<NSString *> *)varargspec {
    return [self getDataByKey:DFK_VARARGSPEC];
}

-(void)setVarargspec:(nullable NSArray<NSString *> *)value {
    [self setData:value byKey:DFK_VARARGSPEC];
}

-(nullable NSArray<NSString *> *)keywordspec {
    return [self getDataByKey:DFK_KEYWORDSPEC];
}

-(void)setKeywordspec:(nullable NSArray<NSString *> *)value {
    [self setData:value byKey:DFK_KEYWORDSPEC];
}

-(nullable NSDictionary *)locals {
    return [self getDataByKey:DFK_LOCALS];
}

-(void)setLocals:(nullable NSDictionary *)value {
    [self setData:value byKey:DFK_LOCALS];
}

#pragma mark - Initializers

-(instancetype)initWithFileName:(nonnull NSString *)filename {
    
    self = [super initWithDictionary:@{
        DFK_FILENAME: filename ? filename : [NSNull null]
    }];
    return self;
}

@end
