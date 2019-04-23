# Example: Rollbar-iOS within another framework

This example demonstrates how to integrate Rollbar-iOS notifier within a custom built framework.

## Commit: 3abb588e735ac5146107f169a0b31203ed5b2d26
Initial codebase: 
Two buildable projects KnobShowcase (an app) and KnobControl (a custom-built framework). 
KnobShowcase application uses KnobControl framework. 
(These projects are courtesy of https://www.raywenderlich.com/5109-creating-a-framework-for-ios)

## Commit: 56770d7d14888c3313c064c7397115e3b43f58cc

Integrated Rollbar-iOS notifier into the KnobControl framework, so that, when the KnobShowcase app runs and the Knob control is initialized and manipulated, Rollbar-iOS SDK sends message to the Rollbar API (for example: https://rollbar.com/Rollbar/rollbar-ios/items/56/occurrences/58093544926/)

## What was done betwen the two commits above: Steps to integrate Rollbar-iOS into KnobControl

1. Open KnobShowcase project in Xcode.
2. In Xcode's Project Navigator, observe that KnobShowcase already includes/depends-on KnobControl project.
3. Locate your local repo/codebase of Rollbar-iOS in Finder and drag-and-drop its Rollbar project file onto 
   the KnobControl project item within the Xcode's Project Navigator.
4. Now you should see your project roots organized in the Project Navigator like so:
```   
      KnobShowcase
      |__KnobControl
          |__Rollbar
```          

5. In the Project Navigator, unfold Products subfolder of the Rollbar project so that you can see Rollbar.framework within its content.
6. In the Project Navigator, elect/click KnobControl project root. In the project configuration view (to the right of the Project Navigator), select KnobControl target and Genral settings for it. Down the General settings view there is the Linked Frameworks and Libraries section.
7. Drag Rollbar.framework item from the Rollbar project's Products subforlder of the Project Navigator and drop it within the Linked Frameworks and Libraries section of the General settings for KnobControl target.
8. Locate (or create) the custom framework's bridge-header file. For the KnobControl framework project, it is the KnobControl.h and add following imprts at the top of the file:
```
#import <SystemConfiguration/SystemConfiguration.h>
#import <Rollbar/Rollbar.h>
```
9. Locate the Knob.swift file that we want to instrument using Rollbar-iOS notifier.
10.  Modify commonInit() function of the Knob class by adding followin Rollbar initialozation code at the top of the function:
```
    // configure Rollbar:
    let config: RollbarConfiguration = RollbarConfiguration()
    config.environment = "samples"
    Rollbar.initWithAccessToken("2ffc7997ed864dda94f63e7b7daae0f3", configuration: config)
```
and by adding informational log at the function bottom:
```
    Rollbar.info("The Knob initialized!")
```
11. Also, in order to log current Knob state, modify setValue(...) function of the Knob class by adding following lines of code:
```
    Rollbar.debug(String(format: "value = %f", value))
```
and 
```
    Rollbar.debug(String(format: "angle = %f", angleValue))
```
11. Now, after building and running the application, you can observe following items within the Rollbar Dashboard:

   https://rollbar.com/Rollbar/rollbar-ios/items/56/occurrences/58093544926/

   https://rollbar.com/Rollbar/rollbar-ios/items/49/occurrences/58093554330/

   https://rollbar.com/Rollbar/rollbar-ios/items/53/occurrences/58093554478/

