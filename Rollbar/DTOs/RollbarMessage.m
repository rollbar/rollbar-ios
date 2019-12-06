//
//  RollbarMessage.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-27.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarMessage.h"
#import "DataTransferObject+Protected.h"
#import <Foundation/Foundation.h>

static NSString * const DFK_BODY = @"body";

@implementation RollbarMessage

#pragma mark - properties

- (NSString *)body {
    return [self safelyGetStringByKey:DFK_BODY];
}

- (void)setBody:(NSString *)messageBody {
    [self setString:messageBody forKey:DFK_BODY];
}

#pragma mark - Initializers

-(instancetype)initWithBody:(nonnull NSString *)messageBody {
    
    self = [super initWithDictionary:@{
        DFK_BODY:messageBody
    }];
    return self;
}

@end
