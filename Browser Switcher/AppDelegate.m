//
//  AppDelegate.m
//  Browser Switcher
//
//  Created by Piotr Merski on 13.09.2016.
//  Copyright © 2016 Merskip Enterprise. All rights reserved.
//

#import "AppDelegate.h"
#import "BSBrowserOpener.h"

@interface AppDelegate ()

@property (nonatomic, assign) BOOL recivedUrl;
@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleAppleEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (self.recivedUrl) {
        [[NSApplication sharedApplication] terminate:self];
    } else {
        
        NSAlert *alert = [NSAlert new];
        alert.informativeText = [NSString stringWithFormat:@"Run for configuration: pid=%d", [NSProcessInfo processInfo].processIdentifier];
        [alert runModal];
        
        [self.window setIsVisible:YES];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replayEvent {
    NSString *stringUrl = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    [self openUrl:stringUrl];
    self.recivedUrl = YES;
}

- (void)openUrl:(NSString *)stringUrl {
    
    if ([stringUrl containsString:@"eleader.biz"]) {
        
        [BSBrowserOpener openUrl:stringUrl withApplication:@"Safari"];
        
    } else {
        [[NSWorkspace sharedWorkspace] openFile:stringUrl withApplication:@"/Applications/Google Chrome.app"];
    }
}


@end
