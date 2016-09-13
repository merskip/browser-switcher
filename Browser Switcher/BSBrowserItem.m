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
        _urlTemplates = urlTemplates;
    }
    return self;
}

+ (instancetype)browserItemWithName:(NSString *)name urlTemplates:(NSArray<NSString *> *)urlTemplates {
    return [[self alloc] initWithName:name urlTemplates:urlTemplates];
}

@end
