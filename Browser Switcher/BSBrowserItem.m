//
//  BSBrowserItem.m
//  Browser Switcher
//
//  Created by Piotr Merski on 13.09.2016.
//  Copyright © 2016 Merskip Enterprise. All rights reserved.
//

#import "BSBrowserItem.h"

@implementation BSBrowserItem

- (instancetype)initWithName:(NSString *)name urlTemplates:(NSArray<NSString *> *)urlTemplates {
    if (self = [super init]) {
        _applicationName = name;
        _urlTemplates = [NSMutableArray arrayWithArray:urlTemplates];
    }
    return self;
}

+ (instancetype)browserItemWithName:(NSString *)name urlTemplates:(NSArray<NSString *> *)urlTemplates {
    return [[self alloc] initWithName:name urlTemplates:urlTemplates];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.applicationName forKey:@"applicationName"];
    [encoder encodeObject:self.urlTemplates forKey:@"urlTemplates"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.applicationName = [decoder decodeObjectForKey:@"applicationName"];
        self.urlTemplates = [decoder decodeObjectForKey:@"urlTemplates"];
    }
    return self;
}

@end
