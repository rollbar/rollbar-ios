//
//  RollbarTrace.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-27.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarTrace.h"
#import "DataTransferObject+Protected.h"
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
    return nil;
}

-(void)setFrames:(nonnull NSArray<RollbarCallStackFrame *> *)frames {
    
    [self setData:[self getJsonFriendlyDataFromFrames:frames] byKey:DFK_FRAMES];
}

-(nonnull RollbarException *)exception {
    NSDictionary *data = [self getDataByKey:DFK_EXCEPTION];
    if (data) {
        return [[RollbarException alloc] initWithDictionary:data];
    }
    return nil;
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

@end
