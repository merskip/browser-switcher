//
//  BSBrowserOpener.m
//  Browser Resolver
//
//  Created by Piotr Merski on 13.09.2016.
//  Copyright © 2016 Merskip Enterprise. All rights reserved.
//

#import "BSBrowserOpener.h"

@implementation BSBrowserOpener

+ (BOOL)openUrl:(NSString *)url withApplication:(NSString *)application {
    NSTask *task = [NSTask new];
    [task setLaunchPath:@"/usr/bin/open"];
    [task setArguments:@[@"-a", application, url]];
    
    [task launch];
    [task waitUntilExit];
    
    return [task terminationStatus] == 0;
}

@end
