//
//  DataTransferObject.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataTransferObject : NSObject {
    //@private
        //...
    
    @protected
        NSMutableDictionary *_data;
    
    //@public
        //...
}

- (void)log;

@end

NS_ASSUME_NONNULL_END
