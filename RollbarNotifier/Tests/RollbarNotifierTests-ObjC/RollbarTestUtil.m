//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import "RollbarTestUtil.h"
#import "RollbarFileReader.h"
#import "RollbarCachesDirectory.h"

static NSString *QUEUED_ITEMS_FILE_NAME = @"rollbar.items";

NSString* _logFilePath() {
    
    NSString *cachesDirectory = [RollbarCachesDirectory directory];
    return [cachesDirectory stringByAppendingPathComponent:QUEUED_ITEMS_FILE_NAME];
}

void RollbarClearLogFile() {
    
    NSString *filePath = _logFilePath();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    
    if (fileExists) {
        BOOL success = [fileManager removeItemAtPath:filePath
                                               error:&error];
        if (!success) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        [[NSFileManager defaultManager] createFileAtPath:filePath
                                                contents:nil
                                              attributes:nil];
    }
}

NSArray* RollbarReadLogItemFromFile() {
    
    NSString *filePath = _logFilePath();
    RollbarFileReader *reader = [[RollbarFileReader alloc] initWithFilePath:filePath
                                                                  andOffset:0];
    
    NSMutableArray *items = [NSMutableArray array];
    [reader enumerateLinesUsingBlock:^(NSString *line, NSUInteger nextOffset, BOOL *stop) {
        NSMutableDictionary *payload =
            [NSJSONSerialization JSONObjectWithData:[line dataUsingEncoding:NSUTF8StringEncoding]
                                            options:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves)
                                              error:nil
             ];
        
        
        if (!payload) {
            return;
        }
        
        NSMutableDictionary *data = payload[@"data"];
        [items addObject:data];
    }];
    
    return items;
}

void RollbarFlushFileThread(RollbarLogger *logger) {
    
    [logger performSelector:@selector(_test_doNothing)
                     onThread:[logger _rollbarThread] withObject:nil waitUntilDone:YES];
}
