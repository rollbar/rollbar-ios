import XCTest
import Foundation
@testable import RollbarNotifier

final class RollbarNotifierDTOsTests: XCTestCase {
    
    override class func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testBasicDTOInitializationWithJSONString() {
        
        let jsonString = "{\"access_token\":\"ACCESS_TOKEN\", \"data\":{\"environment\":\"ENV\"}}";
        let jsonPayload = "{\"access_token\":\"ACCESS_TOKEN\"}";
        let jsonData = "{\"environment\":\"ENV\"}";

        let payloadAtOnce = RollbarPayload(jsonString: jsonString);
        XCTAssertNotNil(payloadAtOnce,
                        "Payload instance"
                        );
        XCTAssertTrue(.orderedSame == payloadAtOnce.accessToken.compare("ACCESS_TOKEN", options: .caseInsensitive),
            "Access token field [\(payloadAtOnce.accessToken)] of payload: \(payloadAtOnce.serializeToJSONString())."
                      );
        XCTAssertNotNil(payloadAtOnce.data,
                        "Data field of payload: \(payloadAtOnce.serializeToJSONString())."
                        );
        XCTAssertTrue(.orderedSame == payloadAtOnce.data.environment.compare("ENV", options: .caseInsensitive),
                      "Environment field [\(payloadAtOnce.data.environment)] of payload: \(payloadAtOnce.serializeToJSONString())."
                      );

        let payload = RollbarPayload(jsonString: jsonPayload);
        let payloadData = RollbarData(jsonString: jsonData);
        payload.data = payloadData;
        XCTAssertTrue(.orderedSame == payloadAtOnce.serializeToJSONString().compare(payload.serializeToJSONString()),
                      "payloadAtOnce [\(payloadAtOnce.serializeToJSONString())] must match payload: [\(payload.serializeToJSONString())]."
                      );

        XCTAssertTrue(!payload.hasSameDefinedProperties(as: payloadData),
                      "RollbarPayload and RollbarData DTOs do not have same defined properties"
                      );
        XCTAssertTrue(payload.hasSameDefinedProperties(as: payloadAtOnce),
                      "Two RollbarPayload DTOs do not have same defined properties"
                      );
        
        XCTAssertEqual(payloadAtOnce, payload,
                      "Two RollbarPayload DTOs are expected to be equal"
                      );

        payload.accessToken = "SOME_OTHER_ONE";
        XCTAssertNotEqual(payloadAtOnce, payload,
                      "Two RollbarPayload DTOs are NOT expected to be equal"
                      );

        //id result = payload.getDefinedProperties();
    }

    func testRollbarProxyDTO() {
        
        let proxyEnabled = false;
        let proxyPort = UInt(3000);
        let proxyUrl = "PROXY_URL";
        let dto = RollbarProxy(enabled: proxyEnabled, proxyUrl: proxyUrl, proxyPort: proxyPort);
        XCTAssertTrue(dto.enabled == proxyEnabled,
                      "Proxy enabled."
                      );
        XCTAssertTrue(dto.proxyPort == proxyPort,
                      "Proxy port."
                      );
        XCTAssertTrue(dto.proxyUrl == proxyUrl,
                      "Proxy URL."
                      );
    }
    
    func testRollbarScrubbingOptionsDTO() {
        
        let dto = RollbarScrubbingOptions(scrubFields: ["field1", "field2"]);
        XCTAssertTrue(dto.enabled,
                      "Enabled by default"
                      );
        XCTAssertTrue(dto.scrubFields.count == 2,
                      "Has some scrub fields"
                      );
        XCTAssertTrue(dto.safeListFields.count == 0,
                      "Has NO whitelist fields"
                      );
        
        dto.safeListFields = ["tf1", "tf2", "tf3"];
        XCTAssertTrue(dto.safeListFields.count == 3,
                      "Has some whitelist fields"
                      );
        
        dto.enabled = false;
        XCTAssertTrue(!dto.enabled,
                      "Expected to be disabled"
                      );
    }

    func testRollbarServerConfigDTO() {
        
        var dto = RollbarServerConfig(host: "HOST", root: "ROOT", branch: "BRANCH", codeVersion: "1.2.3");
        
        XCTAssertTrue(.orderedSame == dto.host!.compare("HOST"),
                      "Proper host"
                      );
        XCTAssertTrue(.orderedSame == dto.root!.compare("ROOT"),
                      "Proper root"
                      );
        XCTAssertTrue(.orderedSame == dto.branch!.compare("BRANCH"),
                      "Proper branch"
                      );
        XCTAssertTrue(.orderedSame == dto.codeVersion!.compare("1.2.3"),
                      "Proper code version"
                      );

        dto.host = "h1";
        XCTAssertTrue(.orderedSame == dto.host!.compare("h1"),
                      "Proper new host"
                      );
        dto.root = "r1";
        XCTAssertTrue(.orderedSame == dto.root!.compare("r1"),
                      "Proper new root"
                      );
        dto.branch = "b1";
        XCTAssertTrue(.orderedSame == dto.branch!.compare("b1"),
                      "Proper new branch"
                      );
        dto.codeVersion = "3.2.5";
        XCTAssertTrue(.orderedSame == dto.codeVersion!.compare("3.2.5"),
                      "Proper new code version"
                      );
        
        
        let rc = RollbarConfig();
        rc.destination.accessToken = "ACCESSTOKEN";
        rc.destination.environment = "ENVIRONMENT";
        rc.destination.endpoint = "ENDPOINT";
        
        dto = rc.server;
        let branchValue = dto.branch;
        XCTAssertNil(branchValue,
                      "Uninitialized branch"
                      );
        dto.branch = "ANOTHER_BRANCH";
        XCTAssertTrue(.orderedSame == dto.branch!.compare("ANOTHER_BRANCH"),
                      "Proper branch"
                      );
    }

    func testRollbarPersonDTO() {
        
        var dto = RollbarPerson(id: "ID", username: "USERNAME", email: "EMAIL");

        XCTAssertTrue(.orderedSame == dto.id.compare("ID"),
                      "Proper ID"
                      );
        XCTAssertTrue(.orderedSame == dto.username!.compare("USERNAME"),
                      "Proper username"
                      );
        XCTAssertTrue(.orderedSame == dto.email!.compare("EMAIL"),
                      "Proper email"
                      );

        dto.id = "ID1";
        XCTAssertTrue(.orderedSame == dto.id.compare("ID1"),
                      "Proper ID"
                      );
        dto.username = "USERNAME1";
        XCTAssertTrue(.orderedSame == dto.username!.compare("USERNAME1"),
                      "Proper username"
                      );
        dto.email = "EMAIL1";
        XCTAssertTrue(.orderedSame == dto.email!.compare("EMAIL1"),
                      "Proper email"
                      );
        
        dto = RollbarPerson(id: "ID007");
        XCTAssertTrue(.orderedSame == dto.id.compare("ID007"),
                      "Proper ID"
                      );
        XCTAssertNil(dto.username,
                     "Proper default username"
                     );
        XCTAssertNil(dto.email,
                     "Proper default email"
                     );
    }

    func testRollbarModuleDTO() {
        
        var dto = RollbarModule(name: "ModuleName", version: "v1.2.3");
        
        XCTAssertTrue(.orderedSame == dto.name!.compare("ModuleName"),
                      "Proper name"
                      );
        XCTAssertTrue(.orderedSame == dto.version!.compare("v1.2.3"),
                      "Proper version"
                      );

        dto.name = "MN1";
        XCTAssertTrue(.orderedSame == dto.name!.compare("MN1"),
                      "Proper name"
                      );
        dto.version = "v3.2.1";
        XCTAssertTrue(.orderedSame == dto.version!.compare("v3.2.1"),
                      "Proper version"
                      );

        dto = RollbarModule(name: "Module");
        XCTAssertTrue(.orderedSame == dto.name!.compare("Module"),
                      "Proper name"
                      );
        XCTAssertNil(dto.version,
                     "Proper version"
                     );
    }
    
    func testRollbarTelemetryOptionsDTO() {
        
        let scrubber = RollbarScrubbingOptions(
            enabled: true,
            scrubFields: ["one", "two"],
            safeListFields: ["two", "three", "four"]
        );
        var dto = RollbarTelemetryOptions(
            enabled: true,
            captureLog: true,
            captureConnectivity: true,
            viewInputsScrubber: scrubber
        );
        
        XCTAssertTrue(dto.enabled,
                      "Proper enabled"
                      );
        XCTAssertTrue(dto.captureLog,
                      "Proper capture log"
                      );
        XCTAssertTrue(dto.captureConnectivity,
                      "Proper capture connectivity"
                      );
        XCTAssertTrue(dto.viewInputsScrubber.enabled,
                      "Proper view inputs scrubber enabled"
                      );
        XCTAssertTrue(dto.viewInputsScrubber.scrubFields.count == 2,
                      "Proper view inputs scrubber scrub fields count"
                      );
        XCTAssertTrue(dto.viewInputsScrubber.safeListFields.count == 3,
                      "Proper view inputs scrubber white list fields count"
                      );
        
        dto = RollbarTelemetryOptions();
        XCTAssertTrue(!dto.enabled,
                      "Proper enabled"
                      );
        XCTAssertTrue(!dto.captureLog,
                      "Proper capture log"
                      );
        XCTAssertTrue(!dto.captureConnectivity,
                      "Proper capture connectivity"
                      );
        XCTAssertTrue(dto.viewInputsScrubber.enabled,
                      "Proper view inputs scrubber enabled"
                      );
        XCTAssertTrue(dto.viewInputsScrubber.scrubFields.count == 0,
                      "Proper view inputs scrubber scrub fields count"
                      );
        XCTAssertTrue(dto.viewInputsScrubber.safeListFields.count == 0,
                      "Proper view inputs scrubber white list fields count"
                      );

    }
    
    func testRollbarLoggingOptionsDTO() {
        
        var dto = RollbarLoggingOptions(
            logLevel: .error,
            crash: .info,
            maximumReportsPerMinute: UInt(45)
        );
        dto.captureIp = .anonymize;
        dto.codeVersion = "CODEVERSION";
        dto.framework = "FRAMEWORK";
        dto.requestId = "REQUESTID";
        
        XCTAssertTrue(dto.logLevel == .error,
                      "Proper log level"
                      );
        XCTAssertTrue(dto.crashLevel == .info,
                      "Proper crash level"
                      );
        XCTAssertTrue(dto.maximumReportsPerMinute == 45,
                      "Proper max reports per minute"
                      );
        XCTAssertTrue(dto.captureIp == .anonymize,
                      "Proper capture IP"
                      );
        XCTAssertTrue(.orderedSame == dto.codeVersion?.compare("CODEVERSION"),
                      "Proper code version"
                      );
        XCTAssertTrue(.orderedSame == dto.framework!.compare("FRAMEWORK"),
                      "Proper framework"
                      );
        XCTAssertTrue(.orderedSame == dto.requestId!.compare("REQUESTID"),
                      "Proper request ID"
                      );
        
        dto = RollbarLoggingOptions();
        XCTAssertTrue(dto.logLevel == .info,
                      "Proper default log level"
                      );
        XCTAssertTrue(dto.crashLevel == .error,
                      "Proper default crash level"
                      );
        XCTAssertTrue(dto.maximumReportsPerMinute == 60,
                      "Proper default max reports per minute"
                      );
        XCTAssertTrue(dto.captureIp == .full,
                      "Proper default capture IP"
                      );
        XCTAssertNil(dto.codeVersion,
                     "Proper default code version"
                     );
        XCTAssertTrue(
            (.orderedSame == dto.framework!.compare("macos"))
            || (.orderedSame == dto.framework!.compare("ios")
            ),
            "Proper default framework"
            );
        XCTAssertNil(dto.requestId,
                     "Proper request ID"
                     );
    }
    
    func testRollbarConfigDTO() {
        
        let rc = RollbarConfig();
        //id destination = rc.destination;
        rc.destination.accessToken = "ACCESSTOKEN";
        rc.destination.environment = "ENVIRONMENT";
        rc.destination.endpoint = "ENDPOINT";
        //rc.logLevel = RollbarDebug;
        
        rc.setPersonId("PERSONID", username: "PERSONUSERNAME", email: "PERSONEMAIL");
        rc.setServerHost("SERVERHOST", root:"SERVERROOT", branch: "SERVERBRANCH", codeVersion: "SERVERCODEVERSION");
        rc.setNotifierName("NOTIFIERNAME", version: "NOTIFIERVERSION");
        
        var rcClone = RollbarConfig(jsonString: rc.serializeToJSONString());
        
    //    id scrubList = rc.scrubFields;
    //    id scrubListClone = rcClone.scrubFields;
        
        XCTAssertTrue(rc.isEqual(rcClone),
                      "Two DTOs are expected to be equal"
                      );
    //    XCTAssertTrue([[rc serializeToJSONString] isEqualToString:[rcClone serializeToJSONString]],
    //                  @"DTO [%@] must match DTO: [%@].",
    //                  [rc serializeToJSONString],
    //                  [rcClone serializeToJSONString]
    //                  );

        rcClone.destination.accessToken = "SOME_OTHER_ONE";
        XCTAssertTrue(!rc.isEqual(rcClone),
                      "Two DTOs are NOT expected to be equal"
                      );
    //    XCTAssertTrue(![[rc serializeToJSONString] isEqualToString:[rcClone serializeToJSONString]],
    //                  @"DTO [%@] must NOT match DTO: [%@].",
    //                  [rc serializeToJSONString],
    //                  [rcClone serializeToJSONString]
    //                  );

        rcClone = RollbarConfig(jsonString: rc.serializeToJSONString());
        rcClone.httpProxy.proxyUrl = "SOME_OTHER_ONE";
        XCTAssertTrue(!rc.isEqual(rcClone),
                      "Two DTOs are NOT expected to be equal"
                      );
        XCTAssertTrue(rcClone.isEqual(RollbarConfig(jsonString: rcClone.serializeToJSONString())),
                      "Two DTOs (clone and its clone) are expected to be equal"
                      );
    }

    func testRollbarMessageDTO() {
        
        let messageBody = "Test message";
        var dto = RollbarMessage(body: messageBody);
        XCTAssertEqual(messageBody, dto.body);
        
        let error = NSError(domain: "ERROR_DOMAIN", code: Int(100), userInfo: nil);
        dto = RollbarMessage(nsError: error);
        XCTAssertNotNil(dto);
        XCTAssertTrue(dto.body.contains("ERROR_DOMAIN"));
        XCTAssertTrue(dto.body.contains("100"));
    }

    func testMessageRollbarBodyDTO() {
        
        let message = "Test message";
        let dto = RollbarBody(message: message);
        XCTAssertNotNil(dto);
        XCTAssertNotNil(dto.message);
        XCTAssertNotNil(dto.message!.body);
        XCTAssertEqual(message, dto.message!.body);
        XCTAssertNil(dto.crashReport);
        XCTAssertNil(dto.trace);
        XCTAssertNil(dto.traceChain);
    }

    func testCrashReportRollbarBodyDTO() {
        
        let data = "RAW_CRASH_REPORT_CONTENT";
        let dto = RollbarBody(crashReport: data);
        XCTAssertNotNil(dto);
        XCTAssertNotNil(dto.crashReport);
        XCTAssertNotNil(dto.crashReport!.rawCrashReport);
        XCTAssertEqual(data, dto.crashReport!.rawCrashReport);
        XCTAssertNil(dto.message);
        XCTAssertNil(dto.trace);
        XCTAssertNil(dto.traceChain);
    }

    func testRollbarJavascriptDTO() {
        
        let browser = "BROWSER";
        let codeVersion = "CODE_VERSION";
        let sourceMapsEnabled = RollbarTriStateFlag.on;
        let guessUncaughtExceptionFrames = RollbarTriStateFlag.off;
        
        let dto = RollbarJavascript(
            browser: browser,
            codeVersion: nil,
            sourceMapEnabled: sourceMapsEnabled,
            guessUncaughtFrames: guessUncaughtExceptionFrames
        );
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

    func testRollbarClientDTO() {
        
        let browser = "BROWSER";
        let codeVersion = "CODE_VERSION";
        let sourceMapsEnabled = RollbarTriStateFlag.on;
        let guessUncaughtExceptionFrames = RollbarTriStateFlag.off;
        
        let dtoJavascript = RollbarJavascript(
            browser: browser,
            codeVersion: codeVersion,
            sourceMapEnabled: sourceMapsEnabled,
            guessUncaughtFrames: guessUncaughtExceptionFrames
        );
        let cpu = "CPU";
        let dto = RollbarClient(
            cpu: cpu,
            javaScript: dtoJavascript
        );
        
        XCTAssertNotNil(dto);
        XCTAssertNotNil(dto.cpu);
        XCTAssertEqual(cpu, dto.cpu);
        XCTAssertNotNil(dto.javaScript);
        XCTAssertEqual(browser, dto.javaScript!.browser);
        XCTAssertEqual(sourceMapsEnabled, dto.javaScript!.sourceMapEnabled);
        XCTAssertEqual(guessUncaughtExceptionFrames, dto.javaScript!.guessUncaughtFrames);
        XCTAssertEqual(codeVersion, dto.javaScript!.codeVersion);
    }

    func testRollbarServerDTO() {
        
        let cpu = "CPU";
        let host = "HOST";
        let root = "ROOT";
        let branch = "BRANCH";
        //let codeVersion = String();

        let dto = RollbarServer(
            cpu: cpu,
            host: host,
            root: root,
            branch: branch,
            codeVersion: nil
        );
        
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
        //XCTAssertEqual(codeVersion, dto.codeVersion);
        XCTAssertEqual(nil, dto.codeVersion);
    }

    func testRollbarRequestDTO() {
        let method = RollbarHttpMethod.get;
        let headers = ["HEADER_1": "HEADER1", "HEADER_2":"HEADER2"];
        let params = ["PARAM_1": "PARAM1", "PARAM_2": "PARAM2"];
        let getParams = ["GET_PARAM_1": "GETPARAM1", "GET_PARAM_2": "GETPARAM2"];
        //let postParams = [String: String]();
        let url = "URL";
        let queryString = "QUERYSTRING";
        //let postBody = String();
        let userIP = "USERIP";

        let dto = RollbarRequest(
            httpMethod: method,
            url: url,
            headers: headers,
            params: params,
            queryString: queryString,
            getParams: getParams,
            postParams: nil,
            postBody: nil,
            userIP: userIP
        );
        
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
        XCTAssertEqual(dto.headers as! [String: String], headers);
        XCTAssertEqual(dto.params as! [String: String], params);
        XCTAssertEqual(dto.getParams as! [String: String], getParams);
        XCTAssertEqual(dto.postParams as? [String: String], nil);
        XCTAssertEqual(dto.url, url);
        XCTAssertEqual(dto.queryString, queryString);
        XCTAssertEqual(dto.postBody, nil);
        XCTAssertEqual(dto.userIP, userIP);
    }
    
    func testRollbarExceptionDTO() {
        
        let exceptionClass = "EXCEPTION_CLASS";
        let exceptionMessage = "EXCEPTIION_MESSAGE";
        //let exceptionDescription = String();

        let dto = RollbarException(
            exceptionClass: exceptionClass,
            exceptionMessage: exceptionMessage,
            exceptionDescription: nil
        );
        
        XCTAssertNotNil(dto);

        XCTAssertNotNil(dto.exceptionClass);
        XCTAssertNotNil(dto.exceptionMessage);
        XCTAssertNil(dto.exceptionDescription);

        XCTAssertEqual(dto.exceptionClass, exceptionClass);
        XCTAssertEqual(dto.exceptionMessage, exceptionMessage);
        XCTAssertEqual(dto.exceptionDescription, nil);
    }

    func testRollbarCallStackFrameContextDTO() {
        
        let pre = ["CODE_PR1", "CODE_PR2"];
        //let post = [String]();

        let dto = RollbarCallStackFrameContext(
            preCodeLines: pre,
            postCodeLines: nil
        );
        
        XCTAssertNotNil(dto);

        XCTAssertNotNil(dto.preCodeLines);
        XCTAssertNil(dto.postCodeLines);

        XCTAssertEqual(dto.preCodeLines!.count, 2);
        XCTAssertTrue(dto.preCodeLines!.contains(pre[0]));
        XCTAssertTrue(dto.preCodeLines!.contains(pre[1]));
    }

    func testRollbarCallStackFrameDTO() {
        
        let filename = "FILENAME";

        let className = "CLASSNAME";
        let code = "CODE";
        let method = "METHOD";

        let colno = UInt(111);
        let lineno = UInt(222);
        
        let pre = ["CODE_PR1", "CODE_PR2"];
        //let post = [String]();
        let codeContext = RollbarCallStackFrameContext(
            preCodeLines: pre,
            postCodeLines: nil
        );
        
        XCTAssertNotNil(codeContext);
        XCTAssertNotNil(codeContext.preCodeLines);
        XCTAssertNil(codeContext.postCodeLines);
        XCTAssertEqual(codeContext.preCodeLines!.count, 2);
        XCTAssertTrue(codeContext.preCodeLines!.contains(pre[0]));
        XCTAssertTrue(codeContext.preCodeLines!.contains(pre[1]));

        let locals  = [
            "VAR1": "VAL1",
            "VAR2": "VAL2",
        ];

        let argspec = [String]();
        let varargspec = ["VARARG1"];
        let keywordspec = ["KW1", "KW2"];
        
        let dto = RollbarCallStackFrame(fileName: filename);
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
        dto.colno = NSNumber(value: colno);
        dto.lineno = NSNumber(value: lineno);
        XCTAssertNotNil(dto.colno);
        XCTAssertNotNil(dto.lineno);
        XCTAssertEqual(dto.colno, NSNumber(value: colno));
        XCTAssertEqual(dto.lineno, NSNumber(value: lineno));

        XCTAssertNil(dto.context);
        dto.context = codeContext;
        XCTAssertNotNil(dto.context);
        XCTAssertEqual(dto.context!.preCodeLines!.count, codeContext.preCodeLines!.count);
        XCTAssertTrue(dto.context!.preCodeLines!.contains(pre[0]));
        XCTAssertTrue(dto.context!.preCodeLines!.contains(pre[1]));
        XCTAssertNil(dto.context!.postCodeLines);
        
        XCTAssertNil(dto.locals);
        dto.locals = locals;
        XCTAssertNotNil(dto.locals);
        XCTAssertEqual(dto.locals!.count, locals.count);

        XCTAssertNil(dto.argspec);
        dto.argspec = argspec;
        XCTAssertNotNil(dto.argspec);
        XCTAssertEqual(dto.argspec!.count, argspec.count);
        
        XCTAssertNil(dto.varargspec);
        dto.varargspec = varargspec;
        XCTAssertNotNil(dto.varargspec);
        XCTAssertEqual(dto.varargspec!.count, varargspec.count);

        XCTAssertNil(dto.keywordspec);
        dto.keywordspec = keywordspec;
        XCTAssertNotNil(dto.keywordspec);
        XCTAssertEqual(dto.keywordspec!.count, keywordspec.count);
        
    }
    
    func testRollbarTraceDTO() {
        
        let exceptionClass = "EXCEPTION_CLASS";
        let exceptionMessage = "EXCEPTIION_MESSAGE";
        //let exceptionDescription = String();

        let exceptionDto = RollbarException(
            exceptionClass: exceptionClass,
            exceptionMessage: exceptionMessage,
            exceptionDescription: nil
        );

        let filename = "FILENAME";
        let className = "CLASSNAME";
        let code = "CODE";
        let method = "METHOD";
        let colno = NSNumber(value: 111);
        let lineno = NSNumber(value: 222);
        let pre = ["CODE_PR1", "CODE_PR2"];
        //let post = [String]();
        let codeContext = RollbarCallStackFrameContext(
            preCodeLines: pre,
            postCodeLines: nil
        );
        let locals  = [
            "VAR1": "VAL1",
            "VAR2": "VAL2",
        ];
        //let argspec = [String]();
        let varargspec = ["VARARG1"];
        let keywordspec = ["KW1", "KW2"];
        
        let frameDto = RollbarCallStackFrame(fileName: filename);
        frameDto.className = className;
        frameDto.code = code;
        frameDto.method = method;
        frameDto.colno = colno;
        frameDto.lineno = lineno;
        frameDto.context = codeContext;
        frameDto.locals = locals;
        frameDto.argspec = nil;
        frameDto.varargspec = varargspec;
        frameDto.keywordspec = keywordspec;
        
        let dto = RollbarTrace(
            rollbarException: exceptionDto,
            rollbarCallStackFrames: [frameDto, frameDto]
        );
        XCTAssertNotNil(dto);
        XCTAssertNotNil(dto.exception);
        XCTAssertNotNil(dto.frames);
        XCTAssertEqual(dto.exception.exceptionClass, exceptionClass);
        XCTAssertEqual(dto.frames.count, 2);
        XCTAssertEqual(dto.frames[0].filename, filename);
        XCTAssertEqual(dto.frames[1].filename, filename);
    }
    
    func testRollbarTelemetryEventDTO_properBodyBasedOnType() {
        
        let level = RollbarLevel.warning;
        let source = RollbarSource.server;
        var type: RollbarTelemetryType;
        var event: RollbarTelemetryEvent;
        
        type = .log;
        event = RollbarTelemetryEvent(
            level: level,
            telemetryType: type,
            source: source
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, type);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryLogBody);

        type = .view;
        event = RollbarTelemetryEvent(
            level: level,
            telemetryType: type,
            source: source
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, type);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryViewBody);
        
        type = .error;
        event = RollbarTelemetryEvent(
            level: level,
            telemetryType: type,
            source: source
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, type);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryErrorBody);
        
        type = .navigation;
        event = RollbarTelemetryEvent(
            level: level,
            telemetryType: type,
            source: source
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, type);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryNavigationBody);
        
        type = .network;
        event = RollbarTelemetryEvent(
            level: level,
            telemetryType: type,
            source: source
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, type);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryNetworkBody);
        
        type = .connectivity;
        event = RollbarTelemetryEvent(
            level: level,
            telemetryType: type,
            source: source
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, type);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryConnectivityBody);
        
        type = .manual;
        event = RollbarTelemetryEvent(
            level: level,
            telemetryType: type,
            source: source
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, type);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryManualBody);
    }
    
    func testRollbarTelemetryEventDTO_Log() {
        
        let level: RollbarLevel = .warning;
        let source: RollbarSource = .server;
        let extra = [
            "EXTRA1": "extra_1",
            "EXTRA2": "extra_2",
        ];
        var event: RollbarTelemetryEvent;

        let logMessage = "log message";
        let body = RollbarTelemetryLogBody(
            message: logMessage,
            extraData: extra
        );
        
        event = RollbarTelemetryEvent(
            level: level,
            source: source,
            body: body
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, RollbarTelemetryType.log);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryLogBody);
        for key in extra.keys {
            XCTAssertEqual(event.body.jsonFriendlyData[key] as? String, extra[key]);
        }

        XCTAssertEqual((event.body as! RollbarTelemetryLogBody).message, logMessage);
    }

    func testRollbarTelemetryEventDTO_View() {
        
        let level: RollbarLevel = .warning;
        let source: RollbarSource = .server;
        let extra = [
            "EXTRA1": "extra_1",
            "EXTRA2": "extra_2",
        ];
        var event: RollbarTelemetryEvent;

        let viewElement = "The element";
        let body = RollbarTelemetryViewBody(
            element: viewElement,
            extraData: extra
        );
        
        event = RollbarTelemetryEvent(
            level: level,
            source: source,
            body: body
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, RollbarTelemetryType.view);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryViewBody);
        for key in extra.keys {
            XCTAssertEqual(event.body.jsonFriendlyData[key] as? String, extra[key]);
        }

        XCTAssertEqual((event.body as! RollbarTelemetryViewBody).element, viewElement);
    }

    func testRollbarTelemetryEventDTO_Error() {
        
        let level: RollbarLevel = .warning;
        let source: RollbarSource = .server;
        let extra = [
            "EXTRA1": "extra_1",
            "EXTRA2": "extra_2",
        ];
        var event: RollbarTelemetryEvent;

        let error = "error message";
        let body = RollbarTelemetryErrorBody(
            message: error,
            extraData: extra
        );
        
        event = RollbarTelemetryEvent(
            level: level,
            source: source,
            body: body
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, RollbarTelemetryType.error);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryErrorBody);
        for key in extra.keys {
            XCTAssertEqual(event.body.jsonFriendlyData[key] as? String, extra[key]);
        }

        XCTAssertEqual((event.body as! RollbarTelemetryErrorBody).message, error);
    }

    func testRollbarTelemetryEventDTO_Navigation() {
        
        let level: RollbarLevel = .warning;
        let source: RollbarSource = .server;
        let extra = [
            "EXTRA1": "extra_1",
            "EXTRA2": "extra_2",
        ];
        var event: RollbarTelemetryEvent;

        let from = "FROM";
        let to = "TO";
        let body = RollbarTelemetryNavigationBody(
            fromLocation: from,
            toLocation: to,
            extraData: extra
        );
        
        event = RollbarTelemetryEvent(
            level: level,
            source: source,
            body: body
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, RollbarTelemetryType.navigation);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryNavigationBody);
        for key in extra.keys {
            XCTAssertEqual(event.body.jsonFriendlyData[key] as? String, extra[key]);
        }

        XCTAssertEqual((event.body as! RollbarTelemetryNavigationBody).from, from);
        XCTAssertEqual((event.body as! RollbarTelemetryNavigationBody).to, to);
    }

    func testRollbarTelemetryEventDTO_Network() {
        
        let level: RollbarLevel = .warning;
        let source: RollbarSource = .server;
        let extra = [
            "EXTRA1": "extra_1",
            "EXTRA2": "extra_2",
        ];
        var event: RollbarTelemetryEvent;

        let method: RollbarHttpMethod = .patch;
        let url = "URL";
        let statusCode = "STATUS_CODE";
        let body = RollbarTelemetryNetworkBody(
            method: method,
            url: url,
            statusCode: statusCode,
            extraData: extra
        );
        
        event = RollbarTelemetryEvent(
            level: level,
            source: source,
            body: body
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, RollbarTelemetryType.network);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryNetworkBody);
        for key in extra.keys {
            XCTAssertEqual(event.body.jsonFriendlyData[key] as? String, extra[key]);
        }

        XCTAssertEqual((event.body as! RollbarTelemetryNetworkBody).method, method);
        XCTAssertEqual((event.body as! RollbarTelemetryNetworkBody).url, url);
        XCTAssertEqual((event.body as! RollbarTelemetryNetworkBody).statusCode, statusCode);
    }

    func testRollbarTelemetryEventDTO_Connectivity() {
        
        let level: RollbarLevel = .warning;
        let source: RollbarSource = .server;
        let extra = [
            "EXTRA1": "extra_1",
            "EXTRA2": "extra_2",
        ];
        var event: RollbarTelemetryEvent;

        let status = "STATUS_GOOD";
        let body = RollbarTelemetryConnectivityBody(status: status, extraData: extra);
        
        event = RollbarTelemetryEvent(
            level: level,
            source: source,
            body: body
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, RollbarTelemetryType.connectivity);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryConnectivityBody);
        for key in extra.keys {
            XCTAssertEqual(event.body.jsonFriendlyData[key] as? String, extra[key]);
        }

        XCTAssertEqual((event.body as! RollbarTelemetryConnectivityBody).status, status);
    }

    func testRollbarTelemetryEventDTO_Manual() {
        
        let level: RollbarLevel = .warning;
        let source: RollbarSource = .server;
        let extra = [
            "EXTRA1": "extra_1",
            "EXTRA2": "extra_2",
        ];
        var event: RollbarTelemetryEvent;
        
        let body = RollbarTelemetryManualBody(dictionary: extra);
        
        event = RollbarTelemetryEvent(
            level: level,
            source: source,
            body: body
        );
        XCTAssertEqual(event.level, level);
        XCTAssertEqual(event.source, source);
        XCTAssertEqual(event.type, RollbarTelemetryType.manual);
        XCTAssertNotNil(event.body);
        XCTAssertTrue(event.body is RollbarTelemetryManualBody);
        for key in extra.keys {
            XCTAssertEqual(event.body.jsonFriendlyData[key] as? String, extra[key]);
        }
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(RollbarNotifier().text, "Hello, World!")
//    }

    static var allTests = [
        ("testBasicDTOInitializationWithJSONString", testBasicDTOInitializationWithJSONString),
        ("testRollbarProxyDTO", testRollbarProxyDTO),
        ("testRollbarScrubbingOptionsDTO", testRollbarScrubbingOptionsDTO),
        ("testRollbarServerConfigDTO", testRollbarServerConfigDTO),
        ("testRollbarPersonDTO", testRollbarPersonDTO),
        ("testRollbarModuleDTO", testRollbarModuleDTO),
        ("testRollbarTelemetryOptionsDTO", testRollbarTelemetryOptionsDTO),
        ("testRollbarLoggingOptionsDTO", testRollbarLoggingOptionsDTO),
        ("testRollbarConfigDTO", testRollbarConfigDTO),
        ("testRollbarMessageDTO", testRollbarMessageDTO),
        ("testMessageRollbarBodyDTO", testMessageRollbarBodyDTO),
        ("testCrashReportRollbarBodyDTO", testCrashReportRollbarBodyDTO),
        ("testRollbarJavascriptDTO", testRollbarJavascriptDTO),
        ("testRollbarClientDTO", testRollbarClientDTO),
        ("testRollbarServerDTO", testRollbarServerDTO),
        ("testRollbarRequestDTO", testRollbarRequestDTO),
        ("testRollbarExceptionDTO", testRollbarExceptionDTO),
        ("testRollbarCallStackFrameContextDTO", testRollbarCallStackFrameContextDTO),
        ("testRollbarCallStackFrameDTO", testRollbarCallStackFrameDTO),
        ("testRollbarTraceDTO", testRollbarTraceDTO),
        ("testRollbarTelemetryEventDTO_properBodyBasedOnType", testRollbarTelemetryEventDTO_properBodyBasedOnType),
        ("testRollbarTelemetryEventDTO_Log", testRollbarTelemetryEventDTO_Log),
        ("testRollbarTelemetryEventDTO_View", testRollbarTelemetryEventDTO_View),
        ("testRollbarTelemetryEventDTO_Error", testRollbarTelemetryEventDTO_Error),
        ("testRollbarTelemetryEventDTO_Navigation", testRollbarTelemetryEventDTO_Navigation),
        ("testRollbarTelemetryEventDTO_Network", testRollbarTelemetryEventDTO_Network),
        ("testRollbarTelemetryEventDTO_Connectivity", testRollbarTelemetryEventDTO_Connectivity),
        ("testRollbarTelemetryEventDTO_Manual", testRollbarTelemetryEventDTO_Manual),
    ]
}
