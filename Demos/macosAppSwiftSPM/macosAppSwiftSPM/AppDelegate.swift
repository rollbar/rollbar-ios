//
//  AppDelegate.swift
//  macosAppSwiftSPM
//
//  Created by Andrey Kornich on 2020-06-25.
//  Copyright © 2020 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

import Cocoa
import RollbarNotifier
//import SwiftTryCatch2

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.demonstrateDeployApiUasege();
        self.initRollbar();
        
//        SwiftTryCatch.tryRun({
//            self.callTroublemaker();
//        },
//        catchRun: { (exception) in
//            Rollbar.error("Got an exception!", exception: exception)
//        },
//        finallyRun: {
//            Rollbar.info("Post-trouble notification!");
//        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        Rollbar.info("The hosting application is terminating...");
    }

    func initRollbar() {

        // configure Rollbar:
        let config = RollbarConfiguration.init();
        
        //config.crashLevel = @"critical";
        config.environment = "samples";
        config.asRollbarConfig().customData = [ "someKey": "someValue", ];
        // init Rollbar shared instance:
        Rollbar.initWithAccessToken("2ffc7997ed864dda94f63e7b7daae0f3", configuration: config);
        Rollbar.info("Rollbar is up and running! Enjoy your remote error and log monitoring...");
    }

    func demonstrateDeployApiUasege() {
        
        let rollbarDeploysIntro = RollbarDeploysDemoClient();
        rollbarDeploysIntro.demoDeploymentRegistration();
        rollbarDeploysIntro.demoGetDeploymentDetailsById();
        rollbarDeploysIntro.demoGetDeploymentsPage();
    }

//    func callTroublemaker() {
//        SwiftTryCatch.throw(
//            NSException(name: NSExceptionName("Incoming ObjC exception!!!"), reason: "Why not?", userInfo: nil)
//        );
//    }

}

