//
//  RollbarAppLanguage.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-16.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarAppLanguage.h"

@implementation RollbarAppLanguageUtil

+ (NSString *) RollbarAppLanguageToString:(RollbarAppLanguage)value {
    
    switch (value) {
        case ObjectiveC:
            return @"Objective-C";
        case ObjectiveCpp:
            return @"Objective-C++";
        case Swift:
            return @"Swift";
        case C:
            return @"C";
        case Cpp:
            return @"C++";
        default:
            return @"Objective-C";
    }
}

+ (RollbarAppLanguage) RollbarAppLanguageFromString:(NSString *)value {
    
    if (NSOrderedSame == [value caseInsensitiveCompare:@"Objective-C"]) {
        return ObjectiveC;
    }
    else if (NSOrderedSame == [value caseInsensitiveCompare:@"Objective-C++"]) {
        return ObjectiveCpp;
    }
    else if (NSOrderedSame == [value caseInsensitiveCompare:@"Swift"]) {
        return Swift;
    }
    else if (NSOrderedSame == [value caseInsensitiveCompare:@"C"]) {
        return C;
    }
    else if (NSOrderedSame == [value caseInsensitiveCompare:@"C++"]) {
        return Cpp;
    }
    else {
        return ObjectiveC; // default case...
    }
}

@end
