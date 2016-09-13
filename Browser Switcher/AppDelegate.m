//
//  AppDelegate.m
//  Browser Switcher
//
//  Created by Piotr Merski on 13.09.2016.
//  Copyright © 2016 Merskip Enterprise. All rights reserved.
//

#import "AppDelegate.h"
#import "BSBrowserOpener.h"
#import "BSBrowserItem.h"

@interface AppDelegate () <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (nonatomic, assign) BOOL recivedUrl;
@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) NSArray<BSBrowserItem *> *browsers;
@property (weak) IBOutlet NSOutlineView *outlineView;

@end

@implementation AppDelegate

- (instancetype)init {
    if (self = [super init]) {
        _browsers = @[[BSBrowserItem browserItemWithName:@"Google chrome" urlTemplates:@[@"*.leader.biz"]],
                      [BSBrowserItem browserItemWithName:@"Firefox" urlTemplates:@[@"*.wykop.pl", @"facebook.com"]]
                      ];
    }
    return self;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleAppleEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (self.recivedUrl) {
        [[NSApplication sharedApplication] terminate:self];
    } else {
        [self.outlineView expandItem:nil expandChildren:YES];
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

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if ([item isKindOfClass:[BSBrowserItem class]]) {
        return ((BSBrowserItem *)item).urlTemplates.count;
    }
    return self.browsers.count;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if ([item isKindOfClass:[BSBrowserItem class]]) {
        return [((BSBrowserItem *)item).urlTemplates objectAtIndex:index];
    }
    return [self.browsers objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return [item isKindOfClass:[BSBrowserItem class]];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSTableCellView *cellView;
    
    if ([item isKindOfClass:[BSBrowserItem class]]) {
        
        BSBrowserItem *browserItem = (BSBrowserItem *)item;
        
        cellView = [outlineView makeViewWithIdentifier:@"valueCell" owner:self];
        cellView.textField.stringValue = browserItem.applicationName;
    } else {
        cellView = [outlineView makeViewWithIdentifier:@"valueCell" owner:self];
        cellView.textField.stringValue = item;
    }
    
    return cellView;
}

@end
