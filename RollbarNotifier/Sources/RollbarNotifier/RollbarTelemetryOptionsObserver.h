//  Copyright (c) 2020 Rollbar, Inc. All rights reserved.

@import Foundation;

@class RollbarTelemetryOptions;

@interface RollbarTelemetryOptionsObserver : NSObject

- (void)registerAsObserverForTelemetryOptions:(RollbarTelemetryOptions *)telemetryOptions;

- (void)unregisterAsObserverForTelemetryOptions:(RollbarTelemetryOptions *)telemetryOptions;

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;

//- (instancetype)init
//NS_DESIGNATED_INITIALIZER;

@end
