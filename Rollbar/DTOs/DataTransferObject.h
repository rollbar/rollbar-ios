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

- (instancetype)initWithJSONString:(NSString *)jsonString NS_DESIGNATED_INITIALIZER;;
- (instancetype)initWithJSONData:(NSData *)data NS_DESIGNATED_INITIALIZER;;
- (instancetype)initWithDictionary:(NSDictionary *)data NS_DESIGNATED_INITIALIZER;;
- (instancetype)initWithArray:(NSArray *)data NS_DESIGNATED_INITIALIZER;

- (NSArray *)getDefinedProperties;
- (BOOL)hasSameDefinedPropertiesAs:(DataTransferObject *)otherDTO;

@end

NS_ASSUME_NONNULL_END
