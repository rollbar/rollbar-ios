//
//  RollbarPrototype.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-09.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#ifndef RollbarPrototype_h
#define RollbarPrototype_h

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol RollbarPrototype <__covariant Type>

- (__kindof Type)clone;

@end

NS_ASSUME_NONNULL_END

#endif //RollbarPrototype_h
