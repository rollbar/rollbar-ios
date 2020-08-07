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
@property (nonnull, nonatomic, strong) NSArray<NSString *> *scrubFields;
- (void)addScrubField:(NSString *)field;
- (void)removeScrubField:(NSString *)field;
// Fields to not scrub from the payload even if they mention among scrubFields:
@property (nonnull, nonatomic, strong) NSArray<NSString *> *safeListFields;
- (void)addScrubSafeListField:(NSString *)field;
- (void)removeScrubSafeListField:(NSString *)field;

#pragma mark - initializers

- (instancetype)initWithEnabled:(BOOL)enabled
                    scrubFields:(NSArray<NSString *> *)scrubFields
                 safeListFields:(NSArray<NSString *> *)safeListFields;
- (instancetype)initWithScrubFields:(NSArray<NSString *> *)scrubFields
                     safeListFields:(NSArray<NSString *> *)safeListFields;
- (instancetype)initWithScrubFields:(NSArray<NSString *> *)scrubFields;

@end

NS_ASSUME_NONNULL_END
