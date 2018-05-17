# ALPHA RELEASE

This library is currently under heavy development, however it should be usable and therefore please
[file an issue](https://github.com/rollbar/rollbar-ios/issues) if you have any problems working with
this library.

# Rollbar for iOS

<!-- RemoveNext -->
Objective-C library for crash reporting and logging with [Rollbar](https://rollbar.com).

## Install

### With [Cocoapods](http://cocoapods.org/)

*NOTE:* The installation via Cocoapods may currently not work due to an incompatiability with C++
libraries and Cocoapods. This is being resolved, but in the meantime installation via the
downloadable Framework below should be the way forward.

In your Podfile:

    pod "Rollbar", "~> 1.0.0-alpha"

Make sure to declare your platform as `ios` at the top of your Podfile. E.g:

    platform :ios, '7.0'

Be sure to remember to `pod install` after changing your Podfile!

### Without Cocoapods

1. Download the [Rollbar framework](https://github.com/rollbar/rollbar-ios/releases/download/v1.0.0-alpha10/Rollbar.zip).

2. Extract the Rollbar directory in the zip file to your Xcode project directory.

3. In Xcode, select _File_ -> _Add Files to "[your project name]"_ and choose the Rollbar directory from step 2.

   Note: if step three doesn't work you can also extract the Rollbar directory anywhere, and drag the `.framework` files into XCode, allowing XCode to correctly configure the Frameworks.

4. Add the libc++ library to your link binary with libraries build phase

5. Ensure that `-ObjC` is in your "Other Linker Flags" setting. Note that the `-all_load` flag is
   not recommended but would also work for this purpose if you already have that set.

## Setup

In your Application delegate implementation file, add the following import statement:

```objc
#import <Rollbar/Rollbar.h>
```

Then add the following to `application:didFinishLaunchingWithOptions:`:

```objc
[Rollbar initWithAccessToken:@"POST_CLIENT_ITEM_ACCESS_TOKEN"];
```

<!-- RemoveNext -->
Replace `POST_CLIENT_ITEM_ACCESS_TOKEN` with a client scope access token from your project in Rollbar

That's all you need to do to report crashes to Rollbar. To get symbolicated stack traces, follow the instructions in the "Symbolication" section below.

### Crash reporting

Crashes will be saved to disk when they occur, then reported to Rollbar the next time the app is launched.

Rollbar uses [KSCrash](https://github.com/kstenerud/KSCrash) to capture uncaught exceptions and fatal signals. Note that only one crash reporter can be active per app. If you initialize multiple crash reporters (i.e. Rollbar alongside other services), only the last one initialized will be active.

### Swift

Importing with Swift requires the additional step of adding the following lines to your Bridging-Header file:

```c
#import <SystemConfiguration/SystemConfiguration.h>
#import <Rollbar/Rollbar.h>
```

If you have no Bridging Header file, the easiest way to correctly configure it is to add an empty objective-c (`dummy.m` for instance) file. When you do so, XCode will prompt you to create a bridging header file, and will configure your build environment to automatically include those headers in all your Swift files. After creating the Bridging-Header file, you can delete the objective-c file.

Note: You do *not* need to import Rollbar if you're using Swift.

The initialization uses Swift syntax:

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    let config: RollbarConfiguration = RollbarConfiguration()
    config.environment = "production"

    Rollbar.initWithAccessToken("POST_CLIENT_ITEM_ACCESS_TOKEN", configuration: config)

    return true
}
```

See the [these commits](https://github.com/Crisfole/SwiftWeather/compare/18580ce...e7d80e1) for a demo of how to integrate Rollbar into an existing Swift project.

### Bitcode

Bitcode is an intermediate representation of a compiled iOS/watchOS program.  Apps you upload to iTunes Connect that contain bitcode will be compiled and linked on the App Store. Including Bitcode will allow Apple to re-optimize your app binary in the future without the need to submit a new version of your app to the store.

Apple will generate new dSYMs for Bitcode enabled builds that have been released to the iTunes store or submitted to TestFlight. You'll need to download the new dSYMs from Xcode and then upload them to Rollbar so that crashes can be symbolicated.

dSYMs for Bitcode enabled apps can be downloaded from Xcode's Organizer. Select the desired Archive of your app and click the "Download dSYMs..." button. If you're unable to download your dSYM from Xcode's Organizer, you'll have to get it from iTunes Connect.

In iTunes Connect, select "My Apps" on the page header and "Activity" on the top navigation tab bar. Select the build you want to download the dSYMs for and click on "Download dSYM" under "Includes Symbols".

Finally, upload the dSYM to Rollbar via your project's dSYM settings page.

### Logging

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


### Migration from older versions for rollbar-ios

Older versions of this library provided logging via methods such as:

```objc
// Logs at level "info".
// Variants at "debug", "info", "warning", "error", and "critical" all exist.
[Rollbar infoWithMessage:@"Test message"];

// Log a critical, with some additional key-value data
[Rollbar criticalWithMessage:@"Unexpected data from server" data:@{@"endpoint": endpoint,
                                                                    @"result": result}];

// Or log at a named level
[Rollbar logWithLevel:@"warning" message:@"Simple warning log message"];
```

This style is still supported but deprecated. It will be removed in a future release. We recommend
upgrade your usage to the style described in the `Logging` section.

## Configuration

You can pass an optional `RollbarConfiguration` object to `initWithAccessToken:`:

```objc
RollbarConfiguration *config = [RollbarConfiguration configuration];
config.crashLevel = @"critical";
config.environment = @"production";

[Rollbar initWithAccessToken:@"POST_CLIENT_ITEM_ACCESS_TOKEN" configuration:config];
```

You can also configure the notifier after initialization by getting the active configuration object and modifying it:

```objc
RollbarConfiguration *config = [Rollbar currentConfiguration];
[config setCheckIgnore:^BOOL(NSDictionary *payload) {
	// Code to determine whether or not to ignore this payload
}];
[config setPersonId:@"123" username:@"username" email:@"test@test.com"];
```

### Configuration reference ###

**CaptureIp specifies the level of IP information to gather about the client along with items.**

```objc
typedef NS_ENUM(NSUInteger, CaptureIpType) {
    CaptureIpFull,
    CaptureIpAnonymize,
    CaptureIpNone
};

- (void)setCaptureIpType:(CaptureIpType)captureIp;
```

*Example*
```objc
[Rollbar.currentConfiguration setCaptureIpType:CaptureIpAnonymize];
```

`CaptureIpFull` is the default behaviour which attempts to capture the IP address on the backend
based on the IP address of the client used to POST the item. `CaptureIpAnonymize` will attempt to
capture the IP address and semi-anonymize it by masking it the least significant bits.
`CaptureIpNone` will turn off attempts to capture the IP address.


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

## Telemetry

The following methods exist on the `Rollbar` class for working with telemetry data:

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

The `RollbarTelemetry` class also exists with an exposed shared instance for working with telemetry data at a finer level of detail.

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

## Symbolication using .dSYM files

To automatically send .dSYM files to Rollbar whenever your app is built in release mode, add a new build phase to your target in Xcode:

1. Click on your project and then select "Build Phases"

2. In the top menu bar, click "Editor" and then "Add Build Phase", then "Add Run Script Build Phase"

3. Change the "Shell" to `/usr/bin/python`

4. Paste the contents of the [upload_dsym.py](https://raw.githubusercontent.com/rollbar/rollbar-ios/master/upload_dsym.py) script into the box, using "Paste and Preserve Formatting" (Edit -> Paste and Preserve Formatting)

  Note: make sure you replace `POST_SERVER_ITEM_ACCESS_TOKEN` with a server scope access token from your project in Rollbar.


## Enabling on-device symbolication (From KSCrash)

---

On-device symbolication requires basic symbols to be present in the final build. To enable this, go to your app's build settings and set Strip Style to Debugging Symbols. Doing so increases your final binary size by about 5%, but you get on-device symbolication.

## Developing and building the library ##

You can include the Rollbar project as a sub-project in your app, or link the Rollbar source files directly into your app.
To develop the library by linking the source files directly in your app:

1. Fork this repo
2. git clone your fork
3. In Xcode, remove the Rollbar files from your project if they are currently there
4. Pull the KSCrash submodule:
```
git submodule init
git submodule update
```
5. In Xcode, add the Rollbar/ files:
    1. Right-click your project
    2. Click "Add Files to <project name>"
    3. Navigate to your rollbar-ios clone and select the Rollbar folder
    4. Click "Add"

You should now be able to build your app with your local clone of rollbar-ios.

To build the Rollbar framework distribution files, open the Rollbar project and make sure the Distribution scheme is active by selecting _Editor_ -> _Scheme_ -> _Distribution_. Building the project with this scheme selected will create a `Dist/` directory containing the Rollbar framework with the proper fat binary.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Help / Support

If you run into any problems, please email us at `support@rollbar.com` or [file a bug report](https://github.com/rollbar/rollbar-ios/issues/new).
