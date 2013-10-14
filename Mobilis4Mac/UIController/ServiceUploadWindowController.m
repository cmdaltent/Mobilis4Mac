//
//  ServiceUploadWindowController.m
//  Mobilis4Mac
//
//  Created by Martin Weißbach on 10/14/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "ServiceUploadWindowController.h"
#import "MobilisServer.h"
#import "DeploymentService.h"

@interface ServiceUploadWindowController ()

@property (strong, nonatomic) NSURL *bundleURL;

@property (weak) IBOutlet NSTextField *bundleURLTextField;

- (IBAction)chooseBundle:(NSButton *)sender;
- (IBAction)uploadBundle:(NSButton *)sender;

@end

@implementation ServiceUploadWindowController

- (IBAction)chooseBundle:(NSButton *)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:@[@"bundle"]];
    [openPanel setAllowsOtherFileTypes:NO];

    if ([openPanel runModal] == NSFileHandlingPanelOKButton) {
        self.bundleURL = [openPanel URL];
        self.bundleURLTextField.stringValue = [self.bundleURL absoluteString];
    }
}

- (IBAction)uploadBundle:(NSButton *)sender
{
    NSBundle *service = [[NSBundle alloc] initWithURL:self.bundleURL];
    [[[MobilisServer sharedInstance] deploymentService] uploadService:service fromLocalURL:self.bundleURL];

    [self close];
}

@end
