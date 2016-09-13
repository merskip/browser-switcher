//
//  BSBrowserOpener.h
//  Browser Resolver
//
//  Created by Piotr Merski on 13.09.2016.
//  Copyright © 2016 Merskip Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSBrowserOpener : NSObject

+ (BOOL)openUrl:(NSString *)url;

+ (BOOL)openUrl:(NSString *)url withApplication:(NSString *)application;

@end
