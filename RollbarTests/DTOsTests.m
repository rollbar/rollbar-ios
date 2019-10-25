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
#import "../Rollbar/DTOs/RollbarDestination.h"
#import "../Rollbar/DTOs/RollbarDeveloperOptions.h"
#import "../Rollbar/DTOs/RollbarProxy.h"
#import "../Rollbar/DTOs/RollbarScrubbingOptions.h"
#import "../Rollbar/DTOs/RollbarServer.h"

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

- (void)testRollbarScrubbingOptionsDTO {
    RollbarScrubbingOptions *dto = [[RollbarScrubbingOptions alloc] initWithScrubFields:@[@"field1", @"field2"]];
    XCTAssertTrue(dto.enabled,
                  @"Enabled by default"
                  );
    XCTAssertTrue(dto.scrubFields.count == 2,
                  @"Has some scrub fields"
                  );
    XCTAssertTrue(dto.whitelistFields.count == 0,
                  @"Has NO whitelist fields"
                  );
    
    dto.whitelistFields = @[@"tf1", @"tf2", @"tf3"];
    XCTAssertTrue(dto.whitelistFields.count == 3,
                  @"Has some whitelist fields"
                  );
    
    dto.enabled = NO;
    XCTAssertTrue(!dto.enabled,
                  @"Expected to be disabled"
                  );
}

- (void)testRollbarServerDTO {
    RollbarServer *dto = [[RollbarServer alloc] initWithHost:@"HOST"
                                                        root:@"ROOT"
                                                      branch:@"BRANCH"
                                                 codeVersion:@"1.2.3"
                          ];
    XCTAssertTrue(NSOrderedSame == [dto.host compare:@"HOST"],
                  @"Proper host"
                  );
    XCTAssertTrue(NSOrderedSame == [dto.root compare:@"ROOT"],
                  @"Proper root"
                  );
    XCTAssertTrue(NSOrderedSame == [dto.branch compare:@"BRANCH"],
                  @"Proper branch"
                  );
    XCTAssertTrue(NSOrderedSame == [dto.codeVersion compare:@"1.2.3"],
                  @"Proper code version"
                  );

    dto.host = @"h1";
    XCTAssertTrue(NSOrderedSame == [dto.host compare:@"h1"],
                  @"Proper new host"
                  );
    dto.root = @"r1";
    XCTAssertTrue(NSOrderedSame == [dto.root compare:@"r1"],
                  @"Proper new root"
                  );
    dto.branch = @"b1";
    XCTAssertTrue(NSOrderedSame == [dto.branch compare:@"b1"],
                  @"Proper new branch"
                  );
    dto.codeVersion = @"3.2.5";
    XCTAssertTrue(NSOrderedSame == [dto.codeVersion compare:@"3.2.5"],
                  @"Proper new code version"
                  );
}

- (void)testRollbarConfigDTO {
    RollbarConfig *rc = [RollbarConfig new];
    //id destination = rc.destination;
    rc.destination.accessToken = @"ACCESSTOKEN";
    rc.destination.environment = @"ENVIRONMENT";
    rc.destination.endpoint = @"ENDPOINT";
    rc.logLevel = RollbarDebug;
    
    [rc setPersonId:@"PERSONID" username:@"PERSONUSERNAME" email:@"PERSONEMAIL"];
    [rc setServerHost:@"SERVERHOST" root:@"SERVERROOT" branch:@"SERVERBRANCH" codeVersion:@"SERVERCODEVERSION"];
    [rc setNotifierName:@"NOTIFIERNAME" version:@"NOTIFIERVERSION"];
    
    RollbarConfig *rcClone = [[RollbarConfig alloc] initWithJSONString:[rc serializeToJSONString]];
    
//    id scrubList = rc.scrubFields;
//    id scrubListClone = rcClone.scrubFields;
    
    XCTAssertTrue([rc isEqual:rcClone],
                  @"Two DTOs are expected to be equal"
                  );
//    XCTAssertTrue([[rc serializeToJSONString] isEqualToString:[rcClone serializeToJSONString]],
//                  @"DTO [%@] must match DTO: [%@].",
//                  [rc serializeToJSONString],
//                  [rcClone serializeToJSONString]
//                  );

    rcClone.destination.accessToken = @"SOME_OTHER_ONE";
    XCTAssertTrue(![rc isEqual:rcClone],
                  @"Two DTOs are NOT expected to be equal"
                  );
//    XCTAssertTrue(![[rc serializeToJSONString] isEqualToString:[rcClone serializeToJSONString]],
//                  @"DTO [%@] must NOT match DTO: [%@].",
//                  [rc serializeToJSONString],
//                  [rcClone serializeToJSONString]
//                  );

    rcClone = [[RollbarConfig alloc] initWithJSONString:[rc serializeToJSONString]];
    rcClone.httpProxy.proxyUrl = @"SOME_OTHER_ONE";
    XCTAssertTrue(![rc isEqual:rcClone],
                  @"Two DTOs are NOT expected to be equal"
                  );
    XCTAssertTrue([rcClone isEqual:[[RollbarConfig alloc] initWithJSONString:[rcClone serializeToJSONString]]],
                  @"Two DTOs (clone and its clone) are expected to be equal"
                  );
}

@end
