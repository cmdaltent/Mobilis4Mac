//
// Created by Martin Weissbach on 2/11/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXiConnection;


@interface MobilisRoster : NSObject

- (id)initWithConnection:(MXiConnection *)connection;

- (void)updateRoster;

/*!
    Retrieve all remote Runtime objects registered with the receiver's runtime's roster.
 */
- (NSArray *)remoteMobilisRuntimes;

@end