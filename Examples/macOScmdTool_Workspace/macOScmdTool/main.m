//
//  main.m
//  macOScmdTool
//
//  Created by Andrey Kornich on 2019-06-28.
//  Copyright © 2019 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../../Rollbar/Rollbar.h"
#import "../../../Rollbar/RollbarConfiguration.h"
#import "../../../Rollbar/RollbarTelemetry.h"
//#import <NSJSONSerialization+Rollbar.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // configure Rollbar:
        RollbarConfiguration *config = [RollbarConfiguration configuration];
        //config.crashLevel = @"critical";
        config.environment = @"samples";
        
        [Rollbar initWithAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3" configuration:config];
        //[Rollbar initWithAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3"];
        // insert code here...
        NSLog(@"Hello, World!");
        
        int i = 100;
        while (0 < i--) {
            [Rollbar info:@"Message from macOS"];
            [NSThread sleepForTimeInterval:1.0f];
        }
    }
    return 0;
}
