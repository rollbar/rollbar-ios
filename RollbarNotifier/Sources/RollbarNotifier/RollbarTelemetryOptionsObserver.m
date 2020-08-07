//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import "RollbarTelemetryOptionsObserver.h"
#import "RollbarTelemetryOptions.h"
#import "RollbarTelemetry.h"

#pragma mark - Configuration KVO contexts:
static void *RollbarTelemetryEnabledContext = &RollbarTelemetryEnabledContext;
static void *RollbarTelemetryCaptureLogContext = &RollbarTelemetryCaptureLogContext;
static void *RollbarTelemetryCaptureConnectivityContext = &RollbarTelemetryCaptureConnectivityContext;
static void *RollbarTelemetryMaximumTelemetryDataContext = &RollbarTelemetryMaximumTelemetryDataContext;
static void *RollbarTelemetryViewInputsScrubberContext = &RollbarTelemetryViewInputsScrubberContext;

@implementation RollbarTelemetryOptionsObserver {
}

- (void)registerAsObserverForTelemetryOptions:(RollbarTelemetryOptions *)telemetryOptions {

    [telemetryOptions addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(enabled))
                          options:0
                          context:RollbarTelemetryEnabledContext];
 
    [telemetryOptions addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(captureLog))
                          options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                          context:RollbarTelemetryCaptureLogContext];
}

- (void)unregisterAsObserverForTelemetryOptions:(RollbarTelemetryOptions *)telemetryOptions {

    [telemetryOptions removeObserver:self
                 forKeyPath:NSStringFromSelector(@selector(enabled))
                    context:RollbarTelemetryEnabledContext];
 
    [telemetryOptions removeObserver:self
                 forKeyPath:NSStringFromSelector(@selector(captureLog))
                    context:RollbarTelemetryCaptureLogContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
 
    RollbarTelemetryOptions *telemetryOptions = (RollbarTelemetryOptions *)object;
    if (context == RollbarTelemetryEnabledContext) {
        [RollbarTelemetry sharedInstance].enabled = telemetryOptions.enabled;
    } else if (context == RollbarTelemetryCaptureLogContext) {
        [RollbarTelemetry sharedInstance].captureLog = telemetryOptions.captureLog;
    } else {
        // Any unrecognized context must belong to super
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                               context:context];
    }
}

@end
