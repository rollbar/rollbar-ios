Install Carthage dependencies manager from: https://github.com/Carthage/Carthage/releases by downloading one of the latest available Carthage.pkg installers.

Create Cartfile side-by-side with the application project/workspace file.


Add following dependency to the Cartfile:

`github "rollbar/rollbar-ios" # GitHub.com`

Open the Terminal from the application codebase root (where the application project/workspace file is located) and run following command:

`carthage update`

Observe the command execution fetching the Rollbar-iOS repo at the latest available release check-point, building a few available Rollbar-iOS schemes.
Cartfile.resolved file and a Carthage directory will appear in the same directory where your .xcodeproj or .xcworkspace is.

On your application targets’ General settings tab, in the “Frameworks, Libraries, and Embedded Content” section, drag and drop each framework you want to use (Rollbar.framework) from the Carthage/Build folder on disk.

On your application targets’ Build Phases settings tab, click the + icon and choose New Run Script Phase. Create a Run Script in which you specify your shell (ex: /bin/sh), add the following contents to the script area below the shell:
`/usr/local/bin/carthage copy-frameworks`

In the capplication codebase root, create input.xcfilelist file and add the paths to the frameworks you want to use, i.e.:
`$(SRCROOT)/Carthage/Build/iOS/Rollbar.framework`

In the capplication codebase root, create output.xcfilelist file and add the paths to the copied frameworks, i.e.:
`$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/Rollbar.framework`

With output files specified alongside the input files, Xcode only needs to run the script when the input files have changed or the output files are missing. This means dirty builds will be faster when you haven't rebuilt frameworks with Carthage.


Open AppDelegate.m for editing and following imports at the top of the file:

```
#import <Rollbar/Rollbar.h>
#import <Rollbar/RollbarConfiguration.h>

Also, add following Rollbar configuration, initialization, and verfication code:

```
    // configure Rollbar:
    RollbarConfiguration *config = [RollbarConfiguration configuration];
    config.environment = @"samples";
    // initialize Rollbar:
    [Rollbar initWithAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3" configuration:config];
    // first test
    [Rollbar info:@"iOSAppWithRollbarViaCarthage_Objective-C: the app just launched. Life is good..."];

    // one more test:
    [Rollbar log:RollbarInfo
         message:@"Test message"
       exception:nil
            data:@{@"ExtraData1":@"extra value 1", @"ExtraData2":@"extra value 2"}
         context:@"extra context"];

into the implementation of 
`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`    

Build and run your application.
Verify that the two log messages above are showing up in the Rollbar Dashboard.

Enjoy better development experience with the help of Rollbar!

