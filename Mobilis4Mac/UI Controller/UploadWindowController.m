//
//  UploadWindowController.m
//  ACDSenseService4Mac
//
//  Created by Martin Weissbach on 26/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "UploadWindowController.h"
#import "MobilisRuntime.h"
#import "DeploymentService.h"
#import "LoggingService.h"

@interface UploadWindowController ()

@property (weak) IBOutlet NSTextField *bundleLocationTextField;

- (IBAction)openFileChooser:(id)sender;
- (IBAction)installService:(id)sender;

- (void)configureOpenPanel;

@end

@implementation UploadWindowController
{
    __strong NSOpenPanel *_openPanel;
    __strong NSURL *_bundleLocation;
}

- (void)configureOpenPanel
{
    _openPanel = [NSOpenPanel openPanel];
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setAllowedFileTypes:@[@"bundle"]];
    [_openPanel setCanChooseDirectories:NO];
}

#pragma mark - IBAction

- (IBAction)openFileChooser:(id)sender {
    if (!_openPanel) {
        [self configureOpenPanel];
    }
    
    if ([_openPanel runModal] == NSOKButton) {
        _bundleLocation = [_openPanel URL];
        [self.bundleLocationTextField setStringValue:[_bundleLocation absoluteString]];
    }
}

- (IBAction)installService:(id)sender {
    if ([[self.bundleLocationTextField stringValue] isEqualToString:@""]) return;

    NSURL *localFileURL = [NSURL URLWithString:[self.bundleLocationTextField stringValue]];
    __autoreleasing NSError *error = nil;
    NSURL *installLocation = [[MobilisRuntime mobilisRuntime].deploymentService installLocalFile:localFileURL error:&error];
    if (error) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"File Installation Error"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Check the Error console for additional information"];
        alert.alertStyle = NSCriticalAlertStyle;
        [alert runModal];
    } else {
        [[LoggingService loggingService] logMessage:[NSString stringWithFormat:@"Installed to location: %@", [installLocation absoluteString]]
                                          withLevel:LS_INFO];
        [[MobilisRuntime mobilisRuntime] loadServiceAtLocation:installLocation];
        [self close];
    }
}

@end
