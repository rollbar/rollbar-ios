//
//  RollbarTestUtil.m
//  RollbarTests
//
//  Created by Ben Wong on 12/1/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import "RollbarTestUtil.h"
#import "RollbarFileReader.h"

@implementation RollbarTestUtil

static NSString *QUEUED_ITEMS_FILE_NAME = @"rollbar.items";

NSString* _logFilePath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    return [cachesDirectory stringByAppendingPathComponent:QUEUED_ITEMS_FILE_NAME];
}

void RollbarClearLogFile() {
    NSString *filePath = _logFilePath();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    
    if (fileExists) {
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
}

NSArray* RollbarReadLogItemFromFile() {
    NSString *filePath = _logFilePath();
    RollbarFileReader *reader = [[RollbarFileReader alloc] initWithFilePath:filePath andOffset:0];
    
    NSMutableArray *items = [NSMutableArray array];
    [reader enumerateLinesUsingBlock:^(NSString *line, NSUInteger nextOffset, BOOL *stop) {
        NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:[line dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        if (!payload) {
            return;
        }
        
        NSDictionary *data = payload[@"data"];
        [items addObject:data];
    }];
    
    return items;
}

@end
