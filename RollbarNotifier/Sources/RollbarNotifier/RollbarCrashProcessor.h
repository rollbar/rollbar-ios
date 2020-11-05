//
//  MyClass.h
//  
//
//  Created by Andrey Kornich on 2020-11-04.
//

@import Foundation;
@import RollbarCommon;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarCrashProcessor : NSObject <RollbarCrashCollectorObserver>

@end

NS_ASSUME_NONNULL_END
