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
#import "ServiceUploadWindowController.h"

@interface AppDelegate ()

@property (strong, nonatomic) ServiceUploadWindowController *serviceUploadWindowController;

- (void)setupAndShowMainWindow;

- (IBAction)openUploadServiceWindow:(id)sender;

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

#pragma mark - MenuBar Actions

- (IBAction)openUploadServiceWindow:(id)sender {
    if (!self.serviceUploadWindowController) {
        self.serviceUploadWindowController = [[ServiceUploadWindowController alloc] initWithWindowNibName:@"ServiceUploadWindow"];
    }
    [self.serviceUploadWindowController.window makeKeyAndOrderFront:self];
    [self.serviceUploadWindowController showWindow:self];
}

@end
