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
    
    private static func getFilePath() -> String {
        let cachesDirectory = RollbarCachesDirectory.directory() ?? "";
        let filePath = URL(fileURLWithPath: cachesDirectory).appendingPathComponent(queuedItemsFileName);
        return filePath.path;
    }
    
    public static func clearLogFile() {
        let filePath = RollbarTestUtil.getFilePath();
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

    public static func readFirstItemStringsFromLogFile() -> String? {
        
        let filePath = RollbarTestUtil.getFilePath();
        let fileReader = RollbarFileReader(filePath: filePath, andOffset: 0);
        let item = fileReader?.readLine();
        return item;
    }

    public static func readItemStringsFromLogFile() -> [String] {
        
        let filePath = RollbarTestUtil.getFilePath();
        let fileReader = RollbarFileReader(filePath: filePath, andOffset: 0);
        var items = [String]();
        fileReader!.enumerateLines({ (line, nextOffset, stop) in
            if (line == nil) {
                return;
            }
            items.append(line!);
        });
        return items;
    }

    public static func readItemsFromLogFile() -> [NSMutableDictionary] {
        let filePath = RollbarTestUtil.getFilePath();
        let fileReader = RollbarFileReader(filePath: filePath, andOffset: 0);
        var items = [NSMutableDictionary] ();
        fileReader!.enumerateLines({ (line, nextOffset, stop) in
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
