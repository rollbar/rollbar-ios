//
//  RollbarCallStackFrameContext.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

@import RollbarCommon;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarCallStackFrameContext : RollbarDTO

#pragma mark - Properties

// Optional: pre
// List of lines of code before the "code" line
@property (nonatomic, nullable) NSArray<NSString *> *preCodeLines;

// Optional: post
// List of lines of code after the "code" line
@property (nonatomic, nullable) NSArray<NSString *> *postCodeLines;

#pragma mark - Initializers

-(instancetype)initWithPreCodeLines:(nullable NSArray<NSString *> *)pre
                     postCodeLines:(nullable NSArray<NSString *> *)post;

@end

NS_ASSUME_NONNULL_END
