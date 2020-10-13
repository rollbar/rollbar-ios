//
//  DTOsTests.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

@import Foundation;

#if !TARGET_OS_WATCH
#import <XCTest/XCTest.h>

@import RollbarCommon;

typedef NS_ENUM(NSUInteger, CalculatorOperation) {
    CalculatorOperation_Add,
    CalculatorOperation_Subtract,
    CalculatorOperation_Multiply,
    CalculatorOperation_Divide,
};

@interface Calculator : NSObject {
    @private
    XCTestExpectation *_expectation;
}

@property (readonly) NSInteger operand1;
@property (readonly) NSInteger operand2;
@property (readonly) CalculatorOperation operation;

-(NSInteger)calculate;

-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithOperation:(CalculatorOperation)operation
                        operand1:(NSInteger)operand1
                        operand2:(NSInteger)operand2
                     expectation:(XCTestExpectation *)expectation
NS_DESIGNATED_INITIALIZER;

@end

@implementation Calculator

-(NSInteger)calculate {

    NSString *operator;
    switch(_operation) {
        case CalculatorOperation_Add:
            operator = @"+";
            break;
        case CalculatorOperation_Subtract:
            operator = @"-";
            break;
        case CalculatorOperation_Multiply:
            operator = @"*";
            break;
        case CalculatorOperation_Divide:
            operator = @"/";
            break;
    }
    NSLog(@"Calculating: %li %@ %li", (long)_operand1, operator, (long)_operand2);
    
    NSInteger result;
    switch(_operation) {
        case CalculatorOperation_Add:
            result = _operand1 + _operand2;
            break;
        case CalculatorOperation_Subtract:
            result = _operand1 - _operand2;
            break;
        case CalculatorOperation_Multiply:
            result = _operand1 * _operand2;
            break;
        case CalculatorOperation_Divide:
            result = _operand1 / _operand2;
            break;
    }
    
    [_expectation fulfill];
    NSLog(@"Calculated: %li %@ %li. Result: %li", (long)_operand1, operator, (long)_operand2, (long)result);

    return result;
}

-(instancetype)initWithOperation:(CalculatorOperation)operation
                        operand1:(NSInteger)operand1
                        operand2:(NSInteger)operand2
                     expectation:(XCTestExpectation *)expectation {
    
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _operation = operation;
    _operand1 = operand1;
    _operand2 = operand2;
    _expectation = expectation;
    
    return  self;
}
@end


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
