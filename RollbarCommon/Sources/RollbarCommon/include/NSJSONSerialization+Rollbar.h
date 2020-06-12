//  Copyright © 2018 Rollbar. All rights reserved.

#ifndef NSJSONSerialization_Rollbar_h
#define NSJSONSerialization_Rollbar_h

@import Foundation;

/// Rollbar category for NSJSONSerialization
@interface NSJSONSerialization (Rollbar)

NS_ASSUME_NONNULL_BEGIN

/// Returns NSData representation of an object composition representing structured JSON data
/// @param obj object composition representing structured JSON data
/// @param opt JSON writing options
/// @param error error (if any)
/// @param safe safe/valid NSJSONSerialization structure  flag
+ (nullable NSData *)rollbar_dataWithJSONObject:(id)obj
                                        options:(NSJSONWritingOptions)opt
                                          error:(NSError **)error
                                           safe:(BOOL)safe;

/// Turns JSON-like object structure into a valid NSJSONSerialization structure
/// @param obj JSON-like object
+ (NSDictionary *)rollbar_safeDataFromJSONObject:(id)obj;

/// Byte-length of a NSData representation of a JSON structure
/// @param jsonData NSData representation of a JSON structure
+ (unsigned long)rollbar_measureJSONDataByteSize:(NSData *)jsonData;

NS_ASSUME_NONNULL_END

@end

#endif //NSJSONSerialization_Rollbar_h
