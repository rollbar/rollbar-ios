//
//  RollbarScrubbingOptions.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-24.
//  Copyright © 2019 Rollbar. All rights reserved.
//

@import RollbarCommon;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarScrubbingOptions : RollbarDTO

#pragma mark - properties

@property (nonatomic) BOOL enabled;
// Fields to scrub from the payload
@property (nonatomic, strong) NSArray *scrubFields;
// Fields to not scrub from the payload even if they mention among scrubFields:
@property (nonatomic, strong) NSArray *safeListFields;

#pragma mark - initializers

- (instancetype)initWithEnabled:(BOOL)enabled
                    scrubFields:(NSArray *)scrubFields
                 safeListFields:(NSArray *)safeListFields;
- (instancetype)initWithScrubFields:(NSArray *)scrubFields
                     safeListFields:(NSArray *)safeListFields;
- (instancetype)initWithScrubFields:(NSArray *)scrubFields;

@end

NS_ASSUME_NONNULL_END
