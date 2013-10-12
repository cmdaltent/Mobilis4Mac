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

- (NSString *)appendLineBreak:(NSString *)string;

@end

@implementation LoggingService

static void* KVOContext;

#pragma mark - Singleton Stack

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    __strong static LoggingService *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] initUniqueInstance];
        [self addObserver:shared
               forKeyPath:@"debugMode"
                  options:NSKeyValueObservingOptionNew
                  context:KVOContext];
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
        if (self.debugMode) {
            [self logToConsole:stringMessage];
        }
        [self logToDelegate:stringMessage];
    });
}

#pragma mark - Private Logging Helper

- (void)logToConsole:(NSString *)stringMessage
{
    NSLog(@"%@", [self appendLineBreak:stringMessage]);
}

- (void)logToDelegate:(NSString *)stringMessage
{
    if (self.delegate && stringMessage && ![stringMessage isEqualToString:@""])
        [self.delegate logString:[self appendLineBreak:stringMessage]];
}

#pragma mark - String Modifications

- (NSString *)appendLineBreak:(NSString *)string
{
    return [NSString stringWithFormat:@"%@\n", string];
}

#pragma mark - KVO Compliance

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == KVOContext) {
        [self logString:[NSString stringWithFormat:@"Debug Mode changed to %i", self.debugMode]];
    }
}

@end