//
// Created by Martin Weißbach on 10/14/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class MobilisService;


@interface AdminService : NSObject

+ (instancetype)sharedInstance;

- (void)installService:(MobilisService *)service;

/*!
 Method to upload a service locally to Mobilis.

 @param service     The Mobilis service that is supposed to be installed on the Mobilis server.
 @param location    The original location of the Mobilis service from where it should be installed.
                    This is a complete file path.
 */
- (void)copyService:(MobilisService *)service fromLocalURL:(NSURL *)location;

@end