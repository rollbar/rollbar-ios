//
//  main.m
//  iOSAppWithRollbarViaCarthage_Objective-C
//
//  Created by Andrey Kornich on 2020-01-14.
//  Copyright © 2020 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
