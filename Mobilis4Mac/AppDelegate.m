//
//  AppDelegate.m
//  Mobilis4Mac
//
//  Created by Martin Weißbach on 10/11/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "AppDelegate.h"

#import "MainWindowController.h"

#import "MobilisServer.h"

@interface AppDelegate ()

- (void)setupAndShowMainWindow;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupAndShowMainWindow];
    
    self.mobilisServer = [MobilisServer new];
    [self.mobilisServer launchServer];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self.mobilisServer shutdownServer];
}

#pragma mark - User Interface Handling

- (void)setupAndShowMainWindow
{
    self.mainWindowController = [[MainWindowController alloc] initWithWindowNibName:@"MainWindow"];
    [self.mainWindowController.window makeKeyAndOrderFront:self];
    [self.mainWindowController showWindow:self];
}

@end
