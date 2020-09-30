//
//  MyClass.m
//  
//
//  Created by Andrey Kornich on 2020-09-30.
//

#import "NSDictionary+Rollbar.h"
#import "RollbarSdkLog.h"

@implementation NSDictionary (Rollbar)

NS_ASSUME_NONNULL_BEGIN

- (BOOL)rollbar_valuePresentForKey:(nonnull NSString *)key
         className:(nullable NSString *)className {
    
    id value = self[key];
    if (nil != value) {
        if ((id)[NSNull null] != value) {
            return YES;
        }
        else {
            RollbarSdkLog(@"[%@] - key %@ has no value", className, key);
        }
    }
    else {
        RollbarSdkLog(@"[%@] - key %@ not found", className, key);
    }
    
    return NO;
}

NS_ASSUME_NONNULL_END

@end
