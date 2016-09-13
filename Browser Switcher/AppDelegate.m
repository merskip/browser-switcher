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

@interface AppDelegate () <NSOutlineViewDelegate, NSOutlineViewDataSource, NSTextFieldDelegate>

@property (nonatomic, assign) BOOL recivedUrl;
@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) NSMutableArray<BSBrowserItem *> *browsers;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSButton *addUrlTemplateButton;

@end

@implementation AppDelegate

- (instancetype)init {
    if (self = [super init]) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *browersData = [userDefaults objectForKey:@"browers"];
        NSMutableArray<BSBrowserItem *> *browers = [NSKeyedUnarchiver unarchiveObjectWithData:browersData];
        
        _browsers = [NSMutableArray arrayWithArray:browers];
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

- (IBAction)saveHandler:(id)sender {
    NSData *browersData = [NSKeyedArchiver archivedDataWithRootObject:self.browsers];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:browersData forKey:@"browers"];
    if (![userDefaults synchronize]) {
        NSAlert *alert = [NSAlert new];
        alert.alertStyle = NSCriticalAlertStyle;
        alert.messageText = @"Failed save changes";
        [alert runModal];
    }
}


- (IBAction)addBrowserHandler:(id)sender {
    BSBrowserItem *newBrowserItem = [BSBrowserItem browserItemWithName:@"" urlTemplates:@[]];
    [self.browsers addObject:newBrowserItem];
    [self.outlineView reloadData];
    
    NSUInteger row = [self.outlineView rowForItem:newBrowserItem];
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
            [self.browsers removeObject:browserItem];
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
