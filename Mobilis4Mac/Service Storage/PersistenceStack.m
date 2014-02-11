//
//  PerstistenceStack.m
//  Mobilis4Mac
//
//  Created by Martin Weissbach on 03/02/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import "PersistenceStack.h"
#import "LoggingService.h"

@interface PersistenceStack ()

@property (nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;

@end

@implementation PersistenceStack

+ (instancetype)persistenceStack
{
    static PersistenceStack *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[super allocWithZone:NULL] initUnique];
    });
    return __sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self persistenceStack];
}

- (id)initUnique
{
    self = [super init];
    if (self) {
        [self setupPersistenceStack];
    }
    return self;
}

- (void)setupPersistenceStack
{
    NSError *error = nil;
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error];
    if (error)
    {
        [[LoggingService loggingService] logMessage:@"Could not load Persistence Stack." withLevel:LS_ERROR];
    }
}
- (NSManagedObjectModel *)managedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ServiceStorage"
                                                                                       withExtension:@"momd"]];
}
- (NSURL *)storeURL
{
    NSURL *applicationSupportURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                          inDomain:NSUserDomainMask
                                                                 appropriateForURL:nil
                                                                            create:YES
                                                                             error:nil];
    NSURL *runtimeURL = [[applicationSupportURL URLByAppendingPathComponent:@"MobilisRuntime"] URLByAppendingPathComponent:@"persistence"];
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:runtimeURL
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:nil];
    if (!success)
    {
        [[LoggingService loggingService] logMessage:@"Could not create persistence directory. Make sure you the application has write access for '~/Library/Application Support'"
                                          withLevel:LS_ERROR];
    }
    return [runtimeURL URLByAppendingPathComponent:@"mobilis.sqlite"];
}

@end
