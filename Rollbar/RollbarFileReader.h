// Based off of DDFileReader from http://stackoverflow.com/a/8027618

#import <Foundation/Foundation.h>

@interface RollbarFileReader : NSObject {
    NSString * filePath;
    
    NSFileHandle * fileHandle;
    NSUInteger currentOffset;
    
    NSString * lineDelimiter;
    NSUInteger chunkSize;
}

@property (nonatomic, copy) NSString * lineDelimiter;
@property (nonatomic) NSUInteger chunkSize;

- (id) initWithFilePath:(NSString *)aPath andOffset:(NSUInteger)offset;

- (NSString *) readLine;

- (void) enumerateLinesUsingBlock:(void(^)(NSString*, NSUInteger, BOOL*))block;

@end
