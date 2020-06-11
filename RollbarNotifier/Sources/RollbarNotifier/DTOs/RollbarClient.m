//
//  RollbarClient.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarClient.h"
//@import RollbarCommon;
#import "RollbarJavascript.h"

#pragma mark - data field keys

static NSString *const DFK_CPU = @"cpu";
static NSString *const DFK_JAVASCRIPT = @"javascript";

@implementation RollbarClient

#pragma mark - Properies

-(nullable NSString *)cpu {
    return [self getDataByKey:DFK_CPU];
}

-(void)setCpu:(nullable NSString *)cpu {
    [self setData:cpu byKey:DFK_CPU];
}

-(nullable RollbarJavascript *)javaScript {
    id data = [self getDataByKey:DFK_JAVASCRIPT];
    if (data) {
        return [[RollbarJavascript alloc] initWithDictionary:data];
    }
    return nil;
}

-(void)setJavaScript:(nullable RollbarJavascript *)javaScript {
    [self setData:javaScript.jsonFriendlyData byKey:DFK_JAVASCRIPT];
}

#pragma mark - Initializers

-(instancetype)initWithCpu:(nullable NSString *)cpu
                javaScript:(nullable RollbarJavascript *)javaScript {
    
    self = [super initWithDictionary:@{
        DFK_CPU: cpu ? cpu: [NSNull null],
        DFK_JAVASCRIPT: javaScript ? javaScript.jsonFriendlyData : [NSNull null]
    }];
    return self;
}

@end
