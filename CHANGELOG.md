# Change Log

**0.2.0**
- Changes to better support bitcode in apps, ([pr#29](https://github.com/rollbar/rollbar-ios/pull/29)).
  - Add a version of PLCrashReporter compiled with bitcode support and a Rollbar prefix
  - Add bitcode support to rollbar-ios
- Update dSYM upload script, ([pr#30](https://github.com/rollbar/rollbar-ios/pull/30))
- Add framework target for Carthage compatibility, ([pr#25](https://github.com/rollbar/rollbar-ios/pull/25))

**0.1.6**
- Handle localized bundle names, ([pr#24](https://github.com/rollbar/rollbar-ios/pull/24)).

**0.1.5**
- Fix compiler error when included in a Swift application, ([pr#16](https://github.com/rollbar/rollbar-ios/pull/16)).

**0.1.4**
- Fix crash where a `nil` message was passed to `buildPayloadBodyWithMessage`, ([pr#15](https://github.com/rollbar/rollbar-ios/pull/15)).

**0.1.3**
- Optionally enable/disable uncaught exception reporting, ([pr#8](https://github.com/rollbar/rollbar-ios/pull/8)).
- Added ability to send custom data along with errors/log messages, ([pr#9](https://github.com/rollbar/rollbar-ios/pull/9)).

**0.1.2**
- Rename reachability constant to fix linker error if you use [https://github.com/tonymillion/Reachability](https://github.com/tonymillion/Reachability) in your app.

**0.1.1**
- Fixed bug that would cause a crash on load if the internal file state somehow became corrupted.

**0.1.0**
- Added internet reachability monitoring so that items aren't attempted to be sent while the phone is not connected to the network.
- Removed log messages from release mode.

**0.0.4**
- Include bundle identifier in item payloads. This will be required for the symbolication process going forward, please update your dsym upload build phase script to the latest version seen [here](https://github.com/rollbar/rollbar-ios/tree/v0.0.4/upload_dsym.py).

**0.0.3**
- Configuration is now persisted so that crashes are reported with the proper person data on startup.
- New item saving and batching system with retries. Items are saved to disk first, while a separate thread monitors the disk for items to send. Queued items will periodically be batched together and sent by this thread, with failed attempts retried a few times in case of network reachability issues.
- Device code now tracked as the Rollbar backend expects it to be, fixing "Device/OS" graphs.

**0.0.2**
- Ability to set `person` data.

**0.0.1**
- Initial release.
- First version that reports all crashes and allows reporting arbitrary log messages.
