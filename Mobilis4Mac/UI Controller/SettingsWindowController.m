//
//  SettingsWindowController.m
//  Mobilis4Mac
//
//  Created by Martin Weissbach on 13/01/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <MobilisMXi/MXi/Account.h>
#import "SettingsWindowController.h"
#import "SettingsManager.h"
#import "MobilisRuntime.h"

@interface SettingsWindowController ()

@property (strong, nonatomic) SettingsManager *settingsManager;

@property (weak) IBOutlet NSTextField *jidTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;
@property (weak) IBOutlet NSTextField *hostnameTextField;
@property (weak) IBOutlet NSTextField *portTextField;

- (IBAction)connect:(id)sender;

@end

@implementation SettingsWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.settingsManager = [SettingsManager new];
    [self setupFields];
}

#pragma mark - IBAction

- (IBAction)connect:(id)sender {
    if ([self areAllFieldsValid]) {
        [self storeSettings];

        [[MobilisRuntime mobilisRuntime] launchRuntime];
    }
}

#pragma mark - Private Helper

- (BOOL)areAllFieldsValid
{
    NSString *empty = @"";
    if (    [empty isEqualToString:_jidTextField.stringValue] ||
            [empty isEqualToString:_passwordTextField.stringValue] ||
            [empty isEqualToString:_hostnameTextField.stringValue] ||
            [empty isEqualToString:_portTextField.stringValue]) {
        return NO;
    } else return YES;
}

- (void)storeSettings
{
    Account *newAccount = [Account new];
    newAccount.jid = _jidTextField.stringValue;
    newAccount.password = _passwordTextField.stringValue;
    newAccount.hostName = _hostnameTextField.stringValue;
    newAccount.port = [NSNumber numberWithInt:_portTextField.intValue];

    _settingsManager.account = newAccount;
}

- (void)setupFields
{
    Account *account = _settingsManager.account;
    _jidTextField.stringValue = account.jid;
    _passwordTextField.stringValue = account.password;
    _hostnameTextField.stringValue = account.hostName;
    _portTextField.stringValue = [account.port stringValue];
}
@end
