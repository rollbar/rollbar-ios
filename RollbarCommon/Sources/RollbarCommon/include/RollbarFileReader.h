// Based off of DDFileReader from http://stackoverflow.com/a/8027618

#ifndef RollbarFileReader_h
#define RollbarFileReader_h

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarFileReader : NSObject {
    
    NSString *filePath;
    
    NSFileHandle *fileHandle;
    NSUInteger currentOffset;
    
    NSString *lineDelimiter;
    NSUInteger chunkSize;
}

#pragma mark - Properties

@property (nonatomic, copy) NSString *lineDelimiter;

@property (nonatomic) NSUInteger chunkSize;

#pragma mark - Methods

- (nullable NSString *)readLine;

- (NSUInteger)getCurrentOffset;

- (void)enumerateLinesUsingBlock:(void(^)(NSString *_Nullable, NSUInteger, BOOL *))block;

#pragma mark - Initializers

- (instancetype)init
NS_UNAVAILABLE;

- (instancetype)initWithFilePath:(NSString *)path andOffset:(NSUInteger)offset
NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#endif //RollbarFileReader_h
