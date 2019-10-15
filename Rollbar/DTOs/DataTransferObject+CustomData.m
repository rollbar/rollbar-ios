//
//  DataTransferObject+CustomData.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-09.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject+CustomData.h"

@implementation DataTransferObject (CustomData)

- (void)addKeyed:(NSString *)aKey DataTransferObject:(DataTransferObject *)aValue {
    //TODO:...
}

- (void)addKeyed:(NSString *)aKey String:(NSMutableString *)aValue {
    //TODO:...
}

- (void)addKeyed:(NSString *)aKey Number:(NSNumber *)aValue {
    //TODO:...
}

- (void)addKeyed:(NSString *)aKey Array:(NSMutableArray *)aValue {
    //TODO:...
}

- (void)addKeyed:(NSString *)aKey Dictionary:(NSMutableDictionary *)aValue {
    //TODO:...
}

- (void)addKeyed:(NSString *)aKey Placeholder:(NSNull *)aValue {
    //TODO:...
}

- (BOOL)tryAddKeyed:(NSString *)aKey Object:(NSObject *)aValue {
    if ([DataTransferObject isTransferableObject:aValue]) {
        [self->_data setValue:aValue forKey:aKey];
        return YES;
    }
    return NO;
}

@end
