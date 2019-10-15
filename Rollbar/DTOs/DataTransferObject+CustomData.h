//
//  DataTransferObject+CustomData.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-09.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataTransferObject (CustomData)

- (void)addKeyed:(NSString *)aKey DataTransferObject:(DataTransferObject *)aValue;
- (void)addKeyed:(NSString *)aKey String:(NSMutableString *)aValue;
- (void)addKeyed:(NSString *)aKey Number:(NSNumber *)aValue;
- (void)addKeyed:(NSString *)aKey Array:(NSMutableArray *)aValue;
- (void)addKeyed:(NSString *)aKey Dictionary:(NSMutableDictionary *)aValue;
- (void)addKeyed:(NSString *)aKey Placeholder:(NSNull *)aValue;

- (BOOL)tryAddKeyed:(NSString *)aKey Object:(NSObject *)aValue;

@end

NS_ASSUME_NONNULL_END
