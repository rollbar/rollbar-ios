//
//  RollbarTaskDispatcher.m
//  
//
//  Created by Andrey Kornich on 2020-10-09.
//

#import "RollbarTaskDispatcher.h"

@implementation RollbarTaskDispatcher

#pragma mark Properties

#pragma mark Lifecycle

+ (instancetype)dispatcherForQueue:(NSOperationQueue *)queue
                              task:(RollbarTaskBlock)task
                         taskInput:(id)taskInput {
    
    RollbarTaskDispatcher *dispatcher = [RollbarTaskDispatcher new];
    dispatcher->task = [task copy];
    dispatcher->queue = queue;
    dispatcher->taskInput = taskInput;
    
    return dispatcher;
}

#pragma mark Operations

- (void)dispatchTask:(RollbarTaskBlock)task input:(id)taskInput {
    
    [queue addOperationWithBlock:^{
        task(taskInput);
    }];
}

- (void)dispatchInput:(id)taskInput {
    
    [self dispatchTask:self->task input:taskInput];
}

- (void)dispatch {
    [self dispatchInput:self->taskInput];
}

#pragma mark NSObject

- (NSString *)description {
    return super.description;
}

@end
