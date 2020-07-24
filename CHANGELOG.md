# CHANGELOG

The change log has moved to this repo's [GitHub Releases Page](https://github.com/rollbar/rollbar-ios/releases).

## Release Notes Tagging Conventions

1.  Every entry within the PackageReleaseNotes element is expected to be started with
    at least one of the tags listed:

    feat:     A new feature
    fix:      A bug fix
    docs:     Documentation only changes
    style:    Changes that do not affect the meaning of the code
    refactor: A code change that neither a bug fix nor a new feature
    perf:     A code change that improves performance
    test:     Adding or modifying unit test code
    chore:    Changes to the build process or auxiliary tools and libraries such as documentation generation, etc.

2.  Every entry within the PackageReleaseNotes element is expected to be tagged with 
    EITHER 
    "resolve #GITHUB_ISSUE_NUMBER:" - meaning completely addresses the GitHub issue
    OR 
    "ref #GITHUB_ISSUE_NUMBER:" - meaning relevant to the GitHub issue
    depending on what is more appropriate in each case.

## Release Notes

**2.0.0** Preliminary Notes
- refactor: changed WitelistFileds into SafeListFields when it comes to the RollbarScrubbingOptions
- feat: defined default scrub fields

**1.12.8**
- fix: resolve #283: Add RollbarFramework/* to source_files

**1.12.7**
- fix: resolve #281: Set the correct Rollbar.h location in podspec
- chore: updated samples to the latest pod

**1.12.6**
-fix: resolve #279: Increment Cocoapods pod version

**1.12.5**
- fix: resolve #227: Fix broken Cocoapods push

**1.12.4**
- fix: resolve PR #275: Compile without headermap, to fix header file collisions.
- fix: resolve #244: Demangle.cpp failing to build 
- fix: resolve #239: Compiler Issue - "'absl/base/internal/inline_variable.h' file not found"
- chore: resolve #272: Update CocoaPods related examples to use latest pod version 

**1.12.3**
- fix: resolve #154: Reporting to multiple projects

**1.12.2**
- fix: resolve #266: Telemetry events timestamp is rendered as a string instead of expected "as a number"

**1.12.1**
- fix: resolve #264: Fix Rollbar.podspec

**1.12.0**
- feat: resolve #261: Turn telemetry events into DTOs
- refactor: resolve #262: Improve codebase layout by logically grouping source code files
- refactor: resolve #256: Refactor RollbarTelemetry implementation.
- refactor: resolve #255: Mark deprecated public API with proper deprecated attribute.
- refactor: resolve #259: Refactor RollbarNotifier's initializers
- chore: resolve #260: Remove dead code from RollbarNotifier
- test: resolve #257: Fix failing testErrorReportingWithTelemetry unit test
- test: resolve #258: Fix deprecated API warnings in unit-test builds

**1.11.6**
**1.11.5**
- fix: resolve #253: fix the podspec issue

**1.11.4**
- fix: resolve #248: 'NSJSONWritingSortedKeys' is only available on iOS 11.0 or newer.
- chore: resolve #250: Remove unused classes, protocols, etc.
- feat: (IN PROGRESS) ref #212: Add Swift Package Manager support.

**1.11.3**
- fix: resolve #234: Extra data is not attached to message-like payloads under body.message.extra data field.
- fix: resolve #235: Fix framework's modulemap.
- chore: resolve #236: Consolidate info.plist-s of multiple targets.
- chore: resolve #237: Clean-up the framework's umbrella header.
- chore: resolve #238: Clean-up the framework's podspec.
- docs: resolve #233: Create example of integrating Rollbar-iOS with ObjC iOS app via Carthage

**1.11.2**
- chore: resolve #227: Fix build warnings.

**1.11.1**
- fix: resolve #225: Fix cocopods' podspec

**1.11.0**
- feat: resolve #220: Implement payload data structure as a DTO.
- feat: resolve #222: Integrate the new payload DTOs.
- chore: resolve #223: Update SDK's public headers.
- fix: ref #221: Fix initialization DeployApiCallResult DTOs based on the HTTP responses.
- chore: codebase cleanup, extra code comments, cleaning up #imports, etc.

**1.10.0**
- feat: resolve #206: Capture Log As Telemetry - Not working? Introducing RollbarLog(...)
- feat: resolve #217: Reimplement Deploys based on the DTOs 

**1.9.1**
- feat: resolve #215: Change client.os element back to client.ios to fix dSYMs application

**1.9.0**
- feat: resolve #194: Capture relevant notifier config with every payload.
- feat: resolve #205: Reimplement RollbarConfiguration as a Rollbar DTO
- feat: resolve #204: Build JSON serializable base for Rollbar DTOs
- chore: bumped the version up
 
**1.8.4**
- fix: resolve #200: Correct the notifier version
- refactor: resolve #201: Update KSCrash submodule to its v1.15.21 release

**1.8.3**
**1.8.2**
- fix: resolve #192: Carthage error when build framework
- chore: updated Readme.md, Changelog.md and Rollbar.podspec
- docs: resolve #195: Add example of catching and reporting NSException.

**1.8.1**
**1.8.0-alpha8**
**1.8.0-alpha7**
**1.8.0-alpha6**
**1.8.0-alpha5**
**1.8.0-alpha4**
**1.8.0-alpha3**
**1.8.0-alpha2**
**1.8.0-alpha1**
**1.8.0**

- feat: resolve #168: add support for high sierra 
- feat: resolve #45: How about support for macOS?
- feat: resolve #176: Add sandboxing status detection to RollbarCachesDirectory.
- fix: resolve #171: Fix build errors during cocoapods' trunk push
- docs: resolve #175: Create a sample app - macOSAppWithRollbarCocoaPod.
- docs: resolve #179: Create a sample app - iOSAppWithRollbarCocoaPod.
- chore: resolve #181: Create Rollbar-iOS-UniversalDistribution aggregate build target.
- chore: resolve #182: Create RollbarKit-iOS-UniversalDistribution aggregate build target.
- chore: resolve #183: Modify all the new build targets to produce build results based on $(PRODUCT_NAME) instead of $(TARGET_NAME).
- chore: resolve #184: Create RollbarSDKReleaseDistribution build target.
- feat: resolve #165: Make SDK to obey service-side enforced rate limits unless client-side RollbarConfig defines one
- chore: fixed a few build warnings and minor code clean-up

**1.7.0**

- feat: ref #162: Implement the standardized Development Configuration Options.
- feat: resolve #163: Add developer option: transmit.
- feat: resolve #164: Add a developer config option: logPayload.

**1.6.0**

- resolve #157: Ability to customize client.ios.code_version
- resolve #155: Enable sending complete JSON payloads, as proxy for other SDKs

**1.5.2**

- resolve #150: Crash during payload strings truncation

**1.5.0**

- Change how the raw string for crash reports is truncated
- Finish converting to the /item/ api endpoint. Note that the default endpoint has changed, so if
  you were changing this configuration parameter, you should make sure that whatever you are using
  is compatible with the changes in this release.

**1.4.2**

- resolve #139: The Rollbar.zip's for version 1.4.0 and 1.4.1 don't include the framework
Adopting Xcode 10 build process changes within Distribution target's build script
- Numerous code fixes and clean-up
- Cleaned up build warnings
- resolve #137: Example of using Rollbar-iOS within a custom-built framework
- documentation updates

**1.4.1**

- resolve #130: Update podspec with the Deploy API related headers
- resolve #131: Make RollbarPayloadTruncator.h public

**1.4.0**

- resolve #73: Support deploy tracking

**1.3.0**

- resolve #80: Add telemetry scrubbing options
- resolve #83:Add support for using a proxy
- resolve #90: Add scrub whitelist config option
- resolve #124: fix failing unit tests

**1.2.0**

- resolve #88: Add enable/disable telemetry config option
- resolve #89: Add enabled/disabled config option
- resolve #119: Is there a reason why library should constantly spam "Checking items..." into console?

**1.1.0**

- resolve #81: Truncate large payloads to ensure we don't drop them
- resolve #84: Add items per minute config option
- resolve #107: logging an exception does not include extra data into a payload
- resolve #109: when an NSException is reported with an auxiliary message it is not reported as a trace object
- resolve #87: Add log level config option
- resolve #111: Add telemetry example
- resolve #113: Eliminate payload batch sending - send one payload at a time

**1.0.0**

- Fix some threading issues
- Drop the alpha moniker

**1.0.0-alpha11**

- Framework builds for each of the recent versions of Xcode
- Cocoapods support

**1.0.0-alpha10**
- Change `setCaptureIp:` to `setCaptureIpType:`

**1.0.0-alpha9**
- Introduce the `CaptureIp` configuration setting. `CaptureIp` specifies the level of IP information
  to gather about the client along with items. This uses the enum `CaptureIpType` with the levels:
  `CaptureIpFull`, `CaptureIpAnonymize`, and `CaptureIpNone`.

  `CaptureIpFull` is the default behaviour which attempts to capture the IP address on the backend
  based on the IP address of the client used to POST the item.
  `CaptureIpAnonymize` will attempt to capture the IP address and semi-anonymize it by masking it
  the least significant bits.
  `CaptureIpNone` will turn off attempts to capture the IP address.


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
