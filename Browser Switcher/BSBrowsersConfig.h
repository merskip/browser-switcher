//
//  BSBrowsersConfig.h
//  Browser Switcher
//
//  Created by Piotr Merski on 13.09.2016.
//  Copyright © 2016 Merskip Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSBrowserItem.h"

@interface BSBrowsersConfig : NSObject <NSCoding>

@property (nonatomic, strong) NSString *defaultBrowser;
@property (nonatomic, strong) NSMutableArray<BSBrowserItem *> *alternativeBrowsers;

+ (instancetype)load;
- (BOOL)save;

@end
