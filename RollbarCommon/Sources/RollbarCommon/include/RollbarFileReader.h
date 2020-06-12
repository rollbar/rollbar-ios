// Based off of DDFileReader from http://stackoverflow.com/a/8027618

#ifndef RollbarFileReader_h
#define RollbarFileReader_h

@import Foundation;

@interface RollbarFileReader : NSObject {
    
    NSString * filePath;
    
    NSFileHandle * fileHandle;
    NSUInteger currentOffset;
    
    NSString * lineDelimiter;
    NSUInteger chunkSize;
}

#pragma mark - Properties

@property (nonatomic, copy) NSString * lineDelimiter;

@property (nonatomic) NSUInteger chunkSize;

#pragma mark - Methods

- (NSString *) readLine;

- (NSUInteger) getCurrentOffset;

- (void) enumerateLinesUsingBlock:(void(^)(NSString*, NSUInteger, BOOL*))block;

#pragma mark - Initializers

- (instancetype) init
NS_UNAVAILABLE;

- (instancetype) initWithFilePath:(NSString *)aPath andOffset:(NSUInteger)offset
NS_DESIGNATED_INITIALIZER;

@end

#endif //RollbarFileReader_h
