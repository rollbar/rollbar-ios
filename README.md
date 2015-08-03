# Rollbar for iOS

<!-- RemoveNext -->
Objective-C library for crash reporting and logging with [Rollbar](https://rollbar.com).

## Install

### With [Cocoapods](http://cocoapods.org/)

In your Podfile:

    pod "Rollbar", "~> 0.1.5"

Make sure to declare your platform as `ios` at the top of your Podfile. E.g:

    platform :ios, '7.0'

### Without Cocoapods

1. Download the [Rollbar framework](https://github.com/rollbar/rollbar-ios/releases/download/v0.1.5/Rollbar.zip).

2. Extract the Rollbar directory in the zip file to your Xcode project directory.

3. In Xcode, select _File_ -> _Add Files to "[your project name]"_ and choose the Rollbar directory from step 2.

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

### Logging

You can log arbitrary messages using the log methods:

```objective-c
// Logs at level "info".
// Variants at "debug", "info", "warning", "error", and "critical" all exist.
[Rollbar infoWithMessage:@"Test message"];

// Log a critical, with some additional key-value data
[Rollbar criticalWithMessage:@"Unexcpected data from server" data:@{@"endpoint": endpoint,
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

4. Paste the following script into the box, using "Paste and Preserve Formatting" (Edit -> Paste and Preserve Formatting):

```python
import os
import subprocess
import zipfile

if os.environ['DEBUG_INFORMATION_FORMAT'] != 'dwarf-with-dsym' or os.environ['EFFECTIVE_PLATFORM_NAME'] == '-iphonesimulator':
    exit(0)

ACCESS_TOKEN = 'POST_SERVER_ITEM_ACCESS_TOKEN'

dsym_file_path = os.path.join(os.environ['DWARF_DSYM_FOLDER_PATH'], os.environ['DWARF_DSYM_FILE_NAME'])
zip_location = '%s.zip' % (dsym_file_path)

os.chdir(os.environ['DWARF_DSYM_FOLDER_PATH'])
with zipfile.ZipFile(zip_location, 'w') as zipf:
    for root, dirs, files in os.walk(os.environ['DWARF_DSYM_FILE_NAME']):
        zipf.write(root)

        for f in files:
            zipf.write(os.path.join(root, f))

info_file_path = os.path.join(os.environ['INSTALL_DIR'], os.environ['INFOPLIST_PATH'])
p = subprocess.Popen('/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" -c "Print :CFBundleIdentifier" "%s"' % info_file_path,
                     stdout=subprocess.PIPE, shell=True)

stdout, stderr = p.communicate()
version, identifier = stdout.split()

p = subprocess.Popen('curl -X POST "https://api.rollbar.com/api/1/dsym" -F access_token=%s -F version=%s -F bundle_identifier="%s" -F dsym=@"%s"' 
                     % (ACCESS_TOKEN, version, identifier, zip_location), shell=True)
p.communicate()
```

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
