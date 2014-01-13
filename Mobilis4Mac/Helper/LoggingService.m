//
//  LoggingService.m
//  ACDSenseService4Mac
//
//  Created by Martin Weissbach on 26/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "LoggingService.h"

@implementation LoggingService
{
    __strong NSPointerArray *_delegates;
}

+ (instancetype)loggingService
{
    static dispatch_once_t onceToken;
    static LoggingService *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [(LoggingService *) [super allocWithZone:NULL] initUnique];
    });
    
    return sharedInstance;
}
- (id)initUnique
{
    _delegates = [NSPointerArray weakObjectsPointerArray];
    return [self init];
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self loggingService];
}

- (void)addDelegate:(id<LoggingServiceDelegate>)delegate
{
    [_delegates addPointer:(__bridge void*)delegate];
}

- (void)removeDelegate:(id<LoggingServiceDelegate>)delegate
{
    NSUInteger index = [self delegateIndex:delegate];
    [_delegates removePointerAtIndex:index];
    [self clearNilAndNullValues];
}
- (NSUInteger)delegateIndex:(id<LoggingServiceDelegate>)delegate
{
    NSUInteger index = 0;
    for (unsigned int i = 0; i < _delegates.count; i++) {
        if (delegate == (__bridge id)[_delegates pointerAtIndex:i]) {
            index = i;
            break;
        }
    }
    return index;
}
- (void)clearNilAndNullValues
{
    [_delegates compact];
    BOOL nilFound = YES;
    while (nilFound) {
        for (unsigned int i = 0; i < _delegates.count; i++)
            if ([_delegates pointerAtIndex:i] == nil) {
                [_delegates removePointerAtIndex:i];
                break;
            }
        nilFound = NO;
    }
}

- (void)logMessage:(NSString *)logMessage withLevel:(LogLevel)logLevel
{
#if DEBUG
    NSLog(@"%@\n", logMessage);
#endif
    NSAttributedString *logString = [[NSAttributedString alloc] initWithString:logMessage
                                                                    attributes:@{NSForegroundColorAttributeName: [self colorForLogLevel:logLevel]}];
    for (id<LoggingServiceDelegate> delegate in _delegates)
        if (delegate != nil && delegate != NULL) {
            [delegate performSelector:@selector(logString:) withObject:logString];
        }
}

- (NSColor *)colorForLogLevel:(LogLevel)level
{
    NSColor *color = [NSColor blackColor];
    switch (level) {
        case LS_ERROR:
            color = [NSColor redColor];
            break;
        case LS_WARNING:
            color = [NSColor orangeColor];
            break;
        case LS_INFO:
            color = [NSColor blueColor];
            break;
        case LS_TRACE:
        default:
            break;
    }
    return color;
}

@end
