//
//  Calculator.h
//  
//
//  Created by Andrey Kornich on 2020-10-13.
//


#import <XCTest/XCTest.h>
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
