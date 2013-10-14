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

/*!
    Method to deploy a file on the Mobilis Server. The file is supposed to live on the same physical machine.

    @param service  The bundle containing the service supposed to be deployed.
    @param sourceLocation   Points to the place on the disk where the bundle resides before deployment.
 */
- (void)uploadService:(NSBundle *)service fromLocalURL:(NSURL *)sourceLocation;

@end