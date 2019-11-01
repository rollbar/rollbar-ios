//
//  JSONSupport.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-09.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// JSON de/serialization protocol
@protocol JSONSupport <NSObject>

/// Internal JSON serializable "data store"
@property (readonly) NSMutableDictionary *jsonFriendlyData;

#pragma mark - via JSON-friendly NSData

/// Serialize into JSON-friendly NSData instance
- (NSData *)serializeToJSONData;

/// Desrialize from JSON-friendlt NSData instance
/// @param jsonData JSON-friendlt NSData instance
- (BOOL)deserializeFromJSONData:(NSData *)jsonData;

#pragma mark - via JSON string

/// Serialize into a JSON string
- (NSString *)serializeToJSONString;

/// Deserialize from a JSON string
/// @param jsonString JSON string
- (BOOL)deserializeFromJSONString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
