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

- (void)testBasicPayloadDTO {
    NSString *jsonString = @"{\"accessToken\":\"ACCESS_TOKEN\", \"data\":{\"environment\":\"ENV\"}}";
    Payload *payload = [[Payload alloc] initWithJSONString:jsonString];
    XCTAssertNotNil(payload,
                    @"Payload instance"
                    );
    XCTAssertTrue([payload.accessToken isEqualToString:@"ACCESS_TOKEN"],
                  @"Access token field [%@] of payload: %@.", payload.accessToken, [payload serializeToJSONString]
                  );
    XCTAssertNotNil(payload.data,
                    @"Data field of payload: %@.", [payload serializeToJSONString]
                    );
    XCTAssertTrue([payload.data.environment isEqualToString:@"ENV"],
                  @"Environment field [%@] of payload: %@.", payload.data.environment, [payload serializeToJSONString]
                  );
}

@end
