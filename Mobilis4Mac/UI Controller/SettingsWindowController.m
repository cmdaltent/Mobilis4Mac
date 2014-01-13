//
//  SettingsWindowController.m
//  Mobilis4Mac
//
//  Created by Martin Weissbach on 13/01/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import "SettingsWindowController.h"

@interface SettingsWindowController ()

@property (weak) IBOutlet NSTextField *jidTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;
@property (weak) IBOutlet NSTextField *hostnameTextField;
@property (weak) IBOutlet NSButton *debugModeSwitch;

- (IBAction)connect:(id)sender;

@end

@implementation SettingsWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - IBAction

- (IBAction)connect:(id)sender {
}
@end
