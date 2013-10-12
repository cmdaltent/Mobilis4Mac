//
// Created by Martin Weißbach on 10/12/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LoggingService.h"

@interface LoggingService ()

- (void)logToConsole:(NSString *)stringMessage;
- (void)logToDelegate:(NSString *)stringMessage;

@end

@implementation LoggingService

#pragma mark - Singleton Stack

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    __strong static LoggingService *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype)initUniqueInstance
{
    return [self init];
}

#pragma mark - Public Interface Implementation

- (void)logString:(NSString *)stringMessage
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self logToConsole:stringMessage];
        [self logToDelegate:stringMessage];
    });
}

#pragma mark - Private Helper

- (void)logToConsole:(NSString *)stringMessage
{
    NSLog(@"%@", stringMessage);
}

- (void)logToDelegate:(NSString *)stringMessage
{
    if (self.delegate && stringMessage && ![stringMessage isEqualToString:@""])
        [self.delegate logString:stringMessage];
}

@end