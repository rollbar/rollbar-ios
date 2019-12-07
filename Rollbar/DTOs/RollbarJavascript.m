//
//  RollbarJavascript.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarJavascript.h"
#import "DataTransferObject+Protected.h"
#import "TriStateFlag.h"

#pragma mark - data field keys

static NSString *const DFK_BROWSER = @"browser";
static NSString *const DFK_CODE_VERSION = @"code_version";
static NSString *const DFK_SOURCE_MAP_ENABLED = @"source_map_enabled";
static NSString *const DFK_GUESS_UNCAUGHT_FRAMES = @"guess_uncaught_frames";

@implementation RollbarJavascript

#pragma mark - Properties

-(NSString *)browser {
    NSString *result = [self getDataByKey:DFK_BROWSER];
    return result;
}

-(void)setBrowser:(NSString *)browser {
    [self setData:browser byKey:DFK_BROWSER];
}

-(NSString *)codeVersion {
    NSString *result = [self getDataByKey:DFK_CODE_VERSION];
    return result;
}

-(void)setCodeVersion:(NSString *)codeVersion {
    [self setData:codeVersion byKey:DFK_CODE_VERSION];
}

-(TriStateFlag)sourceMapEnabled {
    NSString *result = [self getDataByKey:DFK_SOURCE_MAP_ENABLED];
    return [TriStateFlagUtil TriStateFlagFromString:result];
}

-(void)setSourceMapEnabled:(TriStateFlag)sourceMapEnabled {
    [self setData:[TriStateFlagUtil TriStateFlagToString:sourceMapEnabled]
            byKey:DFK_SOURCE_MAP_ENABLED];
}

-(TriStateFlag)guessUncaughtFrames {
    NSString *result = [self getDataByKey:DFK_GUESS_UNCAUGHT_FRAMES];
    return [TriStateFlagUtil TriStateFlagFromString:result];
}

-(void)setGuessUncaughtFrames:(TriStateFlag)guessUncaughtFrames {
    [self setData:[TriStateFlagUtil TriStateFlagToString:guessUncaughtFrames]
            byKey:DFK_GUESS_UNCAUGHT_FRAMES];
}

#pragma mark - Initializers

-(instancetype)initWithBrowser:(nullable NSString *)browser
                   codeVersion:(nullable NSString *)codeVersion
              sourceMapEnabled:(TriStateFlag)sourceMapEnabled
           guessUncaughtFrames:(TriStateFlag)guessUncaughtFrames {
    
    self = [super initWithDictionary:@{
        DFK_BROWSER:browser,
        DFK_CODE_VERSION:codeVersion ? codeVersion : [NSNull null],
        DFK_SOURCE_MAP_ENABLED:[TriStateFlagUtil TriStateFlagToString:sourceMapEnabled],
        DFK_GUESS_UNCAUGHT_FRAMES:[TriStateFlagUtil TriStateFlagToString:guessUncaughtFrames]
    }];
    return self;
}

@end
