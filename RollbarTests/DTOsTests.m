//
//  DTOsTests.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../Rollbar/DTOs/RollbarPayload.h"
#import "../Rollbar/DTOs/RollbarData.h"
#import "../Rollbar/DTOs/RollbarConfig.h"

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

    RollbarPayload *payloadAtOnce = [[RollbarPayload alloc] initWithJSONString:jsonString];
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

    RollbarPayload *payload = [[RollbarPayload alloc] initWithJSONString:jsonPayload];
    RollbarData *payloadData = [[RollbarData alloc] initWithJSONString:jsonData];
    payload.data = payloadData;
    XCTAssertTrue([[payloadAtOnce serializeToJSONString] isEqualToString:[payload serializeToJSONString]],
                  @"payloadAtOnce [%@] must match payload: [%@].",
                  [payloadAtOnce serializeToJSONString],
                  [payload serializeToJSONString]
                  );

    XCTAssertTrue(![payload hasSameDefinedPropertiesAs:payloadData],
                  @"RollbarPayload and RollbarData DTOs do not have same defined properties"
                  );
    XCTAssertTrue([payload hasSameDefinedPropertiesAs:payloadAtOnce],
                  @"Two RollbarPayload DTOs do not have same defined properties"
                  );
    
    XCTAssertTrue([payloadAtOnce isEqual:payload],
                  @"Two RollbarPayload DTOs are expected to be equal"
                  );

    payload.accessToken = @"SOME_OTHER_ONE";
    XCTAssertTrue(![payloadAtOnce isEqual:payload],
                  @"Two RollbarPayload DTOs are NOT expected to be equal"
                  );

    //id result = [payload getDefinedProperties];
}

- (void)testRollbarConfigDTO {
    RollbarConfig *rc = [[RollbarConfig alloc] init];
    rc.accessToken = @"ACCESSTOKEN";
    rc.environment = @"ENVIRONMNET";
    rc.endpoint = @"ENDPOINT";
    rc.logLevel = RollbarDebug;
    
    [rc setPersonId:@"PERSONID" username:@"PERSONUSERNAME" email:@"PERSONEMAIL"];
    [rc setServerHost:@"SERVERHOST" root:@"SERVERROOT" branch:@"SERVERBRANCH" codeVersion:@"SERVERCODEVERSION"];
    [rc setNotifierName:@"NOTIFIERNAME" version:@"NOTIFIERVERSION"];
    
    RollbarConfig *rcClone = [[RollbarConfig alloc] initWithJSONString:[rc serializeToJSONString]];
    XCTAssertTrue([rc isEqual:rcClone],
                  @"Two DTOs are expected to be equal"
                  );
    XCTAssertTrue([[rc serializeToJSONString] isEqualToString:[rcClone serializeToJSONString]],
                  @"DTO [%@] must match DTO: [%@].",
                  [rc serializeToJSONString],
                  [rcClone serializeToJSONString]
                  );

    rcClone.accessToken = @"SOME_OTHER_ONE";
    XCTAssertTrue(![rc isEqual:rcClone],
                  @"Two DTOs are NOT expected to be equal"
                  );
    XCTAssertTrue(![[rc serializeToJSONString] isEqualToString:[rcClone serializeToJSONString]],
                  @"DTO [%@] must NOT match DTO: [%@].",
                  [rc serializeToJSONString],
                  [rcClone serializeToJSONString]
                  );

}

@end
