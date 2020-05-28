//
//  RollbarJavascript.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

@import RollbarCommon;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarJavascript : RollbarDTO

#pragma mark - Properties

// Optional: browser
// The user agent string
@property (nonatomic, nullable, copy) NSString *browser;

// Optional: code_version
// String describing the running code version in javascript
// See note about "code_version" above
@property (nonatomic, nullable, copy) NSString *codeVersion;

// Optional: source_map_enabled
// Set to true to enable source map deobfuscation
// See the "Source Maps" guide for more details.
@property (nonatomic) RollbarTriStateFlag sourceMapEnabled;

// Optional: guess_uncaught_frames
// Set to true to enable frame guessing
// See the "Source Maps" guide for more details.
@property (nonatomic) RollbarTriStateFlag guessUncaughtFrames;

#pragma mark - Initializers

-(instancetype)initWithBrowser:(nullable NSString *)browser
                   codeVersion:(nullable NSString *)codeVersion
              sourceMapEnabled:(RollbarTriStateFlag)sourceMapEnabled
           guessUncaughtFrames:(RollbarTriStateFlag)guessUncaughtFrames;

@end

NS_ASSUME_NONNULL_END
