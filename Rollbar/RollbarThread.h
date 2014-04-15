//
//  RollbarThread.h
//  Rollbar
//
//  Created by Sergei Bezborodko on 4/8/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RollbarNotifier.h"

@interface RollbarThread : NSThread {
    RollbarNotifier *notifier;
}

- (id)initWithNotifier:(RollbarNotifier*)aNotifier;

@property(atomic) BOOL active;

@end
