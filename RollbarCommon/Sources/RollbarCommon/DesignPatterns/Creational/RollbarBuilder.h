//
//  RollbarBuilder.h
//  
//
//  Created by Andrey Kornich on 2020-10-01.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@class RollbarEntityBuilder;

///Immutable entity model
@interface RollbarEntity : NSObject

@property (nonnull, nonatomic, readonly) NSString *ID;

- (nonnull instancetype)initWithBuilder:(nonnull RollbarEntityBuilder *)builder;

@end

/// Mutable builder of immutable entities
@interface RollbarEntityBuilder : NSObject

@property (nonnull, nonatomic) NSString *ID;

- (nonnull RollbarEntity *)build;

@end

NS_ASSUME_NONNULL_END
