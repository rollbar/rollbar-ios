//
//  Calculator.m
//  
//
//  Created by Andrey Kornich on 2020-10-13.
//

#import "Calculator.h"

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

