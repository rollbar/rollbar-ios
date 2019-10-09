//
//  DataTransferObject.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

#import <Foundation/NSObjCRuntime.h>

@implementation DataTransferObject {

}

- (id)init {
    self = [super init];
    if (self) {
        self->_data = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

- (void)log {
    NSLog(@"A DataTransferObject...");
}
@end
