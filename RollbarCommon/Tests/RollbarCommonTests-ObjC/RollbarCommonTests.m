//
//  DTOsTests.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//


#if !TARGET_OS_WATCH
#import <XCTest/XCTest.h>

@import Foundation;
@import RollbarCommon;
#import "Mocks/Calculator.h"

@interface RollbarCommonTests : XCTestCase

@end

@implementation RollbarCommonTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"Set to go...");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    NSLog(@"Teared down.");
}

- (void)testRollbarTaskDispatcher {
    
    void (^task)(id) = ^(id taskInput) {
        NSLog(@"Processing thread: %@", [NSThread currentThread]);
        Calculator *calc = (Calculator *)taskInput;
        if (calc != nil) {
            [calc calculate];
        }
    };

    NSOperationQueue *processingQueue = [NSOperationQueue currentQueue];
    processingQueue.maxConcurrentOperationCount = 1600;
    for( int i = 0; i < 20; i++) {
        for (int j = 1; j < 21; j++) {
            NSString *expectationLabel = nil;
            XCTestExpectation *expectation = nil;
            
            expectationLabel = [NSString stringWithFormat:@"asynchronous request: %i + %i", i, j];
            expectation = [self expectationWithDescription: expectationLabel];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY,0), ^(){
                NSLog(@"Sending thread: %@", [NSThread currentThread]);
                Calculator * taskInput;
                taskInput = [[Calculator alloc] initWithOperation:CalculatorOperation_Add
                                                         operand1:i
                                                         operand2:j
                                                      expectation:expectation];
                [[RollbarTaskDispatcher dispatcherForQueue:processingQueue
                                                      task:task
                                                 taskInput:taskInput]
                 dispatch];
                [NSThread sleepForTimeInterval:0.1f];
            });

            expectationLabel = [NSString stringWithFormat:@"asynchronous request: %i - %i", i, j];
            expectation = [self expectationWithDescription: expectationLabel];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY,0), ^(){
                NSLog(@"Sending thread: %@", [NSThread currentThread]);
                Calculator * taskInput;
                taskInput = [[Calculator alloc] initWithOperation:CalculatorOperation_Subtract
                                                         operand1:i
                                                         operand2:j
                                                      expectation:expectation];
                [[RollbarTaskDispatcher dispatcherForQueue:processingQueue
                                                      task:task
                                                 taskInput:taskInput]
                 dispatch];
                [NSThread sleepForTimeInterval:0.1f];
            });
            
            expectationLabel = [NSString stringWithFormat:@"asynchronous request: %i * %i", i, j];
            expectation = [self expectationWithDescription: expectationLabel];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY,0), ^(){
                NSLog(@"Sending thread: %@", [NSThread currentThread]);
                Calculator * taskInput;
                taskInput = [[Calculator alloc] initWithOperation:CalculatorOperation_Multiply
                                                         operand1:i
                                                         operand2:j
                                                      expectation:expectation];
                [[RollbarTaskDispatcher dispatcherForQueue:processingQueue
                                                      task:task
                                                 taskInput:taskInput]
                 dispatch];
                [NSThread sleepForTimeInterval:0.1f];
            });

            expectationLabel = [NSString stringWithFormat:@"asynchronous request: %i / %i", i, j];
            expectation = [self expectationWithDescription: expectationLabel];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY,0), ^(){
                NSLog(@"Sending thread: %@", [NSThread currentThread]);
                Calculator * taskInput;
                taskInput = [[Calculator alloc] initWithOperation:CalculatorOperation_Divide
                                                         operand1:i
                                                         operand2:j
                                                      expectation:expectation];
                [[RollbarTaskDispatcher dispatcherForQueue:processingQueue
                                                      task:task
                                                 taskInput:taskInput]
                 dispatch];
                [NSThread sleepForTimeInterval:0.1f];
            });
        }
    }
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error){
        if (error){
            XCTFail(@"Failed expectations fulfillment!");
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
#endif
