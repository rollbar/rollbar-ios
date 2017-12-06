# Rollbar iOS SDK Documentation


## Usage

```objc
[Rollbar initWithAccessToken:@"access_token" configuration:nil enableCrashReporter:true];

// Configuration customizations

[Rollbar.currentConfiguration setCheckIgnore:^BOOL(NSDictionary *payload) {
	// Code to determine whether or not to ignore this payload
}];
```


## Classes

### Rollbar

---

**Log a message with the specified Rollbar level.**

```objc
+ (void)log:(RollbarLevel)level message:(NSString*)message;
```

*Example*

```objc
[Rollbar log:RollbarDebug message:@"Message"];
```

---

**Log a message and exception with the specified Rollbar level.**

```objc
+ (void)log:(RollbarLevel)level message:(NSString*)message exception:(NSException*)exception;
```

*Example*

```objc
@try {
	// Code that might generate error
} @catch (NSException *e) {
	[Rollbar log:RollbarDebug message:e.reason exception:nil];
    // Or
	[Rollbar log:RollbarDebug message:nil exception:e];
}
```

---

**Log a message, exception, and extra data with the specified Rollbar level.**

```objc
+ (void)log:(RollbarLevel)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
```

*Example*

```objc
[Rollbar log:RollbarDebug message:@"Message" exception:nil data:@{@"extra_data": @"content"}];
```

---

**Log a message, exception, extra data, and context with the specified Rollbar level.**

```objc
+ (void)log:(RollbarLevel)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;
```

*Example*

```objc
[Rollbar log:RollbarDebug message:@"Message" exception:nil data:@{@"extra_data": @"content"} context:@"Context"];
```

---

**Log a debug level message.**

```objc
+ (void)debug:(NSString*)message;
```

*Example*

```objc
[Rollbar debug:@"Message"];
```

---

**Log a debug level message with exception.**

```objc
+ (void)debug:(NSString*)message exception:(NSException*)exception;
```

*Example*

```objc
@try {
	// Code that might generate error
} @catch (NSException *e) {
	[Rollbar debug:e.reason exception:nil];
    // Or
	[Rollbar debug:nil exception:e];
}
```

---

**Log a debug level message with exception and extra data.**

```objc
+ (void)debug:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
```

*Example*

```objc
[Rollbar debug:@"Message" exception:nil data:@{@"extra_data": @"content"}];
```

---

**Log a debug level message with exception, extra data, and context.**

```objc
+ (void)debug:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;
```

*Example*

```objc
[Rollbar debug:@"Message" exception:nil data:@{@"extra_data": @"content"} context:@"Context"];
```

---

**Log an info level message.**

```objc
+ (void)info:(NSString*)message;
```

*Example*

```objc
[Rollbar info:@"Message"];
```

---

**Log an info level message with exception.**

```objc
+ (void)info:(NSString*)message exception:(NSException*)exception;
```

*Example*

```objc
[Rollbar info:@"Message" exception:nil];
```

---

**Log an info level message with exception and extra data.**

```objc
+ (void)info:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
```

*Example*

```objc
[Rollbar info:@"Message" exception:nil data:@{@"extra_data": @"content"}];
```

---

**Log an info level message with exception, extra data, and context.**

```objc
+ (void)info:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;
```

*Example*

```objc
[Rollbar info:@"Message" exception:nil data:@{@"extra_data": @"content"} context:@"Context"];
```

---

**Log a warning level message.**

```objc
+ (void)warning:(NSString*)message;
```

*Example*

```objc
[Rollbar warning:@"Message"];
```

---

**Log a warning level message with exception.**

```objc
+ (void)warning:(NSString*)message exception:(NSException*)exception;
```

*Example*

```objc
[Rollbar warning:@"Message" exception:nil];
```

---

**Log a warning level message with exception and extra data.**

```objc
+ (void)warning:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
```

*Example*

```objc
[Rollbar warning:@"Message" exception:nil data:@{@"extra_data": @"content"}];
```

---

**Log a warning level message with exception, extra data, and context.**

```objc
+ (void)warning:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;
```

*Example*

```objc
[Rollbar warning:@"Message" exception:nil data:@{@"extra_data": @"content"} context:@"Context"];
```

---

**Log a error level message.**

```objc
+ (void)error:(NSString*)message;
```

*Example*

```objc
[Rollbar error:@"Message"];
```

---

**Log a error level message with exception.**

```objc
+ (void)error:(NSString*)message exception:(NSException*)exception;
```

*Example*

```objc
[Rollbar error:@"Message" exception:nil];
```

---

**Log a error level message with exception and extra data.**

```objc
+ (void)error:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
```

*Example*

```objc
[Rollbar error:@"Message" exception:nil data:@{@"extra_data": @"content"}];
```

---

**Log a error level message with exception, extra data, and context.**

```objc
+ (void)error:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;
```

*Example*

```objc
[Rollbar error:@"Message" exception:nil data:@{@"extra_data": @"content"} context:@"Context"];
```

---

**Log a critical level message.**

```objc
+ (void)critical:(NSString*)message;
```

*Example*

```objc
[Rollbar critical:@"Message"];
```

---

**Log a critical level message with exception.**

```objc
+ (void)critical:(NSString*)message exception:(NSException*)exception;
```

*Example*

```objc
[Rollbar critical:@"Message" exception:nil];
```

---

**Log a critical level message with exception and extra data.**

```objc
+ (void)critical:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
```

*Example*

```objc
[Rollbar critical:@"Message" exception:nil data:@{@"extra_data": @"content"}];
```

---

**Log a critical level message with exception, extra data, and context.**

```objc
+ (void)critical:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;
```

*Example*

```objc
[Rollbar critical:@"Message" exception:nil data:@{@"extra_data": @"content"} context:@"Context"];
```

_Note: If message and exception both exist, it'll be combined into a single message with exception.callStackSymbols. If only exception exists, exception.callStackSymbols will be parsed._

<br />

---

**Record view telemetry event with element.**

```objc
+ (void)recordViewEventForLevel:(RollbarLevel)level element:(NSString *)element;
```

*Example*

```objc
[Rollbar recordViewEventForLevel:RollbarDebug element:@"HomeView"];
```

---

**Record view telemetry event with element and extra data.**

```objc
+ (void)recordViewEventForLevel:(RollbarLevel)level element:(NSString *)element extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[Rollbar recordViewEventForLevel:RollbarDebug element:@"HomeView" extraData:@{@"key":@"content"}];
```

---

**Record network telemetry event with method, url, and status code.**

```objc
+ (void)recordNetworkEventForLevel:(RollbarLevel)level method:(NSString *)method url:(NSString *)url statusCode:(NSString *)statusCode;
```

*Example*

```objc
[Rollbar recordNetworkEventForLevel:RollbarDebug method:@"GET" url:@"http://rollbar.com/test/api" statusCode:@"404"];
```

---

**Record network telemetry event with method, url, status code and extra data.**

```objc
+ (void)recordNetworkEventForLevel:(RollbarLevel)level method:(NSString *)method url:(NSString *)url statusCode:(NSString *)statusCode extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[Rollbar recordNetworkEventForLevel:RollbarDebug method:@"GET" url:@"http://rollbar.com/test/api" statusCode:@"404" extraData:@{@"key":@"content"}];
```

---

**Record connectivity telemetry event with status.**

```objc
+ (void)recordConnectivityEventForLevel:(RollbarLevel)level status:(NSString *)status;
```

*Example*

```objc
[Rollbar recordConnectivityEventForLevel:RollbarDebug status:@"Disconnected"];
```

---

**Record connectivity telemetry event with status and extra data.**

```objc
+ (void)recordConnectivityEventForLevel:(RollbarLevel)level status:(NSString *)status extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[Rollbar recordConnectivityEventForLevel:RollbarDebug status:@"Disconnected" extraData:@{@"key":@"content"}];
```

---

**Record error telemetry event with message.**

```objc
+ (void)recordErrorEventForLevel:(RollbarLevel)level message:(NSString *)message;
```

*Example*

```objc
[Rollbar recordErrorEventForLevel:RollbarError message:@"Message"];
```

---

**Record error telemetry event with exception.**

```objc
+ (void)recordErrorEventForLevel:(RollbarLevel)level exception:(NSException *)exception;
```

*Example*

```objc
@try {
	// Code with error
} @catch (NSException *e) {
	[Rollbar recordErrorEventForLevel:RollbarError exception:e];
}
```

---

**Record error telemetry event with message and extra data.**

```objc
+ (void)recordErrorEventForLevel:(RollbarLevel)level message:(NSString *)message extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[Rollbar recordErrorEventForLevel:RollbarError message:@"Message" extraData:@{@"key":@"content"}];
```

---

**Record navigation telemetry event with from (origin) and to (destination).**

```objc
+ (void)recordNavigationEventForLevel:(RollbarLevel)level from:(NSString *)from to:(NSString *)to;
```

*Example*

```objc
[Rollbar recordNavigationEventForLevel:RollbarDebug from:@"HomeView" to:@"SettingView"];
```

---

**Record navigation telemetry event with from (origin), to (destination), and extra data.**

```objc
+ (void)recordNavigationEventForLevel:(RollbarLevel)level from:(NSString *)from to:(NSString *)to extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[Rollbar recordNavigationEventForLevel:RollbarDebug from:@"HomeView" to:@"SettingView" extraData:@{@"key":@"content"}];
```

---

**Record manual telemetry event with data. Manual telemetry event is for user defined telemetry events.**

```objc
+ (void)recordManualEventForLevel:(RollbarLevel)level withData:(NSDictionary *)extraData;
```

*Example*

```objc
[Rollbar recordManualEventForLevel:RollbarDebug withData:@{@"key":@"content"}];
```

---

<br />
<br />

### RollbarConfiguration

---

**Sets the maximum number of telemetry data entry to keep. Default is 10.**

```objc
- (void)setMaximumTelemetryData:(NSInteger)maximumTelemetryData;
```

*Example*

```objc
[Rollbar.currentConfiguration setMaximumTelemetryData:5];
```

---

**Sets the ID, username, and email of the current user.**

```objc
- (void)setPersonId:(NSString*)personId username:(NSString*)username email:(NSString*)email;
```

*Example*

```objc
[Rollbar.currentConfiguration setPersonId:@"user-id" username:@"user_name" email:@"user@email.com"];
```

---

**Sets the server information, including host, root, code branch, and code version.**

```objc
- (void)setServerHost:(NSString *)host root:(NSString*)root branch:(NSString*)branch codeVersion:(NSString*)codeVersion;
```

*Example*

```objc
[Rollbar.currentConfiguration setServerHost:@"host" root:@"root" branch:@"code-branch" codeVersion@"0.1"];
```

---

**Sets a payload modification function block. This will be called with the intended payload as the parameter. It can be used to modify the payload before sending it to the Rollbar server.**

```objc
- (void)setPayloadModificationBlock:(void (^)(NSMutableDictionary*))payloadModificationBlock;
```

*Example*

```objc
[Rollbar.currentConfiguration setPayloadModification:^(NSMutableDictionary *payload) {
	[payload setValue:@"new-value" forKeyPath:@"body.message.body"];
}];
```

---

**Sets a check ignore function block. This will be called with the intended payload as the parameter. It is used to determine whether or not it should send the payload to server. Return true to ignore (will not send) the payload and false to send.**

```objc
- (void)setCheckIgnoreBlock:(BOOL (^)(NSDictionary*))checkIgnoreBlock;
```

*Example*

```objc
[Rollbar.currentConfiguration setCheckIgnore:^BOOL(NSDictionary *payload) {
	// Return true to ignore payload, false to send.
}];
```

---

**Add a field with sensitive data to scrub from the payload. Field is in the format of a key path in the NSDictionary. (e.g. "body.message.body").**

```objc
- (void)addScrubField:(NSString *)field;
```

*Example*

```objc
[Rollbar.currentConfiguration addScrubField:@"body.user.phone"];
```
---

**Remove a field from the scrub list. Field is in the format of a key path in the NSDictionary. (e.g. "body.message.body").**

```objc
- (void)removeScrubField:(NSString *)field;
```

*Example*

```objc
[Rollbar.currentConfiguration removeScrubField:@"body.user.phone"];
```

---

**Set a request ID. This is used for linking client notifications with server calls.**

```objc
- (void)setRequestId:(NSString*)requestId;
```

*Example*

```objc
[Rollbar.currentConfiguration setRequestId:@"reques-8293489324723"];
```

---

**Determines if Rollbar should capture NSLog automatically as telemetry data. Number of entries to capture depends on "setMaximumTelemetryData".**

```objc
- (void)setCaptureLogAsTelemetryData:(BOOL)captureLog;
```

*Example*

```objc
[Rollbar.currentConfiguration setCaptureLogAsTelemetryData:true];
```

---

**Determines if Rollbar should capture connectivity change event automatically as telemetry data. Connectivity change event includes disconnecting from the Internet and reconnected to the Internet from an offline state. Number of entries to capture depends on "setMaximumTelemetryData".**

```objc
- (void)setCaptureConnectivityAsTelemetryData:(BOOL)captureConnectivity;
```

*Example*

```objc
[Rollbar.currentConfiguration setCaptureConnectivityAsTelemetryData:true];
```

---

<br />
<br />

### RollbarTelemetry

---

**Set whether or not it should capture NSLog entries automatically.**

```objc
- (void)setCaptureLog:(BOOL)shouldCapture;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] setCaptureLog:true];
```

---

**Set the number of telemetry data entries to keep.**

```objc
- (void)setDataLimit:(NSInteger)dataLimit;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] setDataLimit:15];
```

---

**Record a telemetry event with the specified Rollbar level and telemetry data type.**

```objc
- (void)recordEventForLevel:(RollbarLevel)level type:(RollbarTelemetryType)type data:(NSDictionary *)data;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] recordEventForLevel:RollbarInfo type:RollbarTelemetry data:@{@"key": @"content"}];
```

---

**Record a view telemetry event with the specified Rollbar level, element, and data.**

```objc
- (void)recordViewEventForLevel:(RollbarLevel)level element:(NSString *)element extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] recordViewEventForLevel:RollbarInfo element:@"HomeView" extraData:@{@"key": @"content"}];
```

---

**Record a network telemetry event with the specified Rollbar level, method, url, status code, and data.**

```objc
- (void)recordNetworkEventForLevel:(RollbarLevel)level method:(NSString *)method url:(NSString *)url statusCode:(NSString *)statusCode extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] recordNetworkEventForLevel:RollbarInfo method:@"POST" url:@"http://rollbar.com/test/api" statusCode:@"404" extraData:nil];
```

---

**Record a connectivity telemetry event with the specified Rollbar level, status, and data.**

```objc
- (void)recordConnectivityEventForLevel:(RollbarLevel)level status:(NSString *)status extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] recordConnectivityEventForLevel:RollbarInfo status:@"Connected" extraData:nil];
```

---

**Record a error telemetry event with the specified Rollbar level, message, and data.**

```objc
- (void)recordErrorEventForLevel:(RollbarLevel)level message:(NSString *)message extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] recordErrorEventForLevel:RollbarError message:@"Error message" extraData:nil];
```

---

**Record a navigation telemetry event with the specified Rollbar level, from (origin), to (destination) and data.**

```objc
- (void)recordNavigationEventForLevel:(RollbarLevel)level from:(NSString *)from to:(NSString *)to extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] recordNavigationEventForLevel:RollbarInfo from:@"SettingView" to:@"HomeView" extraData:nil];
```

---

**Record a manual telemetry event with the specified Rollbar level and data**

```objc
- (void)recordManualEventForLevel:(RollbarLevel)level withData:(NSDictionary *)extraData;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] recordManualEventForLevel:RollbarInfo withData:@{@"custom_data":@"content"}];
```

---

**Record a log telemetry event with the specified Rollbar level and data.**

```objc
- (void)recordLogEventForLevel:(RollbarLevel)level message:(NSString *)message extraData:(NSDictionary *)extraData;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] recordLogEventForLevel:RollbarInfo message:@"Log message"extraData:nil];
```

---

**Get all telemetry data currently recorded. These are the data that will be sent along with each notification.**

```objc
- (NSArray *)getAllData;
```

*Example*

```objc
NSArray *allTelemetryData = [[RollbarTelemetry sharedInstance] getAllData];

// Print all telemetry data
for (id item in allTelemetryData) {
	NSLog(@"%@", item);
}
```

---

**Clear all the telemetry data recorded.**

```objc
- (void)clearAllData;
```

*Example*

```objc
[[RollbarTelemetry sharedInstance] clearAllData];
```

---

<br />
<br />

### Enabling on-device symbolication (From SKCrash)

---

On-device symbolication requires basic symbols to be present in the final build. To enable this, go to your app's build settings and set Strip Style to Debugging Symbols. Doing so increases your final binary size by about 5%, but you get on-device symbolication.