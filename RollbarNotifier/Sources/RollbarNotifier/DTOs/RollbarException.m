//
//  RollbarException.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-27.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarException.h"
//#import "DataTransferObject+Protected.h"

static NSString * const DFK_CLASS = @"class";
static NSString * const DFK_MESSAGE = @"message";
static NSString * const DFK_DESCRIPTION = @"description";

@implementation RollbarException

#pragma mark - Properties

- (nonnull NSString *)exceptionClass {
    return [self getDataByKey:DFK_CLASS];
}

- (void)setExceptionClass:(nonnull NSString *)exceptionClass {
    [self setData:exceptionClass byKey:DFK_CLASS];
}

- (nullable NSString *)exceptionMessage {
    return [self getDataByKey:DFK_MESSAGE];
}

- (void)setExceptionMessage:(nullable NSString *)exceptionMessage {
    [self setData:exceptionMessage byKey:DFK_MESSAGE];
}

- (nullable NSString *)exceptionDescription {
    return [self getDataByKey:DFK_DESCRIPTION];
}

- (void)setExceptionDescription:(nullable NSString *)exceptionDescription {
    [self setData:exceptionDescription byKey:DFK_DESCRIPTION];
}

#pragma mark - Initializers

- (instancetype)initWithExceptionClass:(nonnull NSString *)exceptionClass
                      exceptionMessage:(nullable NSString *)exceptionMessage
                  exceptionDescription:(nullable NSString *)exceptionDescription {
    
    self = [super initWithDictionary:@{
        DFK_CLASS: exceptionClass ? exceptionClass : [NSNull null],
        DFK_MESSAGE: exceptionMessage ? exceptionMessage : [NSNull null],
        DFK_DESCRIPTION: exceptionDescription ? exceptionDescription : [NSNull null]
    }];
    
    return self;
}

@end
