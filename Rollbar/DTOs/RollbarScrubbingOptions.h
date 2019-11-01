//
//  RollbarScrubbingOptions.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-24.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarScrubbingOptions : DataTransferObject

#pragma mark - properties

@property (nonatomic) BOOL enabled;
// Fields to scrub from the payload
@property (nonatomic, strong) NSArray *scrubFields;
// Fields to not scrub from the payload even if they mention among scrubFields:
@property (nonatomic, strong) NSArray *whitelistFields;

#pragma mark - initializers

- (id)initWithEnabled:(BOOL)enabled
          scrubFields:(NSArray *)scrubFields
      whitelistFields:(NSArray *)whitelistFields;
- (id)initWithScrubFields:(NSArray *)scrubFields
          whitelistFields:(NSArray *)whitelistFields;
- (id)initWithScrubFields:(NSArray *)scrubFields;

@end

NS_ASSUME_NONNULL_END
