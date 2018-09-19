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
//    if ([NSJSONSerialization isValidJSONObject:self.dataDictionary]) {
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dataDictionary
//                                                           options:0
//                                                             error:nil];
//        return jsonData;
//    }
    return _dataDictionary;
}

- (id)init {
    self = [super init];
    if (nil != self) {
        _dataDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
    //return [self initWithJSONData:nil];
}
@end
