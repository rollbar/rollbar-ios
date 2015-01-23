//
//  RollbarConfiguration.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/21/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import "RollbarConfiguration.h"
#import "objc/runtime.h"

static NSString *CONFIGURATION_FILENAME = @"rollbar.config";
static NSString *DEFAULT_ENDPOINT = @"https://api.rollbar.com/api/1/items/";

static NSString *configurationFilePath = nil;

@interface RollbarConfiguration () {
    NSMutableDictionary *customData;
}

@property (nonatomic, copy) NSString* personId;
@property (nonatomic, copy) NSString* personUsername;
@property (nonatomic, copy) NSString* personEmail;

@end

@implementation RollbarConfiguration

+ (RollbarConfiguration*)configuration {
    return [[RollbarConfiguration alloc] init];
}

- (id)init {
    if (!configurationFilePath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        configurationFilePath = [cachesDirectory stringByAppendingPathComponent:CONFIGURATION_FILENAME];
    }
    
    if (self = [super init]) {
        customData = [NSMutableDictionary dictionaryWithCapacity:10];
        self.endpoint = DEFAULT_ENDPOINT;
        
        #ifdef DEBUG
        self.environment = @"development";
        #else
        self.environment = @"unspecified";
        #endif
        
        self.crashLevel = @"error";
    }

    return self;
}

- (id)initWithLoadedConfiguration {
    self = [self init];
    
    NSData *data = [NSData dataWithContentsOfFile:configurationFilePath];
    if (data) {
        NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        for (NSString *propertyName in config.allKeys) {
            id value = [config objectForKey:propertyName];
            [self setValue:value forKey:propertyName];
        }
    }
    
    return self;
}

- (void)setPersonId:(NSString *)personId username:(NSString *)username email:(NSString *)email {
    self.personId = personId;
    self.personUsername = username;
    self.personEmail = email;
    
    [self save];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value) {
        customData[key] = value;
    } else {
        [customData removeObjectForKey:key];
    }
    
    [self save];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return customData[key];
}

// Add a key value observer for all properties so that this object
// is saved to disk every time a property is updated
- (void)_setRoot {
    isRootConfiguration = YES;
    
    for (NSString *propertyName in [self getProperties]) {
        if ([propertyName rangeOfString:@"person"].location == NSNotFound) {
            [self addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

// Convert this object's properties into json and save it to disk only if
// this is the root level configuration
- (void)save {
    if (isRootConfiguration) {
        NSMutableDictionary *config = [NSMutableDictionary dictionary];
        
        for (NSString *propertyName in [self getProperties]) {
            id value = [self valueForKey:propertyName];
            if (value) {
                [config setObject:value forKey:propertyName];
            }
        }
        
        NSData *configJson = [NSJSONSerialization dataWithJSONObject:config options:0 error:nil];
        [configJson writeToFile:configurationFilePath atomically:YES];
    }
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    [self save];
}

- (NSArray*)getProperties {
    NSMutableArray *result = [NSMutableArray array];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(i = 0; i < outCount; ++i) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
            
            [result addObject:propertyName];
        }
    }
    
    free(properties);
    
    [result addObjectsFromArray:customData.allKeys];
    
    return result;
}


- (NSDictionary *)customData {
    return [NSDictionary dictionaryWithDictionary:customData];
}
@end
