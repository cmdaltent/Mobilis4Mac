//
//  ServiceUploadWindowController.m
//  Mobilis4Mac
//
//  Created by Martin Weißbach on 10/14/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "ServiceUploadWindowController.h"

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
    #warning ServiceUploadWindowController uploadBundle: not implemented.
    // TODO: implement ServiceUploadWindowController uploadBundle:
}

@end
