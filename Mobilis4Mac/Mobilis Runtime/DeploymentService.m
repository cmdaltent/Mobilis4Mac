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

    NSURL *applicationSupportDirectory = [self applicationSupportDirectory];
    if (!applicationSupportDirectory) {
        (*error) = [NSError errorWithDomain:@"Service Upload" code:1001 userInfo:nil];
        return nil;
    }

    NSURL *serviceDirectory = [self serviceDirectory:applicationSupportDirectory];
    NSURL *serviceDirectoryBundleLocation = [self bundleLocation:serviceDirectory fileName:fileName];

    if (![self serviceDirectoryExists:serviceDirectory]) return nil;
    if (![self removeOldService:serviceDirectoryBundleLocation]) return nil;

    [[NSFileManager defaultManager] copyItemAtURL:fileURL toURL:serviceDirectoryBundleLocation error:NULL];

    return serviceDirectoryBundleLocation;
}

- (NSURL *)installUploadedBundle:(NSData *)bundleData withFileName:(NSString *)fileName error:(NSError * __autoreleasing *)error
{
    NSURL *applicationSupportDirectory = [self applicationSupportDirectory];
    if (!applicationSupportDirectory) {
        (*error) = [NSError errorWithDomain:@"Service Upload" code:1001 userInfo:nil];
        return nil;
    }

    NSURL *serviceDirectory = [self serviceDirectory:applicationSupportDirectory];
    NSURL *serviceDirectoryBundleLocation = [self bundleLocation:serviceDirectory fileName:fileName];

    if (![self serviceDirectoryExists:serviceDirectory]) return nil;
    if (![self removeOldService:serviceDirectoryBundleLocation]) return nil;

    NSError *writeError = nil;
    [bundleData writeToURL:serviceDirectoryBundleLocation
                   options:NSDataWritingAtomic
                     error:&writeError];
    if (writeError)
    {
        [[LoggingService loggingService] logMessage:@"Uploaded service could not be stored." withLevel:LS_ERROR];
        return nil;
    }

    return serviceDirectoryBundleLocation;
}

#pragma mark - Private Interface

- (NSURL *)applicationSupportDirectory
{
    NSError *error = nil;
    NSURL *applicationSupportDirectory = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                                inDomain:NSUserDomainMask
                                                                       appropriateForURL:nil
                                                                                  create:YES
                                                                                   error:&error];
    if (error) {
        [[LoggingService loggingService] logMessage:@"ApplicationSupport Directory could not be opened." withLevel:LS_ERROR];
        return nil;
    }
    return applicationSupportDirectory;
}

- (NSURL *)serviceDirectory:(NSURL *)applicationSupportDirectory
{
    return [applicationSupportDirectory URLByAppendingPathComponent:@"MobilisRuntime/services" isDirectory:YES];
}

- (NSURL *)bundleLocation:(NSURL *)serviceDirectory fileName:(NSString *)fileName
{
    return [serviceDirectory URLByAppendingPathComponent:fileName];
}

- (BOOL)serviceDirectoryExists:(NSURL *)serviceDirectory
{
    BOOL serviceDirectoryExists = NO;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:[serviceDirectory absoluteString] isDirectory:&serviceDirectoryExists] && serviceDirectoryExists)) {
        NSError *createServicesDirectoryError = nil;
        [[NSFileManager defaultManager] createDirectoryAtURL:serviceDirectory
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&createServicesDirectoryError];
        if (createServicesDirectoryError) {
            [[LoggingService loggingService] logMessage:@"Services Directory could not be created." withLevel:LS_ERROR];
            return NO;
        }
    }
    return YES;
}

- (BOOL)removeOldService:(NSURL *)serviceBundleLocation
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[serviceBundleLocation absoluteString]]) {
        NSError *removeError = nil;
        [[NSFileManager defaultManager] removeItemAtURL:serviceBundleLocation error:&removeError];
        if (removeError) {
            [[LoggingService loggingService] logMessage:@"Service could not be updated." withLevel:LS_ERROR];
            return NO;
        }
    }
    return YES;
}

@end
