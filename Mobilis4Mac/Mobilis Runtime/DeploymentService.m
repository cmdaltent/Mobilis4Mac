//
//  DeploymentService.m
//  ACDSenseService4Mac
//
//  Created by Martin Weissbach on 27/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "DeploymentService.h"
#import "LoggingService.h"

@implementation DeploymentService

#pragma mark - Public Interface

- (NSURL *)installLocalFile:(NSURL *)fileURL error:(NSError * __autoreleasing *)error
{
    NSString *fileName = [fileURL lastPathComponent];

    NSError *applicationDirectoryError = nil;
    NSURL *applicationSupportDirectory = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                                inDomain:NSUserDomainMask
                                                                       appropriateForURL:nil
                                                                                  create:YES
                                                                                   error:&applicationDirectoryError];
    if (applicationDirectoryError) {
        [[LoggingService loggingService] logMessage:@"ApplicationSupport Directory could not be opened." withLevel:LS_ERROR];
        *error = applicationDirectoryError;
        return nil;
    }

    NSURL *serviceDirectory = [applicationSupportDirectory URLByAppendingPathComponent:@"MobilisRuntime/services" isDirectory:YES];
    NSURL *serviceDirectoryBundleLocation = [serviceDirectory URLByAppendingPathComponent:fileName];

    BOOL serviceDirectoryExists = NO;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:[serviceDirectory absoluteString] isDirectory:&serviceDirectoryExists] && serviceDirectoryExists)) {
        NSError *createServicesDirectoryError = nil;
        [[NSFileManager defaultManager] createDirectoryAtURL:serviceDirectory
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&createServicesDirectoryError];
        if (createServicesDirectoryError) {
            [[LoggingService loggingService] logMessage:@"Services Directory could not be created." withLevel:LS_ERROR];
            *error = createServicesDirectoryError;
            return nil;
        }
    }

    [[NSFileManager defaultManager] copyItemAtURL:fileURL toURL:serviceDirectoryBundleLocation error:NULL];
    return serviceDirectoryBundleLocation;
}

@end
