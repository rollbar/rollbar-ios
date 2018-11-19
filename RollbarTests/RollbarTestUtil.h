//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>

@interface RollbarTestUtil : NSObject

void RollbarClearLogFile();
NSArray* RollbarReadLogItemFromFile();

@end
