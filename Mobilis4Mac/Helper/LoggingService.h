//
//  LoggingService.h
//  ACDSenseService4Mac
//
//  Created by Martin Weissbach on 26/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _LogLevel {
    LS_TRACE,
    LS_INFO,
    LS_WARNING,
    LS_ERROR
} LogLevel;

@protocol LoggingServiceDelegate;

@interface LoggingService : NSObject

+ (instancetype)loggingService;

- (void)addDelegate:(id<LoggingServiceDelegate>)delegate;
- (void)removeDelegate:(id<LoggingServiceDelegate>)delegate;

/*!
    Broadcast a given log message with a log level to all registered delegates.
    
    @param  logMessage      The message to be logged.
    @param  logLevel        The importance level of the log message.
 
    @see    LoggingServiceDelegate
 */
- (void)logMessage:(NSString *)logMessage withLevel:(LogLevel)logLevel;

@end

/*!
    All objects registering as log delegates are required to implement the delegate protocol.
 */
@protocol LoggingServiceDelegate <NSObject>

/*!
    This message is sent to all delegates of the LoggingService object.
 
    @param  logMessage      The message to be logged somehow by the delegates.
 */
- (void)logString:(NSAttributedString *)logMessage;

@end