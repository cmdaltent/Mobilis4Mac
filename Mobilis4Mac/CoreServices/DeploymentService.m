//
// Created by Martin Weißbach on 10/14/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DeploymentService.h"


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
        // TODO: throw an exception here.
    }
}
- (BOOL)checkBundle:(NSBundle *)bundle
{
    #warning Unimplemented Method! DeploymentService checkBundle:
    return YES;
}

@end