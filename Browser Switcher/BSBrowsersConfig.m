//
//  BSBrowsersConfig.m
//  Browser Switcher
//
//  Created by Piotr Merski on 13.09.2016.
//  Copyright © 2016 Merskip Enterprise. All rights reserved.
//

#import "BSBrowsersConfig.h"

@implementation BSBrowsersConfig

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.defaultBrowser forKey:@"defaultBrowser"];
    [encoder encodeObject:self.alternativeBrowsers forKey:@"alternativeBrowsers"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.defaultBrowser = [decoder decodeObjectForKey:@"defaultBrowser"];
        self.alternativeBrowsers = [decoder decodeObjectForKey:@"alternativeBrowsers"];
    }
    return self;
}

+ (instancetype)load {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *browersData = [userDefaults objectForKey:@"browersConfig"];
    BSBrowsersConfig *browersConfig = [NSKeyedUnarchiver unarchiveObjectWithData:browersData];
    
    if (browersConfig == nil) {
        browersConfig = [BSBrowsersConfig new];
        browersConfig.defaultBrowser = @"";
        browersConfig.alternativeBrowsers = [NSMutableArray array];
    }
    return browersConfig;
}

- (BOOL)save {
    NSData *browersData = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:browersData forKey:@"browersConfig"];
    return [userDefaults synchronize];
}

@end
