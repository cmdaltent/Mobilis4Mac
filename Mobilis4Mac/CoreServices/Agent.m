//
// Created by Martin Weißbach on 10/11/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Agent.h"
#import "ConnectionHandler.h"

@implementation Agent

- (id)initWithJabberID:(NSString *)jabberID password:(NSString *)password hostName:(NSString *)hostName port:(NSNumber *)port
{
    self = [super init];
    if (self) {
        _connectionHandler = [ConnectionHandler connectionWithJabberID:jabberID
                                                              password:password
                                                              hostName:hostName
                                                                  port:port];
    }

    return self;
}

- (void)terminate
{
    [self.connectionHandler closeConnection];
}
@end