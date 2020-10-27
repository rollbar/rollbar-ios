//
//  RollbarReceptionist.m
//  
//
//  Created by Andrey Kornich on 2020-10-08.
//

#import "RollbarReceptionist.h"

@implementation RollbarReceptionist

#pragma mark Properties

#pragma mark Lifecycle

+ (instancetype)receptionistForKeyPath:(NSString *)path
                                object:(id)obj
                                 queue:(NSOperationQueue *)queue
                                  task:(RollbarReceptionistTaskBlock)task {
    
    RollbarReceptionist *receptionist = [RollbarReceptionist new];
    receptionist->task = [task copy];
    receptionist->observedKeyPath = [path copy];
    receptionist->observedObject = obj;
    receptionist->queue = queue;
    [obj addObserver:receptionist
          forKeyPath:path
             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
             context:0];
    return receptionist;
}

#pragma mark Operations

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    [queue addOperationWithBlock:^{
        task(keyPath, object, change);
    }];
}

#pragma mark NSObject

- (NSString *)description {
    return super.description;
}

@end
