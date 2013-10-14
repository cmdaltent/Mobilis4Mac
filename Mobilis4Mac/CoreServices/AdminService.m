//
// Created by Martin Weißbach on 10/14/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AdminService.h"


@implementation AdminService

#pragma mark - Singleton Stack

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    __strong static AdminService *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype)initUniqueInstance
{
    return [self init];
}

@end