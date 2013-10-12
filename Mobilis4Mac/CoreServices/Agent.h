//
// Created by Martin Weißbach on 10/11/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class ConnectionHandler;


@interface Agent : NSObject

@property (strong, nonatomic, readonly) ConnectionHandler *connectionHandler;

- (id)initWithJabberID:(NSString *)jabberID password:(NSString *)password hostName:(NSString *)hostName port:(NSNumber *)port;

@end