//
//  DTOsTests.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <XCTest/XCTest.h>

@import RollbarNotifier;

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
    NSString *jsonString = @"{\"access_token\":\"ACCESS_TOKEN\", \"data\":{\"environment\":\"ENV\"}}";
    NSString *jsonPayload = @"{\"access_token\":\"ACCESS_TOKEN\"}";
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

-(void)testRollbarProxyDTO {
    BOOL proxyEnabled = NO;
    NSUInteger proxyPort = 3000;
    NSString *proxyUrl = @"PROXY_URL";
    RollbarProxy *dto = [[RollbarProxy alloc] initWithEnabled:proxyEnabled proxyUrl:proxyUrl proxyPort:proxyPort];    
    XCTAssertTrue(dto.enabled == proxyEnabled,
                  @"Enabled."
                  );
    XCTAssertTrue(dto.proxyPort == proxyPort,
                  @"Enabled."
                  );
    XCTAssertTrue(dto.proxyUrl == proxyUrl,
                  @"Enabled."
                  );
}

- (void)testRollbarScrubbingOptionsDTO {
    RollbarScrubbingOptions *dto = [[RollbarScrubbingOptions alloc] initWithScrubFields:@[@"field1", @"field2"]];
    XCTAssertTrue(dto.enabled,
                  @"Enabled by default"
                  );
    XCTAssertTrue(dto.scrubFields.count == 2,
                  @"Has some scrub fields"
                  );
    XCTAssertTrue(dto.safeListFields.count == 0,
                  @"Has NO whitelist fields"
                  );
    
    dto.safeListFields = @[@"tf1", @"tf2", @"tf3"];
    XCTAssertTrue(dto.safeListFields.count == 3,
                  @"Has some whitelist fields"
                  );
    
    dto.enabled = NO;
    XCTAssertTrue(!dto.enabled,
                  @"Expected to be disabled"
                  );
}

- (void)testRollbarServerConfigDTO {
    RollbarServerConfig *dto = [[RollbarServerConfig alloc] initWithHost:@"HOST"
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
    
    
    RollbarConfig *rc = [RollbarConfig new];
    rc.destination.accessToken = @"ACCESSTOKEN";
    rc.destination.environment = @"ENVIRONMENT";
    rc.destination.endpoint = @"ENDPOINT";
    
    dto = rc.server;
    NSString *branchValue = dto.branch;
    XCTAssertNil(branchValue,
                  @"Uninitialized branch"
                  );
    dto.branch = @"ANOTHER_BRANCH";
    XCTAssertTrue(NSOrderedSame == [dto.branch compare:@"ANOTHER_BRANCH"],
                  @"Proper branch"
                  );
}

- (void)testRollbarPersonDTO {
    RollbarPerson *dto = [[RollbarPerson alloc] initWithID:@"ID"
                                                  username:@"USERNAME"
                                                     email:@"EMAIL"
                          ];
    XCTAssertTrue(NSOrderedSame == [dto.ID compare:@"ID"],
                  @"Proper ID"
                  );
    XCTAssertTrue(NSOrderedSame == [dto.username compare:@"USERNAME"],
                  @"Proper username"
                  );
    XCTAssertTrue(NSOrderedSame == [dto.email compare:@"EMAIL"],
                  @"Proper email"
                  );

    dto.ID = @"ID1";
    XCTAssertTrue(NSOrderedSame == [dto.ID compare:@"ID1"],
                  @"Proper ID"
                  );
    dto.username = @"USERNAME1";
    XCTAssertTrue(NSOrderedSame == [dto.username compare:@"USERNAME1"],
                  @"Proper username"
                  );
    dto.email = @"EMAIL1";
    XCTAssertTrue(NSOrderedSame == [dto.email compare:@"EMAIL1"],
                  @"Proper email"
                  );
    
    dto = [[RollbarPerson alloc] initWithID:@"ID007"];
    XCTAssertTrue(NSOrderedSame == [dto.ID compare:@"ID007"],
                  @"Proper ID"
                  );
    XCTAssertNil(dto.username,
                 @"Proper default username"
                 );
    XCTAssertNil(dto.email,
                 @"Proper default email"
                 );
}

- (void)testRollbarModuleDTO {
    RollbarModule *dto = [[RollbarModule alloc] initWithName:@"ModuleName"
                                                  version:@"v1.2.3"
                          ];
    XCTAssertTrue([dto.name isEqualToString:@"ModuleName"],
                  @"Proper name"
                  );
    XCTAssertTrue([dto.version isEqualToString:@"v1.2.3"],
                  @"Proper version"
                  );

    dto.name = @"MN1";
    XCTAssertTrue([dto.name isEqualToString:@"MN1"],
                  @"Proper name"
                  );
    dto.version = @"v3.2.1";
    XCTAssertTrue([dto.version isEqualToString:@"v3.2.1"],
                  @"Proper version"
                  );

    dto = [[RollbarModule alloc] initWithName:@"Module"];
    XCTAssertTrue([dto.name isEqualToString:@"Module"],
                  @"Proper name"
                  );
    XCTAssertNil(dto.version,
                 @"Proper version"
                 );
}

- (void)testRollbarTelemetryOptionsDTO {
    RollbarScrubbingOptions *scrubber =
    [[RollbarScrubbingOptions alloc] initWithEnabled:YES
                                         scrubFields:@[@"one", @"two"]
                                      safeListFields:@[@"two", @"three", @"four"]
     ];
    RollbarTelemetryOptions *dto = [[RollbarTelemetryOptions alloc] initWithEnabled:YES
                                                                         captureLog:YES
                                                                captureConnectivity:YES
                                                                 viewInputsScrubber:scrubber
                                    ];
    XCTAssertTrue(dto.enabled,
                  @"Proper enabled"
                  );
    XCTAssertTrue(dto.captureLog,
                  @"Proper capture log"
                  );
    XCTAssertTrue(dto.captureConnectivity,
                  @"Proper capture connectivity"
                  );
    XCTAssertTrue(dto.viewInputsScrubber.enabled,
                  @"Proper view inputs scrubber enabled"
                  );
    XCTAssertTrue(dto.viewInputsScrubber.scrubFields.count == 2,
                  @"Proper view inputs scrubber scrub fields count"
                  );
    XCTAssertTrue(dto.viewInputsScrubber.safeListFields.count == 3,
                  @"Proper view inputs scrubber white list fields count"
                  );
    
    dto = [[RollbarTelemetryOptions alloc] init];
    XCTAssertTrue(!dto.enabled,
                  @"Proper enabled"
                  );
    XCTAssertTrue(!dto.captureLog,
                  @"Proper capture log"
                  );
    XCTAssertTrue(!dto.captureConnectivity,
                  @"Proper capture connectivity"
                  );
    XCTAssertTrue(dto.viewInputsScrubber.enabled,
                  @"Proper view inputs scrubber enabled"
                  );
    XCTAssertTrue(dto.viewInputsScrubber.scrubFields.count == 0,
                  @"Proper view inputs scrubber scrub fields count"
                  );
    XCTAssertTrue(dto.viewInputsScrubber.safeListFields.count == 0,
                  @"Proper view inputs scrubber white list fields count"
                  );

}

- (void)testRollbarLoggingOptionsDTO {
    RollbarLoggingOptions *dto = [[RollbarLoggingOptions alloc] initWithLogLevel:RollbarLevel_Error
                                                                          crashLevel:RollbarLevel_Info
                                                             maximumReportsPerMinute:45];
    dto.captureIp = RollbarCaptureIpType_Anonymize;
    dto.codeVersion = @"CODEVERSION";
    dto.framework = @"FRAMEWORK";
    dto.requestId = @"REQUESTID";
    
    XCTAssertTrue(dto.logLevel == RollbarLevel_Error,
                  @"Proper log level"
                  );
    XCTAssertTrue(dto.crashLevel == RollbarLevel_Info,
                  @"Proper crash level"
                  );
    XCTAssertTrue(dto.maximumReportsPerMinute == 45,
                  @"Proper max reports per minute"
                  );
    XCTAssertTrue(dto.captureIp == RollbarCaptureIpType_Anonymize,
                  @"Proper capture IP"
                  );
    XCTAssertTrue([dto.codeVersion isEqualToString:@"CODEVERSION"],
                  @"Proper code version"
                  );
    XCTAssertTrue([dto.framework isEqualToString:@"FRAMEWORK"],
                  @"Proper framework"
                  );
    XCTAssertTrue([dto.requestId isEqualToString:@"REQUESTID"],
                  @"Proper request ID"
                  );
    
    dto = [[RollbarLoggingOptions alloc] init];
    XCTAssertTrue(dto.logLevel == RollbarLevel_Info,
                  @"Proper default log level"
                  );
    XCTAssertTrue(dto.crashLevel == RollbarLevel_Error,
                  @"Proper default crash level"
                  );
    XCTAssertTrue(dto.maximumReportsPerMinute == 60,
                  @"Proper default max reports per minute"
                  );
    XCTAssertTrue(dto.captureIp == RollbarCaptureIpType_Full,
                  @"Proper default capture IP"
                  );
    XCTAssertNil(dto.codeVersion,
                 @"Proper default code version"
                 );
    XCTAssertTrue([dto.framework isEqualToString:@"macos"] || [dto.framework isEqualToString:@"ios"],
                  @"Proper default framework"
                  );
    XCTAssertNil(dto.requestId,
                 @"Proper request ID"
                 );
}


- (void)testRollbarConfigDTO {
    RollbarConfig *rc = [RollbarConfig new];
    //id destination = rc.destination;
    rc.destination.accessToken = @"ACCESSTOKEN";
    rc.destination.environment = @"ENVIRONMENT";
    rc.destination.endpoint = @"ENDPOINT";
    //rc.logLevel = RollbarDebug;
    
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

- (void)testRollbarMessageDTO {
    NSString *messageBody = @"Test message";
    RollbarMessage *dto = [[RollbarMessage alloc] initWithBody:messageBody];
    XCTAssertEqual(messageBody, dto.body);
    
    NSError *error = [NSError errorWithDomain:@"ERROR_DOMAIN" code:100 userInfo:nil];
    dto = [[RollbarMessage alloc] initWithNSError:error];
    XCTAssertNotNil(dto);
    XCTAssertTrue([dto.body containsString:@"ERROR_DOMAIN"]);
    XCTAssertTrue([dto.body containsString:@"100"]);
}

- (void)testMessageRollbarBodyDTO {
    NSString *message = @"Test message";
    RollbarBody *dto = [[RollbarBody alloc] initWithMessage:message];
    XCTAssertNotNil(dto);
    XCTAssertNotNil(dto.message);
    XCTAssertNotNil(dto.message.body);
    XCTAssertEqual(message, dto.message.body);
    XCTAssertNil(dto.crashReport);
    XCTAssertNil(dto.trace);
    XCTAssertNil(dto.traceChain);
}

- (void)testCrashReportRollbarBodyDTO {
    NSString *data = @"RAW_CRASH_REPORT_CONTENT";
    RollbarBody *dto = [[RollbarBody alloc] initWithCrashReport:data];
    XCTAssertNotNil(dto);
    XCTAssertNotNil(dto.crashReport);
    XCTAssertNotNil(dto.crashReport.rawCrashReport);
    XCTAssertEqual(data, dto.crashReport.rawCrashReport);
    XCTAssertNil(dto.message);
    XCTAssertNil(dto.trace);
    XCTAssertNil(dto.traceChain);
}

- (void)testRollbarJavascriptDTO {
    NSString *browser = @"BROWSER";
    NSString *codeVersion = @"CODE_VERSION";
    RollbarTriStateFlag sourceMapsEnabled = RollbarTriStateFlag_On;
    RollbarTriStateFlag guessUncaughtExceptionFrames = RollbarTriStateFlag_Off;
    
    RollbarJavascript *dto = [[RollbarJavascript alloc] initWithBrowser:browser
                                                            codeVersion:nil
                                                       sourceMapEnabled:sourceMapsEnabled
                                                    guessUncaughtFrames:guessUncaughtExceptionFrames];    
    XCTAssertNotNil(dto);
    XCTAssertNotNil(dto.browser);
    XCTAssertNil(dto.codeVersion);
    XCTAssertEqual(browser, dto.browser);
    XCTAssertEqual(sourceMapsEnabled, dto.sourceMapEnabled);
    XCTAssertEqual(guessUncaughtExceptionFrames, dto.guessUncaughtFrames);

    dto.codeVersion = codeVersion;
    XCTAssertNotNil(dto.codeVersion);
    XCTAssertEqual(codeVersion, dto.codeVersion);
}

- (void)testRollbarClientDTO {
    NSString *browser = @"BROWSER";
    NSString *codeVersion = @"CODE_VERSION";
    RollbarTriStateFlag sourceMapsEnabled = RollbarTriStateFlag_On;
    RollbarTriStateFlag guessUncaughtExceptionFrames = RollbarTriStateFlag_Off;
    
    RollbarJavascript *dtoJavascript = [[RollbarJavascript alloc] initWithBrowser:browser
                                                            codeVersion:codeVersion
                                                       sourceMapEnabled:sourceMapsEnabled
                                                    guessUncaughtFrames:guessUncaughtExceptionFrames];
    NSString *cpu = @"CPU";
    RollbarClient *dto = [[RollbarClient alloc] initWithCpu:cpu javaScript:dtoJavascript];
    
    XCTAssertNotNil(dto);
    XCTAssertNotNil(dto.cpu);
    XCTAssertEqual(cpu, dto.cpu);
    XCTAssertNotNil(dto.javaScript);
    XCTAssertEqual(browser, dto.javaScript.browser);
    XCTAssertEqual(sourceMapsEnabled, dto.javaScript.sourceMapEnabled);
    XCTAssertEqual(guessUncaughtExceptionFrames, dto.javaScript.guessUncaughtFrames);
    XCTAssertEqual(codeVersion, dto.javaScript.codeVersion);
}

- (void)testRollbarServerDTO {
    NSString *cpu = @"CPU";
    NSString *host = @"HOST";
    NSString *root = @"ROOT";
    NSString *branch = @"BRANCH";
    NSString *codeVersion = nil;

    RollbarServer *dto = [[RollbarServer alloc] initWithCpu:cpu
                                                       host:host
                                                       root:root
                                                     branch:branch
                                                codeVersion:codeVersion];
    
    XCTAssertNotNil(dto);

    XCTAssertNotNil(dto.cpu);
    XCTAssertNotNil(dto.host);
    XCTAssertNotNil(dto.root);
    XCTAssertNotNil(dto.branch);
    XCTAssertNil(dto.codeVersion);

    XCTAssertEqual(cpu, dto.cpu);
    XCTAssertEqual(host, dto.host);
    XCTAssertEqual(root, dto.root);
    XCTAssertEqual(branch, dto.branch);
    XCTAssertEqual(codeVersion, dto.codeVersion);
}

- (void)testRollbarRequestDTO {
    RollbarHttpMethod method = RollbarHttpMethod_Get;
    NSDictionary *headers = @{@"HEADER_1":@"HEADER1", @"HEADER_2":@"HEADER2"};
    NSDictionary *params = @{@"PARAM_1":@"PARAM1", @"PARAM_2":@"PARAM2"};
    NSDictionary *getParams = @{@"GET_PARAM_1":@"GETPARAM1", @"GET_PARAM_2":@"GETPARAM2"};
    NSDictionary *postParams = nil;
    NSString *url = @"URL";
    NSString *queryString = @"QUERYSTRING";
    NSString *postBody = nil;
    NSString *userIP = @"USERIP";

    RollbarRequest *dto = [[RollbarRequest alloc] initWithHttpMethod:method
                                                                 url:url
                                                             headers:headers
                                                              params:params
                                                         queryString:queryString
                                                           getParams:getParams
                                                          postParams:postParams
                                                            postBody:postBody
                                                              userIP:userIP];
    
    XCTAssertNotNil(dto);

    XCTAssertNotNil(dto.headers);
    XCTAssertNotNil(dto.params);
    XCTAssertNotNil(dto.getParams);
    XCTAssertNil(dto.postParams);
    XCTAssertNotNil(dto.url);
    XCTAssertNotNil(dto.queryString);
    XCTAssertNil(dto.postBody);
    XCTAssertNotNil(dto.userIP);

    XCTAssertEqual(dto.method, method);
    XCTAssertEqual(dto.headers, headers);
    XCTAssertEqual(dto.params, params);
    XCTAssertEqual(dto.getParams, getParams);
    XCTAssertEqual(dto.postParams, postParams);
    XCTAssertEqual(dto.url, url);
    XCTAssertEqual(dto.queryString, queryString);
    XCTAssertEqual(dto.postBody, postBody);
    XCTAssertEqual(dto.userIP, userIP);
}

- (void)testRollbarExceptionDTO {
    NSString *exceptionClass = @"EXCEPTION_CLASS";
    NSString *exceptionMessage = @"EXCEPTIION_MESSAGE";
    NSString *exceptionDescription = nil;

    RollbarException *dto = [[RollbarException alloc] initWithExceptionClass:exceptionClass
                                                            exceptionMessage:exceptionMessage
                                                        exceptionDescription:exceptionDescription];
    
    XCTAssertNotNil(dto);

    XCTAssertNotNil(dto.exceptionClass);
    XCTAssertNotNil(dto.exceptionMessage);
    XCTAssertNil(dto.exceptionDescription);

    XCTAssertEqual(dto.exceptionClass, exceptionClass);
    XCTAssertEqual(dto.exceptionMessage, exceptionMessage);
    XCTAssertEqual(dto.exceptionDescription, exceptionDescription);
}

- (void)testRollbarCallStackFrameContextDTO {
    NSArray<NSString *> *pre = @[@"CODE_PR1", @"CODE_PR2"];
    NSArray<NSString *> *post = nil;

    RollbarCallStackFrameContext *dto = [[RollbarCallStackFrameContext alloc] initWithPreCodeLines:pre
                                                                                     postCodeLines:post];
    
    XCTAssertNotNil(dto);

    XCTAssertNotNil(dto.preCodeLines);
    XCTAssertNil(dto.postCodeLines);

    XCTAssertEqual(dto.preCodeLines.count, 2);
    XCTAssertTrue([dto.preCodeLines containsObject:pre[0]]);
    XCTAssertTrue([dto.preCodeLines containsObject:pre[1]]);
}

- (void)testRollbarCallStackFrameDTO {
    NSString *filename = @"FILENAME";

    NSString *className = @"CLASSNAME";
    NSString *code = @"CODE";
    NSString *method = @"METHOD";

    NSNumber *colno = @111;
    NSNumber *lineno = @222;
    
    NSArray<NSString *> *pre = @[@"CODE_PR1", @"CODE_PR2"];
    NSArray<NSString *> *post = nil;
    RollbarCallStackFrameContext *codeContext = [[RollbarCallStackFrameContext alloc] initWithPreCodeLines:pre
                                                                                             postCodeLines:post];
    XCTAssertNotNil(codeContext);
    XCTAssertNotNil(codeContext.preCodeLines);
    XCTAssertNil(codeContext.postCodeLines);
    XCTAssertEqual(codeContext.preCodeLines.count, 2);
    XCTAssertTrue([codeContext.preCodeLines containsObject:pre[0]]);
    XCTAssertTrue([codeContext.preCodeLines containsObject:pre[1]]);

    NSDictionary *locals  = @{
        @"VAR1": @"VAL1",
        @"VAR2": @"VAL2",
    };

    NSArray<NSString *> *argspec = @[];
    NSArray<NSString *> *varargspec = @[@"VARARG1"];
    NSArray<NSString *> *keywordspec = @[@"KW1", @"KW2"];
    
    RollbarCallStackFrame *dto = [[RollbarCallStackFrame alloc] initWithFileName:filename];
    XCTAssertNotNil(dto);
    XCTAssertNotNil(dto.filename);
    XCTAssertEqual(dto.filename, filename);

    XCTAssertNil(dto.className);
    XCTAssertNil(dto.code);
    XCTAssertNil(dto.method);
    dto.className = className;
    dto.code = code;
    dto.method = method;
    XCTAssertNotNil(dto.className);
    XCTAssertNotNil(dto.code);
    XCTAssertNotNil(dto.method);
    XCTAssertEqual(dto.className, className);
    XCTAssertEqual(dto.code, code);
    XCTAssertEqual(dto.method, method);

    XCTAssertNil(dto.colno);
    XCTAssertNil(dto.lineno);
    dto.colno = colno;
    dto.lineno = lineno;
    XCTAssertNotNil(dto.colno);
    XCTAssertNotNil(dto.lineno);
    XCTAssertEqual(dto.colno, colno);
    XCTAssertEqual(dto.lineno, lineno);

    XCTAssertNil(dto.context);
    dto.context = codeContext;
    XCTAssertNotNil(dto.context);
    XCTAssertEqual(dto.context.preCodeLines.count, codeContext.preCodeLines.count);
    XCTAssertTrue([dto.context.preCodeLines containsObject:pre[0]]);
    XCTAssertTrue([dto.context.preCodeLines containsObject:pre[1]]);
    XCTAssertNil(dto.context.postCodeLines);
    
    XCTAssertNil(dto.locals);
    dto.locals = locals;
    XCTAssertNotNil(dto.locals);
    XCTAssertEqual(dto.locals.count, locals.count);

    XCTAssertNil(dto.argspec);
    dto.argspec = argspec;
    XCTAssertNotNil(dto.argspec);
    XCTAssertEqual(dto.argspec.count, argspec.count);
    
    XCTAssertNil(dto.varargspec);
    dto.varargspec = varargspec;
    XCTAssertNotNil(dto.varargspec);
    XCTAssertEqual(dto.varargspec.count, varargspec.count);

    XCTAssertNil(dto.keywordspec);
    dto.keywordspec = keywordspec;
    XCTAssertNotNil(dto.keywordspec);
    XCTAssertEqual(dto.keywordspec.count, keywordspec.count);
    
}

- (void)testRollbarTraceDTO {
    
    NSString *exceptionClass = @"EXCEPTION_CLASS";
    NSString *exceptionMessage = @"EXCEPTIION_MESSAGE";
    NSString *exceptionDescription = nil;

    RollbarException *exceptionDto = [[RollbarException alloc] initWithExceptionClass:exceptionClass
                                                                     exceptionMessage:exceptionMessage
                                                                 exceptionDescription:exceptionDescription];

    NSString *filename = @"FILENAME";
    NSString *className = @"CLASSNAME";
    NSString *code = @"CODE";
    NSString *method = @"METHOD";
    NSNumber *colno = @111;
    NSNumber *lineno = @222;
    NSArray<NSString *> *pre = @[@"CODE_PR1", @"CODE_PR2"];
    NSArray<NSString *> *post = nil;
    RollbarCallStackFrameContext *codeContext = [[RollbarCallStackFrameContext alloc] initWithPreCodeLines:pre
                                                                                             postCodeLines:post];
    NSDictionary *locals  = @{
        @"VAR1": @"VAL1",
        @"VAR2": @"VAL2",
    };
    NSArray<NSString *> *argspec = @[];
    NSArray<NSString *> *varargspec = @[@"VARARG1"];
    NSArray<NSString *> *keywordspec = @[@"KW1", @"KW2"];
    
    RollbarCallStackFrame *frameDto = [[RollbarCallStackFrame alloc] initWithFileName:filename];
    frameDto.className = className;
    frameDto.code = code;
    frameDto.method = method;
    frameDto.colno = colno;
    frameDto.lineno = lineno;
    frameDto.context = codeContext;
    frameDto.locals = locals;
    frameDto.argspec = argspec;
    frameDto.varargspec = varargspec;
    frameDto.keywordspec = keywordspec;
    
    RollbarTrace *dto = [[RollbarTrace alloc] initWithRollbarException:exceptionDto
                                                rollbarCallStackFrames:@[frameDto, frameDto]];
    XCTAssertNotNil(dto);
    XCTAssertNotNil(dto.exception);
    XCTAssertNotNil(dto.frames);
    XCTAssertEqual(dto.exception.exceptionClass, exceptionClass);
    XCTAssertEqual(dto.frames.count, 2);
    XCTAssertEqual(dto.frames[0].filename, filename);
    XCTAssertEqual(dto.frames[1].filename, filename);
}

-(void)testRollbarTelemetryEventDTO_properBodyBasedOnType {
    
    RollbarLevel level = RollbarLevel_Warning;
    RollbarSource source = RollbarSource_Server;
    RollbarTelemetryType type;
    RollbarTelemetryEvent *event = nil;
    
    type = RollbarTelemetryType_Log;
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                           telemetryType:type
                                                  source:source];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, type);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[RollbarTelemetryLogBody class]]);

    type = RollbarTelemetryType_View;
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                           telemetryType:type
                                                  source:source];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, type);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[RollbarTelemetryViewBody class]]);
    
    type = RollbarTelemetryType_Error;
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                           telemetryType:type
                                                  source:source];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, type);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[RollbarTelemetryErrorBody class]]);
    
    type = RollbarTelemetryType_Navigation;
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                           telemetryType:type
                                                  source:source];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, type);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[RollbarTelemetryNavigationBody class]]);
    
    type = RollbarTelemetryType_Network;
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                           telemetryType:type
                                                  source:source];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, type);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[RollbarTelemetryNetworkBody class]]);
    
    type = RollbarTelemetryType_Connectivity;
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                           telemetryType:type
                                                  source:source];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, type);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[RollbarTelemetryConnectivityBody class]]);
    
    type = RollbarTelemetryType_Manual;
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                           telemetryType:type
                                                  source:source];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, type);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[RollbarTelemetryManualBody class]]);
}

-(void)testRollbarTelemetryEventDTO_Log {
    
    RollbarLevel level = RollbarLevel_Warning;
    RollbarSource source = RollbarSource_Server;
    NSDictionary *extra = @{
        @"EXTRA1":@"extra_1",
        @"EXTRA2":@"extra_2",
    };
    RollbarTelemetryEvent *event = nil;
    
    NSString *logMessage = @"log message";
    RollbarTelemetryBody *body = [[RollbarTelemetryLogBody alloc] initWithMessage:logMessage
                                                                        extraData:extra];
    
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                                  source:source
                                                    body:body];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, RollbarTelemetryType_Log);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[body class]]);
    for (NSString *key in extra) {
        XCTAssertEqual(event.body.jsonFriendlyData[key], extra[key]);
    }

    XCTAssertEqual(((RollbarTelemetryLogBody *) event.body).message, logMessage);
}

-(void)testRollbarTelemetryEventDTO_View {
    
    RollbarLevel level = RollbarLevel_Warning;
    RollbarSource source = RollbarSource_Server;
    NSDictionary *extra = @{
        @"EXTRA1":@"extra_1",
        @"EXTRA2":@"extra_2",
    };
    RollbarTelemetryEvent *event = nil;
    
    NSString *viewElement = @"The element";
    RollbarTelemetryBody *body = [[RollbarTelemetryViewBody alloc] initWithElement:viewElement
                                                                         extraData:extra];
    
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                                  source:source
                                                    body:body];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, RollbarTelemetryType_View);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[body class]]);
    for (NSString *key in extra) {
        XCTAssertEqual(event.body.jsonFriendlyData[key], extra[key]);
    }

    XCTAssertEqual(((RollbarTelemetryViewBody *) event.body).element, viewElement);
}

-(void)testRollbarTelemetryEventDTO_Error {
    
    RollbarLevel level = RollbarLevel_Warning;
    RollbarSource source = RollbarSource_Server;
    NSDictionary *extra = @{
        @"EXTRA1":@"extra_1",
        @"EXTRA2":@"extra_2",
    };
    RollbarTelemetryEvent *event = nil;
    
    NSString *logMessage = @"error message";
    RollbarTelemetryBody *body = [[RollbarTelemetryErrorBody alloc] initWithMessage:logMessage
                                                                          extraData:extra];
    
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                                  source:source
                                                    body:body];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, RollbarTelemetryType_Error);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[body class]]);
    for (NSString *key in extra) {
        XCTAssertEqual(event.body.jsonFriendlyData[key], extra[key]);
    }

    XCTAssertEqual(((RollbarTelemetryErrorBody *) event.body).message, logMessage);
}

-(void)testRollbarTelemetryEventDTO_Navigation {
    
    RollbarLevel level = RollbarLevel_Warning;
    RollbarSource source = RollbarSource_Server;
    NSDictionary *extra = @{
        @"EXTRA1":@"extra_1",
        @"EXTRA2":@"extra_2",
    };
    RollbarTelemetryEvent *event = nil;
    
    NSString *from = @"FROM";
    NSString *to = @"TO";
    RollbarTelemetryBody *body = [[RollbarTelemetryNavigationBody alloc] initWithFromLocation:from
                                                                                   toLocation:to
                                                                                    extraData:extra];
    
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                                  source:source
                                                    body:body];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, RollbarTelemetryType_Navigation);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[body class]]);
    for (NSString *key in extra) {
        XCTAssertEqual(event.body.jsonFriendlyData[key], extra[key]);
    }

    XCTAssertEqual(((RollbarTelemetryNavigationBody *) event.body).from, from);
    XCTAssertEqual(((RollbarTelemetryNavigationBody *) event.body).to, to);
}

-(void)testRollbarTelemetryEventDTO_Network {
    
    RollbarLevel level = RollbarLevel_Warning;
    RollbarSource source = RollbarSource_Server;
    NSDictionary *extra = @{
        @"EXTRA1":@"extra_1",
        @"EXTRA2":@"extra_2",
    };
    RollbarTelemetryEvent *event = nil;
    
    RollbarHttpMethod method = RollbarHttpMethod_Patch;
    NSString *url = @"URL";
    NSString *statusCode = @"STATUS_CODE";
    RollbarTelemetryBody *body = [[RollbarTelemetryNetworkBody alloc] initWithMethod:method
                                                                                 url:url
                                                                          statusCode:statusCode
                                                                           extraData:extra];
    
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                                  source:source
                                                    body:body];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, RollbarTelemetryType_Network);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[body class]]);
    for (NSString *key in extra) {
        XCTAssertEqual(event.body.jsonFriendlyData[key], extra[key]);
    }

    XCTAssertEqual(((RollbarTelemetryNetworkBody *) event.body).method, method);
    XCTAssertEqual(((RollbarTelemetryNetworkBody *) event.body).url, url);
    XCTAssertEqual(((RollbarTelemetryNetworkBody *) event.body).statusCode, statusCode);
}

-(void)testRollbarTelemetryEventDTO_Connectivity {
    
    RollbarLevel level = RollbarLevel_Warning;
    RollbarSource source = RollbarSource_Server;
    NSDictionary *extra = @{
        @"EXTRA1":@"extra_1",
        @"EXTRA2":@"extra_2",
    };
    RollbarTelemetryEvent *event = nil;
    
    NSString *status = @"STATUS_GOOD";
    RollbarTelemetryBody *body = [[RollbarTelemetryConnectivityBody alloc] initWithStatus:status
                                                                                extraData:extra];
    
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                                  source:source
                                                    body:body];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, RollbarTelemetryType_Connectivity);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[body class]]);
    for (NSString *key in extra) {
        XCTAssertEqual(event.body.jsonFriendlyData[key], extra[key]);
    }

    XCTAssertEqual(((RollbarTelemetryConnectivityBody *) event.body).status, status);
}

-(void)testRollbarTelemetryEventDTO_Manual {
    
    RollbarLevel level = RollbarLevel_Warning;
    RollbarSource source = RollbarSource_Server;
    NSDictionary *extra = @{
        @"EXTRA1":@"extra_1",
        @"EXTRA2":@"extra_2",
    };
    RollbarTelemetryEvent *event = nil;
    
    RollbarTelemetryBody *body = [[RollbarTelemetryManualBody alloc] initWithDictionary:extra];
    
    event = [[RollbarTelemetryEvent alloc] initWithLevel:level
                                                  source:source
                                                    body:body];
    XCTAssertEqual(event.level, level);
    XCTAssertEqual(event.source, source);
    XCTAssertEqual(event.type, RollbarTelemetryType_Manual);
    XCTAssertNotNil(event.body);
    XCTAssertTrue([event.body isKindOfClass:[body class]]);
    for (NSString *key in extra) {
        XCTAssertEqual(event.body.jsonFriendlyData[key], extra[key]);
    }
}

@end
