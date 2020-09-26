//
//  File.swift
//  
//
//  Created by Andrey Kornich on 2020-06-01.
//

import Foundation
import RollbarCommon
import RollbarNotifier

class RollbarTestUtil {
    
    private static let queuedItemsFileName = "rollbar.items";
    private static let queuedItemsStateFileName = "rollbar.state";
    private static let telemetryFileName = "rollbar.telemetry";

    private static func getQueuedItemsFilePath() -> String {
        let cachesDirectory = RollbarCachesDirectory.directory() ?? "";
        let filePath = URL(fileURLWithPath: cachesDirectory).appendingPathComponent(queuedItemsFileName);
        return filePath.path;
    }

    private static func getQueuedItemsStateFilePath() -> String {
        let cachesDirectory = RollbarCachesDirectory.directory() ?? "";
        let filePath = URL(fileURLWithPath: cachesDirectory).appendingPathComponent(queuedItemsStateFileName);
        return filePath.path;
    }
    private static func getTelemetryFilePath() -> String {
        let cachesDirectory = RollbarCachesDirectory.directory() ?? "";
        let filePath = URL(fileURLWithPath: cachesDirectory).appendingPathComponent(telemetryFileName);
        return filePath.path;
    }

    public static func clearTelemetryFile() {
        let filePath = RollbarTestUtil.getTelemetryFilePath();
        let fileManager = FileManager.default;
        let fileExists = fileManager.fileExists(atPath: filePath);
        if fileExists {
            do {
                try fileManager.removeItem(atPath: filePath);
            } catch {
                print("Unexpected error: \(error).")
            }
            fileManager.createFile(atPath: filePath, contents: nil, attributes: nil);
        }
    }

    public static func clearLogFile() {
        let itemsStateFilePath = RollbarTestUtil.getQueuedItemsStateFilePath();
        let itemsFilePath = RollbarTestUtil.getQueuedItemsFilePath();
        let fileManager = FileManager.default;
        do {
            if fileManager.fileExists(atPath: itemsStateFilePath) {
                try fileManager.removeItem(atPath: itemsStateFilePath);
            }
            if fileManager.fileExists(atPath: itemsFilePath) {
                try fileManager.removeItem(atPath: itemsFilePath);
                fileManager.createFile(
                    atPath: itemsFilePath,
                    contents: nil,
                    attributes: nil
                );
            }
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    public static func readFirstItemStringsFromLogFile() -> String? {
        
        let filePath = RollbarTestUtil.getQueuedItemsFilePath();
        let fileReader = RollbarFileReader(filePath: filePath, andOffset: 0);
        let item = fileReader.readLine();
        return item;
    }

    public static func readItemStringsFromLogFile() -> [String] {
        
        let filePath = RollbarTestUtil.getQueuedItemsFilePath();
        let fileReader = RollbarFileReader(filePath: filePath, andOffset: 0);
        var items = [String]();
        fileReader.enumerateLines({ (line, nextOffset, stop) in
            if (line == nil) {
                return;
            }
            items.append(line!);
        });
        return items;
    }

    public static func readItemsFromLogFile() -> [NSMutableDictionary] {
        let filePath = RollbarTestUtil.getQueuedItemsFilePath();
        let fileReader = RollbarFileReader(filePath: filePath, andOffset: 0);
        var items = [NSMutableDictionary] ();
        fileReader.enumerateLines({ (line, nextOffset, stop) in
            if (line == nil) {
                return;
            }
            var payload : NSMutableDictionary? = nil;
            do {
                try payload = JSONSerialization.jsonObject(
                    with: (line?.data(using: .utf8))!,
                    options: [.mutableContainers, .mutableLeaves]
                    ) as? NSMutableDictionary;
            } catch {
                print("Unexpected error: \(error).")
            }
            if payload == nil {
                return;
            }
            items.append(payload!["data"] as! NSMutableDictionary);
        });
        
        return items;
    }
    
    public static func waitForPesistenceToComplete(waitTimeInSeconds: TimeInterval = 0.5) {
        Thread.sleep(forTimeInterval: waitTimeInSeconds);
    }

    public static func simulateError(callDepth: inout uint) throws {
        callDepth = callDepth - 1;
        if (callDepth > 0) {
            try RollbarTestUtil.simulateError(callDepth: &callDepth);
        }
        else {
            throw RollbarTestUtilError.simulatedException(errorDescription: "An error was just simulated!");
        }
    }
    
    public static func makeTroubledCall() throws {
        try makeInnerTroubledCall();
    }

    private static func makeInnerTroubledCall() throws {
        try makeMostInnerTroubledCall();
    }

    private static func makeMostInnerTroubledCall() throws {
        //throw RollbarTestUtilError.basicError;
        //throw RollbarTestUtilError.simulatedException(errorDescription: "ENUM ERROR: Trouble at its source!");
        //throw BackTracedError(errorDescription: "BACKTRACED ERROR: Trouble at its source!");
        throw CustomError(errorDescription: "CUSTOM BACKTRACED ERROR: Trouble at its source!");
        //throw CustomError();
    }

//    public static func flushFileThread(logger: RollbarLogger) {
//        logger.perform(
//            #selector(logger._test_do_nothing),
//            on: logger._rollbarThread,
//            with: nil,
//            waitUntilDone: true
//        );
//
////        [notifier performSelector:@selector(_test_doNothing)
////                         onThread:[notifier _rollbarThread] withObject:nil waitUntilDone:YES];
//    }
    
}

enum RollbarTestUtilError: Error {
    case basicError
    case simulatedError(errorDescription: String)
    case simulatedException(errorDescription: String, errorCallStack: [String] = Thread.callStackSymbols)
    //case nullReferenceException = RollbarErrorBase("Null reference!")
    
}

protocol BackTracedErrorProtocol : Error /*OR LocalizedError OR CustomNSError*/ {
    var errorDescription: String { get }
    var errorCallStack: [String] { get }
}

struct BackTracedError : BackTracedErrorProtocol {
    
    private let _errorDescription: String;
    private let _errorCallStack: [String];
    
    init(errorDescription: String, errorCallStack: [String] = Thread.callStackSymbols) {
        self._errorDescription = errorDescription;
        self._errorCallStack = errorCallStack;
    }
    
    var errorDescription: String {
        return self._errorDescription;
    }
    
    var errorCallStack: [String] {
        return self._errorCallStack;
    }
}

class BackTracedErrorBase: BackTracedErrorProtocol {
    
    private let _errorDescription: String;
    private let _errorCallStack: [String];
    
    init(errorDescription: String, errorCallStack: [String] = Thread.callStackSymbols) {
        self._errorDescription = errorDescription;
        self._errorCallStack = errorCallStack;
    }
    
    var errorDescription: String {
        return self._errorDescription;
    }

    var errorCallStack: [String] {
        return self._errorCallStack;
    }
}

class CustomError: BackTracedErrorBase {
    
    convenience init() {
        self.init(errorDescription: "Default back-traced error!");
    }
    
    init(errorDescription: String) {
        super.init(errorDescription: errorDescription);
    }
}
