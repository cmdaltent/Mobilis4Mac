//
// Created by Martin Weißbach on 10/12/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol LoggingServiceDelegate

- (void)logString:(NSString *)logMessageAsString;

@end

@interface LoggingService : NSObject

@property (weak, nonatomic) id<LoggingServiceDelegate> delegate;

+ (instancetype)sharedInstance;

- (id)initUniqueInstance;

- (void)logString:(NSString *)stringMessage;

@end