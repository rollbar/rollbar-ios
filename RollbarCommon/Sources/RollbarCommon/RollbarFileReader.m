// Based off of DDFileReader from http://stackoverflow.com/a/8027618

#import "RollbarFileReader.h"

@implementation RollbarFileReader

@synthesize lineDelimiter, chunkSize;

+ (NSRange)findData:(NSData *)dataToFind inData:(NSData*)data {
    const void * bytes = [data bytes];
    NSUInteger length = [data length];
    
    const void * searchBytes = [dataToFind bytes];
    NSUInteger searchLength = [dataToFind length];
    NSUInteger searchIndex = 0;
    
    NSRange foundRange = {NSNotFound, searchLength};
    for (NSUInteger index = 0; index < length; index++) {
        if (((char *)bytes)[index] == ((char *)searchBytes)[searchIndex]) {
            //the current character matches
            if (foundRange.location == NSNotFound) {
                foundRange.location = index;
            }
            searchIndex++;
            if (searchIndex >= searchLength) { return foundRange; }
        } else {
            searchIndex = 0;
            foundRange.location = NSNotFound;
        }
    }
    return foundRange;
}

- (instancetype) initWithFilePath:(NSString *)aPath andOffset:(NSUInteger)offset {
    if (self = [super init]) {
        fileHandle = [NSFileHandle fileHandleForReadingAtPath:aPath];
        if (fileHandle == nil) {
            return nil;
        }
        
        lineDelimiter = @"\n";
        currentOffset = offset;
        chunkSize = 128;
    }
    return self;
}

- (void) dealloc {
    [fileHandle closeFile];
    currentOffset = 0ULL;
}

- (NSString *) readLine {
    NSData * newLineData = [lineDelimiter dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle seekToFileOffset:currentOffset];
    NSMutableData * currentData = [[NSMutableData alloc] init];
    BOOL shouldReadMore = YES;
    
    @autoreleasepool {
        
        while (shouldReadMore) {
            NSData * chunk = [fileHandle readDataOfLength:chunkSize];
            
            if ([chunk length] == 0) {
                return nil;
            }
            
            NSRange newLineRange = [RollbarFileReader findData:newLineData inData:chunk];
            if (newLineRange.location != NSNotFound) {
                
                //include the length so we can include the delimiter in the string
                chunk = [chunk subdataWithRange:NSMakeRange(0, newLineRange.location+[newLineData length])];
                shouldReadMore = NO;
            }
            [currentData appendData:chunk];
            currentOffset += [chunk length];
        }
    }
    
    NSString * line = [[NSString alloc] initWithData:currentData encoding:NSUTF8StringEncoding];
    return line;
}

- (NSUInteger) getCurrentOffset {
    return currentOffset;
}

- (void) enumerateLinesUsingBlock:(void(^)(NSString*, NSUInteger, BOOL*))block {
    NSString * line = nil;
    BOOL stop = NO;
    while (stop == NO && (line = [self readLine])) {
        block(line, currentOffset, &stop);
    }
}

@end
