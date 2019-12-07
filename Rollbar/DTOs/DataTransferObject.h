//
//  DataTransferObject.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSupport.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataTransferObject : NSObject <JSONSupport> {
    @private
        NSMutableDictionary *_data;
        //...
    
    //@protected
        //...

    //@public
        //...
}

+ (BOOL)isTransferableObject:(id)obj;
+ (BOOL)isTransferableDataValue:(id)obj;

- (NSArray *)getDefinedProperties;
- (BOOL)hasSameDefinedPropertiesAs:(DataTransferObject *)otherDTO;

#pragma mark - initializers

- (instancetype)initWithJSONString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
