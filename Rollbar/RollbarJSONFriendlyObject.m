//
//  RollbarJSONFriendlyObject.m
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RollbarJSONFriendlyObject.h"

@implementation RollbarJSONFriendlyObject

@synthesize dataDictionary = _dataDictionary;
- (NSMutableDictionary *)dataDictionary {
    return _dataDictionary;
}
- (id)initWithJSONData:(NSDictionary *)jsonData {
    self = [super init];
    if (nil != self) {
        _dataDictionary = [[NSMutableDictionary alloc] initWithDictionary:jsonData];
    }
    return self;
}

- (NSDictionary *)asJSONData {
    if ([NSJSONSerialization isValidJSONObject:_dataDictionary]) {
        return _dataDictionary;
    }
    return nil;
}

- (id)init {
    self = [super init];
    if (nil != self) {
        _dataDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}
@end
