//
//  BSBrowserItem.h
//  Browser Switcher
//
//  Created by Piotr Merski on 13.09.2016.
//  Copyright © 2016 Merskip Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSBrowserItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString *applicationName;
@property (nonatomic, strong) NSMutableArray<NSString *> *urlTemplates;

+ (instancetype)browserItemWithName:(NSString *)name urlTemplates:(NSArray<NSString *> *)urlTemplates;

@end
