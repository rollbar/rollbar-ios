//
//  RollbarTelemetryEvent.h
//  Rollbar
//
//  Created by Andrey Kornich on 2020-02-28.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#import <Rollbar/Rollbar.h>

NS_ASSUME_NONNULL_BEGIN

@interface RollbarTelemetryEvent : DataTransferObject

#pragma mark - Properies
// Can contain any arbitrary keys. Rollbar understands the following:

// Required: level
// The severity level of the telemetry data. One of: "critical", "error", "warning", "info", "debug".
@property (nonatomic) RollbarLevel level;

// Required: type
// The type of telemetry data. One of: "log", "network", "dom", "navigation", "error", "manual".
@property (nonatomic) RollbarTelemetryType type;


@end

NS_ASSUME_NONNULL_END
