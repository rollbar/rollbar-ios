//
//  DTOsTests.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../Rollbar/DTOs/Payload.h"

@interface DTOsTests : XCTestCase

@end

@implementation DTOsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testBasicDTOInitializationWithJSONString {
    NSString *jsonString = @"{\"accessToken\":\"ACCESS_TOKEN\", \"data\":{\"environment\":\"ENV\"}}";
    NSString *jsonPayload = @"{\"accessToken\":\"ACCESS_TOKEN\"}";
    NSString *jsonData = @"{\"environment\":\"ENV\"}";

    Payload *payloadAtOnce = [[Payload alloc] initWithJSONString:jsonString];
    XCTAssertNotNil(payloadAtOnce,
                    @"Payload instance"
                    );
    XCTAssertTrue([payloadAtOnce.accessToken isEqualToString:@"ACCESS_TOKEN"],
                  @"Access token field [%@] of payload: %@.", payloadAtOnce.accessToken, [payloadAtOnce serializeToJSONString]
                  );
    XCTAssertNotNil(payloadAtOnce.data,
                    @"Data field of payload: %@.", [payloadAtOnce serializeToJSONString]
                    );
    XCTAssertTrue([payloadAtOnce.data.environment isEqualToString:@"ENV"],
                  @"Environment field [%@] of payload: %@.", payloadAtOnce.data.environment, [payloadAtOnce serializeToJSONString]
                  );

    Payload *payload = [[Payload alloc] initWithJSONString:jsonPayload];
    PayloadData *payloadData = [[PayloadData alloc] initWithJSONString:jsonData];
    payload.data = payloadData;
    XCTAssertTrue([[payloadAtOnce serializeToJSONString] isEqualToString:[payload serializeToJSONString]],
                  @"payloadAtOnce [%@] must match payload: [%@].",
                  [payloadAtOnce serializeToJSONString],
                  [payload serializeToJSONString]
                  );
}

@end
