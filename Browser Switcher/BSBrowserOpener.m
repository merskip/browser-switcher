//
//  BSBrowserOpener.m
//  Browser Resolver
//
//  Created by Piotr Merski on 13.09.2016.
//  Copyright © 2016 Merskip Enterprise. All rights reserved.
//

#import "BSBrowserOpener.h"
#import "BSBrowsersConfig.h"

@implementation BSBrowserOpener

+ (BOOL)openUrl:(NSString *)url {
    BSBrowsersConfig *browsersConfig = [BSBrowsersConfig load];
    NSString *resolvedBrowser = nil;
    
    for (BSBrowserItem *browser in browsersConfig.alternativeBrowsers) {
        
        for (NSString *urlTemplate in browser.urlTemplates) {
            if ([url containsString:urlTemplate]) {
                resolvedBrowser = browser.applicationName;
                break;
            }
        }
        
        if (resolvedBrowser) break;
    }
    
    if (!resolvedBrowser) {
        resolvedBrowser = browsersConfig.defaultBrowser;
    }
    
    return [[self class] openUrl:url withApplication:resolvedBrowser];
}

+ (BOOL)openUrl:(NSString *)url withApplication:(NSString *)application {
    NSTask *task = [NSTask new];
    [task setLaunchPath:@"/usr/bin/open"];
    [task setArguments:@[@"-a", application, url]];
    
    [task launch];
    [task waitUntilExit];
    
    return [task terminationStatus] == 0;
}

@end
