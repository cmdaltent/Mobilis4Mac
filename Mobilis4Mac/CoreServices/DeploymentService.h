//
// Created by Martin Weißbach on 10/14/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface DeploymentService : NSObject

+ (instancetype)sharedInstance;

- (void)uploadService:(NSBundle *)service;

@end