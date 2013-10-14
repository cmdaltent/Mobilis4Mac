//
// Created by Martin Weißbach on 10/14/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AdminService.h"
#import "MobilisService.h"
#import "LoggingService.h"


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

#pragma mark - Public Interface

- (void)installService:(MobilisService *)service
{
#warning Incomplete Implementation! AdminService installService:
}

- (void)copyService:(MobilisService *)service fromLocalURL:(NSURL *)location
{
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtURL:location
                                            toURL:[self serviceLocation:[service serviceName]]
                                            error:&error];
    if (error) {
        [[LoggingService sharedInstance] logString:@"Service could not be copied to destination folder"];
    } else {
        [[LoggingService sharedInstance] logString:[NSString stringWithFormat:@"Service installation successfull at %@", [self serviceLocation:[service serviceName]]]];
    }
}

- (NSURL *)serviceLocation:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *path = nil;
    if (paths.count >= 1) {
        path = paths[0];
    }


    NSString *resolvedPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"MobilisServer/Services/%@.bundle", name]];

    return [[NSURL alloc] initFileURLWithPath:resolvedPath isDirectory:YES];
}


@end