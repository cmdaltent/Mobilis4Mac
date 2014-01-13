//
//  AppDelegate.m
//  Mobilis4Mac
//
//  Created by Martin Weißbach on 10/11/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "AppDelegate.h"

#import "MainWindowController.h"

#import "UploadWindowController.h"
#import "MobilisRuntime.h"
#import "SettingsManager.h"
#import "SettingsWindowController.h"
#import "LoggingService.h"

@interface AppDelegate ()

@property (nonatomic) MobilisRuntime *mobilisRuntime;

@property (nonatomic) MainWindowController *mainWindowController;
@property (nonatomic) UploadWindowController *uploadWindowController;
@property (nonatomic) SettingsWindowController *settingsWindowController;

- (void)setupAndShowMainWindow;

- (IBAction)openUploadServiceWindow:(id)sender;
- (IBAction)openSettingsWindow:(id)sender;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupAndShowMainWindow];

    SettingsManager *settingsManager = [SettingsManager new];
    if ([settingsManager areSettingsValid]) {

        self.mobilisRuntime = [MobilisRuntime mobilisRuntime];
        [self.mobilisRuntime launchRuntime];
    } else {
        [[LoggingService loggingService] logMessage:@"Incomplete or invalid credentials. Store XMPP account information first."
                                          withLevel:LS_ERROR];
        [self openSettingsWindow:self];
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self.mobilisRuntime shutdownRuntime];
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
    if (!self.uploadWindowController) {
        self.uploadWindowController = [[UploadWindowController alloc] initWithWindowNibName:@"UploadWindow"];
    }
    [self.uploadWindowController.window makeKeyAndOrderFront:sender];
    [self.uploadWindowController showWindow:sender];
}

- (IBAction)openSettingsWindow:(id)sender
{
    if (!self.settingsWindowController) {
        self.settingsWindowController = [[SettingsWindowController alloc] initWithWindowNibName:@"SettingsWindow"];
    }
    [self.settingsWindowController.window makeKeyAndOrderFront:sender];
    [self.settingsWindowController showWindow:sender];
}

@end
