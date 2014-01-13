//
// Created by Martin Weissbach on 13/01/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;


@interface SettingsManager : NSObject

@property (nonatomic) Account *account;

- (BOOL)areSettingsValid;
@end