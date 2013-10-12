//
// Created by Martin Weißbach on 10/11/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface ServerSettingsLoader : NSObject

@property (strong, nonatomic) NSString *jabberID;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *hostName;
@property (strong, nonatomic) NSNumber *port;

- (BOOL)loadSettings;
- (BOOL)loadSettingsFromFile:(NSString *)filePath;

@end