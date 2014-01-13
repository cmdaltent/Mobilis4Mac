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

@interface AppDelegate ()

@property (nonatomic) MobilisRuntime *mobilisRuntime;

@property (nonatomic) MainWindowController *mainWindowController;
@property (nonatomic) UploadWindowController *uploadWindowController;

- (void)setupAndShowMainWindow;

- (IBAction)openUploadServiceWindow:(id)sender;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupAndShowMainWindow];
    
    self.mobilisRuntime = [MobilisRuntime mobilisRuntime];
    [self.mobilisRuntime launchRuntime];
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
    [self.uploadWindowController.window makeKeyAndOrderFront:self];
    [self.uploadWindowController showWindow:self];
}

@end
