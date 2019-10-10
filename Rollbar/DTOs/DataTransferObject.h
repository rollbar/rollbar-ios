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
    //@private
        //...
    
    @protected
        NSMutableDictionary *_data;
    
    //@public
        //...
}

+ (BOOL)isTransferableObject:(id)obj;

- (id)initWithJSONString: (NSString *)jsonString;
- (id)initWithJSONData: (NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
