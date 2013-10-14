//
// Created by Martin Weißbach on 10/11/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class DeploymentService;
@class AdminService;


@interface MobilisServer : NSObject

@property (strong, nonatomic, readonly) DeploymentService *deploymentService;
@property (strong, nonatomic, readonly) AdminService *adminService;

+ (instancetype)sharedInstance;

- (void)launchServer;

- (void)shutdownServer;
@end