//
//  RollbarCrashCollectorBase.h
//  
//
//  Created by Andrey Kornich on 2020-11-02.
//

@import Foundation;

#import "RollbarCrashCollectorProtocol.h"
@protocol RollbarCrashCollectorObserver;

NS_ASSUME_NONNULL_BEGIN

    /// Abstract implementation of the RollbarCrashCollector protocol
@interface RollbarCrashCollectorBase : NSObject<RollbarCrashCollector> {
    @private
    id<RollbarCrashCollectorObserver> _observer;
}

- (instancetype)initWithObserver:(nonnull id<RollbarCrashCollectorObserver>)observer
NS_DESIGNATED_INITIALIZER;

- (instancetype)init
NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
