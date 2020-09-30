//
//  MyClass.h
//  
//
//  Created by Andrey Kornich on 2020-09-30.
//

#ifndef NSDictionary_Rollbar_h
#define NSDictionary_Rollbar_h

@import Foundation;

@interface NSDictionary (Rollbar)

NS_ASSUME_NONNULL_BEGIN

- (BOOL)rollbar_valuePresentForKey:(nonnull NSString *)key
         className:(nullable NSString *)className;

NS_ASSUME_NONNULL_END

@end

#endif //NSDictionary_Rollbar_h
