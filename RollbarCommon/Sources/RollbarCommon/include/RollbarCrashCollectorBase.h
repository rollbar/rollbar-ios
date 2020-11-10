//
//  RollbarCrashCollectorBase.h
//  
//
//  Created by Andrey Kornich on 2020-11-02.
//

#ifndef RollbarCrashCollectorBase_h
#define RollbarCrashCollectorBase_h

@import Foundation;

#import "RollbarCrashCollectorProtocol.h"
@protocol RollbarCrashCollectorObserver;

NS_ASSUME_NONNULL_BEGIN

    /// Abstract implementation of the RollbarCrashCollector protocol
@interface RollbarCrashCollectorBase : NSObject<RollbarCrashCollector> {
    @private
    id<RollbarCrashCollectorObserver> _observer;
}

- (instancetype)initWithObserver:(nullable id<RollbarCrashCollectorObserver>)observer
NS_DESIGNATED_INITIALIZER;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END

#endif /* RollbarCrashCollectorBase_h */
