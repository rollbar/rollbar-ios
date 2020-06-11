//
//  RollbarTrace.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-27.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarTrace.h"
//#import "DataTransferObject+Protected.h"
//#import "DataTransferObject+CustomData.h"
#import "RollbarCallStackFrame.h"
#import "RollbarException.h"

static NSString * const DFK_FRAMES = @"frames";
static NSString * const DFK_EXCEPTION = @"exception";

@implementation RollbarTrace

#pragma mark - Properties

-(nonnull NSArray<RollbarCallStackFrame *> *)frames {
    
    NSArray *dataArray = [self getDataByKey:DFK_FRAMES];
    if (dataArray) {
        NSMutableArray<RollbarCallStackFrame *> *result = [NSMutableArray arrayWithCapacity:dataArray.count];
        for(NSDictionary *data in dataArray) {
            if (data) {
                [result addObject:[[RollbarCallStackFrame alloc] initWithDictionary:data]];
            }
        }
        return result;
    }
    return [NSMutableArray array];
}

-(void)setFrames:(nonnull NSArray<RollbarCallStackFrame *> *)frames {
    
    [self setData:[self getJsonFriendlyDataFromFrames:frames] byKey:DFK_FRAMES];
}

-(nonnull RollbarException *)exception {
    NSDictionary *data = [self getDataByKey:DFK_EXCEPTION];
    if (!data) {
        data = [NSMutableDictionary dictionary];
    }
    return [[RollbarException alloc] initWithDictionary:data];
}

-(void)setException:(nonnull RollbarException *)exception {
    if(exception) {
        [self setData:exception.jsonFriendlyData byKey:DFK_EXCEPTION];
    }
    else {
        [self setData:nil byKey:DFK_EXCEPTION];
    }
}

#pragma mark - Initializers

-(instancetype)initWithRollbarException:(nonnull RollbarException *)exception
                 rollbarCallStackFrames:(nonnull NSArray<RollbarCallStackFrame *> *)frames {
    
    NSArray *framesData = [self getJsonFriendlyDataFromFrames:frames];
    self = [super initWithDictionary:@{
        DFK_EXCEPTION: exception ? exception.jsonFriendlyData : [NSNull null],
        DFK_FRAMES: framesData ? framesData : [NSNull null]
    }];
    return self;
}

-(instancetype)initWithException:(nonnull NSException *)exception {
    
    RollbarException *exceptionDto =
    [[RollbarException alloc] initWithExceptionClass:NSStringFromClass([exception class])
                                    exceptionMessage:exception.reason
                                exceptionDescription:exception.description];
    [exceptionDto tryAddKeyed:@"user_info" Object:exception.userInfo];
    
    NSMutableArray<RollbarCallStackFrame *> *frames = [NSMutableArray array];
    for (NSString *line in exception.callStackSymbols) {
        NSMutableArray *components =
        [NSMutableArray arrayWithArray:
         [line componentsSeparatedByCharactersInSet:
          [NSCharacterSet characterSetWithCharactersInString:@" "]]];
        [components removeObject:@""];
        [components removeObjectAtIndex:0];
        if (components.count >= 4) {
            NSString *method = [self methodNameFromStackTrace:components];
            NSString *filename = [components componentsJoinedByString:@" "];
            RollbarCallStackFrame *frame = [[RollbarCallStackFrame alloc] initWithFileName:filename];
            frame.method = method;
            frame.lineno = components[components.count-1];
            [frame tryAddKeyed:@"library" Object:components[0]];
            [frame tryAddKeyed:@"address" Object:components[1]];

            [frames addObject:frame];
        }
    }
    
    self = [self initWithRollbarException:exceptionDto rollbarCallStackFrames:frames];
    return self;
}

#pragma mark - Private methods

-(NSArray *)getJsonFriendlyDataFromFrames:(NSArray<RollbarCallStackFrame *> *)frames {
    if (frames) {
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:frames.count];
        for(RollbarCallStackFrame *frame in frames) {
            if (frame) {
                [data addObject:frame.jsonFriendlyData];
            }
        }
        return data;
    }
    else {
        return nil;
    }
}

- (NSString*)methodNameFromStackTrace:(NSArray*)stackTraceComponents {
    int start = false;
    NSString *buf;
    for (NSString *component in stackTraceComponents) {
        if (!start && [component hasPrefix:@"0x"]) {
            start = true;
        } else if (start && [component isEqualToString:@"+"]) {
            break;
        } else if (start) {
            buf =
            buf ? [NSString stringWithFormat:@"%@ %@", buf, component]
            : component;
        }
    }
    return buf ? buf : @"Unknown";
}

@end
