# Rollbar for iOS

<!-- RemoveNext -->
Objective-C library for crash reporting and logging with [Rollbar](https://rollbar.com).

## Install

### With [Cocoapods](http://cocoapods.org/)

In your Podfile:

    pod "Rollbar", "~> 0.2.0"

Make sure to declare your platform as `ios` at the top of your Podfile. E.g:

    platform :ios, '7.0'

Be sure to remember to `pod install` after changing your Podfile!

### Without Cocoapods

1. Download the [Rollbar framework](https://github.com/rollbar/rollbar-ios/releases/download/v0.2.0/Rollbar.zip).

2. Extract the Rollbar directory in the zip file to your Xcode project directory.

3. In Xcode, select _File_ -> _Add Files to "[your project name]"_ and choose the Rollbar directory from step 2.

Note: if step three doesn't work you can also extract the Rollbar directory anywhere, and drag the `.framework` files into XCode, allowing XCode to correctly configure the Frameworks.

## Setup

In your Application delegate implementation file, add the following import statement:

```objective-c
#import <Rollbar/Rollbar.h>
```

Then add the following to `application:didFinishLaunchingWithOptions:`:

```objective-c
[Rollbar initWithAccessToken:@"POST_CLIENT_ITEM_ACCESS_TOKEN"];
```

<!-- RemoveNext -->
Replace `POST_CLIENT_ITEM_ACCESS_TOKEN` with a client scope access token from your project in Rollbar

That's all you need to do to report crashes to Rollbar. To get symbolicated stack traces, follow the instructions in the "Symbolication" section below.

### Crash reporting

Crashes will be saved to disk when they occur, then reported to Rollbar the next time the app is launched.

Rollbar uses [PLCrashReporter](https://www.plcrashreporter.org/) to capture uncaught exceptions and fatal signals. Note that only one crash reporter can be active per app. If you initialize multiple crash reporters (i.e. Rollbar alongside other services), only the last one initialized will be active.

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

    Rollbar.initWithAccessToken("YOUR ACCESS TOKEN", configuration: config)

    return true
}
```

See the [these commits](https://github.com/Crisfole/SwiftWeather/compare/18580ce...e7d80e1) for a demo of how to integrate Rollbar into an existing Swift project.

### Bitcode

Bitcode is an intermediate representation of a compiled iOS/watchOS program.  Apps you upload to iTunes Connect that contain bitcode will be compiled and linked on the App Store. Including bitcode will allow Apple to re-optimize your app binary in the future without the need to submit a new version of your app to the store.

PLCrashReporter does not yet support symbolicating apps built with bitcode. Until a version of PLCrashReporter is available that supports symbolication with bitcode enabled, you'll need to disable bitcode in your project for Rollbar to be able to symbolicate your crash reports.

### Logging

You can log arbitrary messages using the log methods:

```objective-c
// Logs at level "info".
// Variants at "debug", "info", "warning", "error", and "critical" all exist.
[Rollbar infoWithMessage:@"Test message"];

// Log a critical, with some additional key-value data
[Rollbar criticalWithMessage:@"Unexpected data from server" data:@{@"endpoint": endpoint,
                                                                    @"result": result}];

// Or log at a named level
[Rollbar logWithLevel:@"warning" message:@"Simple warning log message"];
```

## Configuration

You can pass an optional `RollbarConfiguration` object to `initWithAccessToken:`:

```objective-c
RollbarConfiguration *config = [RollbarConfiguration configuration];
config.crashLevel = @"critical";
config.environment = @"production";

[Rollbar initWithAccessToken:@"POST_CLIENT_ITEM_ACCESS_TOKEN" configuration:config];
```

You can also configure the notifier after initialization by getting the active configuration object and modifying it:

```objective-c
RollbarConfiguration *config = [Rollbar currentConfiguration];
[config setPersonId:@"123" username:@"username" email:@"test@test.com"];

// Will now report with person data
[Rollbar debugWithMessage:@"User hit button A"];
```

### Configuration reference ###

**Properties:**
  <dl>
  <dt>crashLevel</dt>
  <dd>The level that crashes are reported as

Default: ```error```
  </dd>

  <dt>environment</dt>
  <dd>Environment that Rollbar items will be reported under

Default: ```unspecified``` in release mode, ```development``` in debug mode.
  </dd>
  <dt>endpoint</dt>
  <dd>URL items are posted to.

Default: ```https://api.rollbar.com/api/1/items/```
  </dd>
  </dl>

**Methods:**
  <dl>
  <dt>`- setPersonId:username:email:`</dt>
  <dd>Sets person data. Each value can either be a `NSString` or `nil`
  </dd>
  </dl>

## Symbolication using .dSYM files

To automatically send .dSYM files to Rollbar whenever your app is built in release mode, add a new build phase to your target in Xcode:

1. Click on your project and then select "Build Phases"

2. In the top menu bar, click "Editor" and then "Add Build Phase", then "Add Run Script Build Phase"

3. Change the "Shell" to `/usr/bin/python`

4. Paste the contents of the [upload_dsym.py](upload_dsym.py) script into the box, using "Paste and Preserve Formatting" (Edit -> Paste and Preserve Formatting)

  Note: make sure you replace `POST_SERVER_ITEM_ACCESS_TOKEN` with a server scope access token from your project in Rollbar.

## Developing and building the library ##

You can include the Rollbar project as a sub-project in your app, or link the Rollbar source files directly into your app.
To develop the library by linking the source files directly in your app:

1. Fork this repo
2. git clone your fork
3. In Xcode, remove the Rollbar files from your project if they are currently there
4. In Xcode, add the Rollbar/ files:
    1. Right-click your project
    2. Click "Add Files to <project name>"
    3. Navigate to your rollbar-ios clone and select the Rollbar folder
    4. Click "Add"
5. In Xcode, add the PLCrashReporter framework:
    1. Click your project
    2. Click the General settings tab
    3. Under "Linked Frameworks and Libraries", click the +
    4. Click "Add Other..."
    5. Navigate to your rollbar-ios clone, then Vendor/
    6. Select CrashReporter.framework and click "Open"

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
