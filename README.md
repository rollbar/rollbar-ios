# Rollbar for iOS

<!-- RemoveNext -->
Objective-C library for reporting exceptions, errors, and log messages to [Rollbar](https://rollbar.com).

## Setup ##

1. Download the [Rollbar framework](https://github.com/rollbar/rollbar-ios/releases/download/v0.0.1/Rollbar.zip).

2. Extract the Rollbar directory in the zip file to your Xcode project directory.

3. In Xcode, select _File_ -> _Add Files to "[your project name]"_ and choose the Rollbar directory from step 2.

4. In your Application delegate implementation file, add the following import statement:

  ```objective-c
  #import <Rollbar/Rollbar.h>
  ```

5. Add the following to `application:didFinishLaunchingWithOptions:`:

  ```objective-c
  [Rollbar initWithAccessToken:@"POST_CLIENT_ITEM_ACCESS_TOKEN"];
  ```

<!-- RemoveNext -->
Replace `POST_CLIENT_ITEM_ACCESS_TOKEN` with a client scope access token from your project in Rollbar


## Usage ##

Rollbar uses [PLCrashReporter](https://www.plcrashreporter.org/) to capture uncaught exceptions and fatal signals. Only one crash reporter can be active per app, so make sure to only use Rollbar for crash reporting, or at least have Rollbar be the the last crash reporter initialized in your app delegate.

Crashes will be saved to disk when they occur, then reported to Rollbar the next time the app is launched.

You can report messages by using one of the log methods:

```objective-c
[Rollbar infoWithMessage:@"Test message"];

[Rollbar criticalWithMessage:@"Unexcpected data from server" data:@{@"endpoint": endpoint,
                                                                    @"result": result}];

[Rollbar logWithLevel:@"warning" message:@"Simple warning log message"];
```


## Configuration ##

You can pass an optional `RollbarConfiguration` object to `initWithAccessToken:`:

```objective-c
RollbarConfiguration *config = [RollbarConfiguration configuration];
// set configuration options...
config.crashLevel = @"critical";

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

**Variables:**

  <dl>
  <dt>environment</dt>
  <dd>Environment that Rollbar items will be reported under

Default: ```unspecified``` in release mode, ```development``` in debug mode
  </dd>
  <dt>endpoint</dt>
  <dd>URL items are posted to

Default: ```https://api.rollbar.com/api/1/items/```

  </dd>
  <dt>crashLevel</dt>
  <dd>The level that crashes are reported as

Default: ```error```
  </dd>

**Methods:**

  <dt>`- setPersonId:username:email:`</dt>
  <dd>Sets person data. Each value can either be a `NSString` or `nil`
  </dd>
  </dl>

## Symbolication using .dSYM files

To automatically send .dSYM files to Rollbar whenever your app is built in release mode, add a new build phase to your target in Xcode:

1. Click on your project and then select "Build Phases"

2. In Xcode's menu select _Editor_ -> _Add Build Phase_ -> _Add Run Script Build Phase_

3. Change the script's shell to `/usr/bin/python`

4. Select the script box, copy the following script, and in Xcode select _Edit_ -> _Paste and Preserve Formatting_:

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

  Note: make sure you replace `POST_SERVER_ITEM_ACCESS_TOKEN` with a server scope access token from your project in Rollbar.


## Developing and building the library ##

You can include the Rollbar project as a sub-project in your app, or link the Rollbar source files directly into your app.

To build the Rollbar framework distribution files, open the Rollbar project and make sure the Distribution scheme is active by selecting _Editor_ -> _Scheme_ -> _Distribution_. Building the project with this scheme selected will create a `Dist/` directory containing the Rollbar framework with the proper fat binary.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Help / Support

If you run into any issues, please email us at `support@rollbar.com`
