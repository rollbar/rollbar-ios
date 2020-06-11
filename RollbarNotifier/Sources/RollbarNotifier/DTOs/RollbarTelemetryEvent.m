//
//  RollbarTelemetryEvent.m
//  Rollbar
//
//  Created by Andrey Kornich on 2020-02-28.
//  Copyright © 2020 Rollbar. All rights reserved.
//

//#import "DataTransferObject+Protected.h"
#import "RollbarTelemetryEvent.h"
#import "RollbarTelemetryBody.h"
#import "RollbarTelemetryConnectivityBody.h"
#import "RollbarTelemetryNavigationBody.h"
#import "RollbarTelemetryNetworkBody.h"
#import "RollbarTelemetryManualBody.h"
#import "RollbarTelemetryErrorBody.h"
#import "RollbarTelemetryViewBody.h"
#import "RollbarTelemetryLogBody.h"

#pragma mark - constants

#pragma mark - data field keys

static NSString * const DFK_LEVEL = @"level";
static NSString * const DFK_TYPE = @"type";
static NSString * const DFK_SOURCE = @"source";
static NSString * const DFK_TIMESTAMP = @"timestamp_ms";
static NSString * const DFK_BODY = @"body";

#pragma mark - class implementation

@implementation RollbarTelemetryEvent

#pragma mark - initializers

- (instancetype)initWithLevel:(RollbarLevel)level
                telemetryType:(RollbarTelemetryType)type
                       source:(RollbarSource)source {

    NSTimeInterval timestamp = NSDate.date.timeIntervalSince1970 * 1000.0;
    RollbarTelemetryBody *body = [RollbarTelemetryEvent createTelemetryBodyWithType:type
                                                                               data:nil];
    self = [self initWithDictionary:@{
        DFK_LEVEL:[RollbarLevelUtil RollbarLevelToString:level],
        DFK_TYPE:[RollbarTelemetryTypeUtil RollbarTelemetryTypeToString:type],
        DFK_SOURCE:[RollbarSourceUtil RollbarSourceToString:source],
        DFK_TIMESTAMP:[NSNumber numberWithDouble:round(timestamp)],
        DFK_BODY:body.jsonFriendlyData
    }];
    return self;
}

- (instancetype)initWithLevel:(RollbarLevel)level
                       source:(RollbarSource)source
                         body:(nonnull RollbarTelemetryBody *)body {
    
    NSTimeInterval timestamp = NSDate.date.timeIntervalSince1970 * 1000.0;
    RollbarTelemetryType type = [RollbarTelemetryEvent deriveTypeFromBody:body];
    self = [self initWithDictionary:@{
        DFK_LEVEL:[RollbarLevelUtil RollbarLevelToString:level],
        DFK_TYPE:[RollbarTelemetryTypeUtil RollbarTelemetryTypeToString:type],
        DFK_SOURCE:[RollbarSourceUtil RollbarSourceToString:source],
        DFK_TIMESTAMP:[NSNumber numberWithDouble:round(timestamp)],
        DFK_BODY: body.jsonFriendlyData
    }];
    return self;
}

//- (instancetype)initWithArray:(NSArray *)data {
//
//    return [super initWithArray:data];
//}

- (instancetype)initWithDictionary:(NSDictionary *)data {

    return [super initWithDictionary:data];
}

#pragma mark - property accessors

#pragma mark level

-(RollbarLevel)level {
    NSString *result = [self getDataByKey:DFK_LEVEL];
    return [RollbarLevelUtil RollbarLevelFromString:result];
}

//-(void)setLevel:(RollbarLevel)value {
//    [self setData:[RollbarLevelUtil RollbarLevelToString:value]
//            byKey:DFK_LEVEL];
//}

#pragma mark type

-(RollbarTelemetryType)type {
    NSString *result = [self getDataByKey:DFK_TYPE];
    return [RollbarTelemetryTypeUtil RollbarTelemetryTypeFromString:result];
}

//-(void)setType:(RollbarTelemetryType)value {
//    [self setData:[RollbarTelemetryTypeUtil RollbarTelemetryTypeToString:value]
//            byKey:DFK_TYPE];
//}

#pragma mark source

-(RollbarSource)source {
    NSString *result = [self getDataByKey:DFK_SOURCE];
    return [RollbarSourceUtil RollbarSourceFromString:result];
}

//-(void)setSource:(RollbarSource)value {
//    [self setData:[RollbarSourceUtil RollbarSourceToString:value]
//            byKey:DFK_SOURCE];
//}

#pragma mark timestamp
                        
-(NSTimeInterval)timestamp {
    NSNumber *dateNumber = [self getDataByKey:DFK_TIMESTAMP]; // [sec]
    if (nil != dateNumber) {
        return (NSTimeInterval)(dateNumber.doubleValue / 1000.0); // [msec]
    }
    return 0;
}

//-(void)setTimestamp:(NSTimeInterval)value {
//    [self setData:[NSNumber numberWithDouble:(value * 1000.0)] // [msec]
//            byKey:DFK_TIMESTAMP];
//}

#pragma mark body

- (RollbarTelemetryBody *)body {
    id data = [self safelyGetDictionaryByKey:DFK_BODY];
    return [RollbarTelemetryEvent createTelemetryBodyWithType:self.type
                                                         data:data];
}

//- (void)setBody:(RollbarTelemetryBody *)value {
//    [self setDataTransferObject:value forKey:DFK_BODY];
//}

+ (nullable RollbarTelemetryBody *)createTelemetryBodyWithType:(RollbarTelemetryType)type
                                                          data:(NSDictionary *)data {
    RollbarTelemetryBody *body = nil;
    switch(type) {
        case RollbarTelemetryType_View:
            body = [RollbarTelemetryViewBody alloc];
            break;
        case RollbarTelemetryType_Log:
            body = [RollbarTelemetryLogBody alloc];
            break;
        case RollbarTelemetryType_Navigation:
            body = [RollbarTelemetryNavigationBody alloc];
            break;
        case RollbarTelemetryType_Error:
            body = [RollbarTelemetryErrorBody alloc];
            break;
        case RollbarTelemetryType_Manual:
            body = [RollbarTelemetryManualBody alloc];
            break;
        case RollbarTelemetryType_Network:
            body = [RollbarTelemetryNetworkBody alloc];
            break;
        case RollbarTelemetryType_Connectivity:
            body = [RollbarTelemetryConnectivityBody alloc];
            break;
        default:
            return nil;
    }
    if (!data) {
        data = [NSMutableDictionary dictionary];
    }
    return [body initWithDictionary:data];
}

+(RollbarTelemetryType)deriveTypeFromBody:(nonnull RollbarTelemetryBody *)body {

    //TODO: order of type discovery matters (for inhereted body type hierarchies):
    if ([body isKindOfClass:[RollbarTelemetryErrorBody class]]) {
        return RollbarTelemetryType_Error;
    }
    else if ([body isKindOfClass:[RollbarTelemetryLogBody class]]) {
        return RollbarTelemetryType_Log;
    }
    else if ([body isKindOfClass:[RollbarTelemetryViewBody class]]) {
        return RollbarTelemetryType_View;
    }
    else if ([body isKindOfClass:[RollbarTelemetryNavigationBody class]]) {
        return RollbarTelemetryType_Navigation;
    }
    else if ([body isKindOfClass:[RollbarTelemetryManualBody class]]) {
        return RollbarTelemetryType_Manual;
    }
    else if ([body isKindOfClass:[RollbarTelemetryNetworkBody class]]) {
        return RollbarTelemetryType_Network;
    }
    else if ([body isKindOfClass:[RollbarTelemetryConnectivityBody class]]) {
        return RollbarTelemetryType_Connectivity;
    }
    else {
        return RollbarTelemetryType_Manual;
    }
}

@end
