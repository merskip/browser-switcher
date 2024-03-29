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
#import "BSBrowsersConfig.h"

@interface AppDelegate () <NSOutlineViewDelegate, NSOutlineViewDataSource, NSTextFieldDelegate>

@property (nonatomic, assign) BOOL recivedUrl;
@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *defaultBrowserField;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSButton *addUrlTemplateButton;

@property (nonatomic, strong) BSBrowsersConfig *browsersConfig;

@end

@implementation AppDelegate

- (instancetype)init {
    if (self = [super init]) {
        
        self.browsersConfig = [BSBrowsersConfig load];
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
        self.defaultBrowserField.stringValue = self.browsersConfig.defaultBrowser;
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
    
    if (![BSBrowserOpener openUrl:stringUrl]) {
        NSAlert *alert = [NSAlert new];
        alert.alertStyle = NSCriticalAlertStyle;
        alert.messageText = @"Failed open url";
        alert.informativeText = stringUrl;
        [alert runModal];
    }
}

- (IBAction)saveHandler:(id)sender {
    self.browsersConfig.defaultBrowser = self.defaultBrowserField.stringValue;
    if (![self.browsersConfig save]) {
        NSAlert *alert = [NSAlert new];
        alert.alertStyle = NSCriticalAlertStyle;
        alert.messageText = @"Failed save changes";
        [alert runModal];
    }
}

- (IBAction)addBrowserHandler:(id)sender {
    BSBrowserItem *newBrowserItem = [BSBrowserItem browserItemWithName:@"" urlTemplates:@[]];
    [self.browsersConfig.alternativeBrowsers addObject:newBrowserItem];
    [self.outlineView reloadData];
    
    NSUInteger row = [self.outlineView rowForItem:newBrowserItem];
    [self.outlineView expandItem:newBrowserItem expandChildren:YES];
    [self.outlineView editColumn:0 row:row withEvent:[NSApp currentEvent] select:YES];
}

- (IBAction)addUrlTemplateHandler:(id)sender {
    NSInteger row = self.outlineView.selectedRow;
    id item = [self.outlineView itemAtRow:row];
    
    BSBrowserItem *browserItem;
    if ([item isKindOfClass:[BSBrowserItem class]]) {
        browserItem = (BSBrowserItem *)item;
    } else {
        browserItem = [self.outlineView parentForItem:item];
    }
    
    NSString *newUrlTemplate = @"";
    [browserItem.urlTemplates addObject:newUrlTemplate];
    [self.outlineView reloadData];
    
    [self.outlineView editColumn:0 row:[self.outlineView rowForItem:newUrlTemplate] withEvent:[NSApp currentEvent] select:YES];
}


- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if ([item isKindOfClass:[BSBrowserItem class]]) {
        return ((BSBrowserItem *)item).urlTemplates.count;
    }
    return self.browsersConfig.alternativeBrowsers.count;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if ([item isKindOfClass:[BSBrowserItem class]]) {
        return [((BSBrowserItem *)item).urlTemplates objectAtIndex:index];
    }
    return [self.browsersConfig.alternativeBrowsers objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return [item isKindOfClass:[BSBrowserItem class]];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSTableCellView *cellView = [outlineView makeViewWithIdentifier:@"valueCell" owner:self];
    cellView.textField.delegate = self;
    
    if ([item isKindOfClass:[BSBrowserItem class]]) {
        BSBrowserItem *browserItem = (BSBrowserItem *)item;
        cellView.textField.stringValue = browserItem.applicationName;
    } else {
        cellView.textField.stringValue = item;
    }
    
    return cellView;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [[notification object] selectedRow];
    self.addUrlTemplateButton.enabled = (row >= 0);
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *textField = [obj object];
    NSString *newValue = [textField stringValue];
    
    NSUInteger row = [self.outlineView rowForView:textField];
    id item = [self.outlineView itemAtRow:row];
    
    if ([item isKindOfClass:[BSBrowserItem class]]) {
        BSBrowserItem *browserItem = (BSBrowserItem *)item;
        browserItem.applicationName = newValue;
        
        if ([newValue isEqualToString:@""] && browserItem.urlTemplates.count == 0) {
            [self.browsersConfig.alternativeBrowsers removeObject:browserItem];
            [self.outlineView reloadData];
        }
    } else {
        BSBrowserItem *browserItem = [self.outlineView parentForItem:item];
        NSInteger index = [self.outlineView childIndexForItem:item];
        
        [browserItem.urlTemplates replaceObjectAtIndex:index withObject:newValue];
        
        if ([newValue isEqualToString:@""]) {
            [browserItem.urlTemplates removeObjectAtIndex:index];
            [self.outlineView reloadData];
        }
    }
}

@end
