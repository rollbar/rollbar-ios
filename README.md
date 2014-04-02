# Rollbar for iOS

<!-- RemoveNext -->
Objective-C library for crash reporting and logging with [Rollbar](https://rollbar.com).

## Setup

1. Download the [Rollbar framework](https://github.com/rollbar/rollbar-ios/releases/download/v0.0.1/Rollbar.zip)

2. Extract the Rollbar directory in the zip file to your Xcode project directory.

3. In Xcode, select File -> Add Files to "[your project name]" and choose the Rollbar folder

4. In your Application delegate implementation file, add the following import statement:

    ```objective-c
    #import <Rollbar/Rollbar.h>
    ```

5. Add the following to `application:didFinishLaunchingWithOptions:`:

    ```objective-c
    [Rollbar initWithAccessToken:@"POST_CLIENT_ITEM_ACCESS_TOKEN"];
    ```

    <!-- RemoveNext -->
    Replace POST_CLIENT_ITEM_ACCESS_TOKEN with a client scope access token from your project in Rollbar.

That's all you need to do to report crashes to Rollbar. To get symbolicated stack traces, follow the instructions in the "Symbolication" section below.

## Usage

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

### Configuration reference ###

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

p = subprocess.Popen('/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" %s' % os.environ['PRODUCT_SETTINGS_PATH'],
                     stdout=subprocess.PIPE, shell=True)
stdout, stderr = p.communicate()
version = stdout.strip()

p = subprocess.Popen('curl -X POST https://api.rollbar.com/api/1/dsym -F access_token=%s -F version=%s -F dsym=@%s' % (ACCESS_TOKEN, version, zip_location), shell=True)
p.communicate()
```

Note: make sure you replace POST_SERVER_ITEM_ACCESS_TOKEN with a server scope access token from your project in Rollbar.


## Help / Support

If you run into any problems, please email us at `support@rollbar.com` or [file a bug report](https://github.com/rollbar/rollbar-ios/issues/new).



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


