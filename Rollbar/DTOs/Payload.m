//
//  Payload.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "Payload.h"

@implementation Payload

- (NSString *)accessToken {
    return [self->_data valueForKey:@"accessToken"];
}

- (void)setAccessToken:(NSString *)accessToken {
    [self->_data setValue:accessToken forKey:@"accessToken"];
}

-(void)testIt {
    id data = self->_data;
}
@end
