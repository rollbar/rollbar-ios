//
//  AppDelegate.swift
//  macOSAppWithSPM
//
//  Created by Andrey Kornich on 2020-02-06.
//  Copyright © 2020 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

import Cocoa
import Rollbar

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let config: RollbarConfiguration = RollbarConfiguration()
        config.environment = "samples"

        Rollbar.initWithAccessToken("2d6e0add5d9b403d9126b4bcea7e0199", configuration: config)
        Rollbar.info("SwiftPM Test");
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

