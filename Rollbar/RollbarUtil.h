//
//  RollbarUtil.h
//  Rollbar
//
//  Created by Freddy Hernandez on 11/3/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RollbarUtil : NSObject

+ (NSMutableDictionary*)jsonSafePayloadFromDictionary:(NSDictionary*)dictionary;

@end
