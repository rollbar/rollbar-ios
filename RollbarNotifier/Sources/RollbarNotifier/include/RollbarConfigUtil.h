//
//  RollbarConfig.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-11.
//  Copyright © 2019 Rollbar. All rights reserved.
//

@import Foundation;

@class RollbarConfig;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarConfigUtil : NSObject

+ (nonnull NSString *)getDefaultConfigFileName;
+ (nonnull NSString *)getDefaultConfigDirectory;
+ (nonnull NSString *)getDefaultConfigFilePath;

+ (nullable RollbarConfig *)createRollbarConfigFromFile:(nonnull NSString *)filePath
                                                  error:(NSError * _Nullable *)error;
+ (nullable RollbarConfig *)createRollbarConfigFromDefaultFile:(NSError * _Nullable *)error;

+ (BOOL)saveRollbarConfig:(RollbarConfig *)rollbarConfig
                   toFile:(nonnull NSString *)filePath
                    error:(NSError * _Nullable *)error;
+ (BOOL)saveRollbarConfig:(RollbarConfig *)rollbarConfig
                    error:(NSError * _Nullable *)error;

+ (BOOL)deleteFile:(nonnull NSString *)filePath
             error:(NSError * _Nullable *)error;
+ (BOOL)deleteDefaultRollbarConfigFile:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
