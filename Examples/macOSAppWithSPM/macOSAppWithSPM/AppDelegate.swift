//
//  AppDelegate.swift
//  macOSAppWithSPM
//
//  Created by Andrey Kornich on 2020-02-06.
//  Copyright © 2020 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

import Cocoa
import RollbarNotifier

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let config: RollbarConfig = RollbarConfig();
        config.destination.accessToken = "2ffc7997ed864dda94f63e7b7daae0f3";
        config.destination.environment = "samples";

        Rollbar.initWithConfiguration(config);
        Rollbar.infoMessage("SwiftPM Test");
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

