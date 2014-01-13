//
// Created by Martin Weissbach on 13/01/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <MobilisMXi/MXi/Account.h>
#import "SettingsManager.h"
#import "AccountManager.h"

@implementation SettingsManager

- (id)init
{
    self = [super init];
    if (self) {
        self.account = [AccountManager account];
    }

    return self;
}

- (void)setAccount:(Account *)account
{
    if (_account == account) return;

    _account = account;
    [AccountManager storeAccount:account];
}

- (BOOL)areSettingsValid
{
    return _account.jid && _account.password && _account.hostName;
}

@end