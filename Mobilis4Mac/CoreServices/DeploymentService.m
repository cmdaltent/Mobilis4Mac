//
// Created by Martin Weißbach on 10/14/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DeploymentService.h"
#import "LoggingService.h"
#import "AdminService.h"
#import "MobilisService.h"

@interface DeploymentService ()

- (BOOL)checkBundle:(NSBundle *)bundle;

@end

@implementation DeploymentService

#pragma mark - Singleton Stack

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    __strong static DeploymentService *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype)initUniqueInstance
{
    return [self init];
}

#pragma mark - Public Interface

- (void)uploadService:(NSBundle *)service
{
    if ([self checkBundle:service]) {
        // TODO: process Bundle and prepare for install

    } else {
        // TODO: handle errors here
    }
}

- (void)uploadService:(NSBundle *)service fromLocalURL:(NSURL *)sourceLocation
{
    if ([self checkBundle:service]) {
        [[AdminService sharedInstance] copyService:[[MobilisService alloc] initWithBundle:service]
                                      fromLocalURL:sourceLocation];
    } else {
        // TODO: handle errors here
        [[LoggingService sharedInstance] logString:@"Bundle invalid"];
    }
}

#pragma mark - Helper Methods

- (BOOL)checkBundle:(NSBundle *)bundle
{
    #warning Unimplemented Method! DeploymentService checkBundle:
    if (!bundle) {
        [[LoggingService sharedInstance] logString:@"The uploaded bundle was nil"];
        return NO;
    }

    return YES;
}

@end