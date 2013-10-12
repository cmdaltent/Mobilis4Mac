//
// Created by Martin Weißbach on 10/11/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class XMPPJID;

@interface ConnectionHandler : NSObject

@property (strong, nonatomic) XMPPJID *jabberID;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *hostName;
@property (strong, nonatomic) NSNumber *port;

+ (id)connectionWithJabberID:(NSString *)jabberID password:(NSString *)password hostName:(NSString *)hostName port:(NSNumber *)port;

- (id)initConnectionWithJabberID:(NSString *)jabberID password:(NSString *)password hostName:(NSString *)hostName port:(NSNumber *)port;

@end