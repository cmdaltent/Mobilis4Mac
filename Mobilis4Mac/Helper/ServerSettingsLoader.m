//
// Created by Martin Weißbach on 10/11/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ServerSettingsLoader.h"


@implementation ServerSettingsLoader

- (BOOL)loadSettings
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    return [self loadSettingsFromFile:fileName];
}

- (BOOL)loadSettingsFromFile:(NSString *)filePath
{
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:filePath];

    self.jabberID = [settings valueForKey:@"jabberID"];
    self.password = [settings valueForKey:@"password"];
    self.hostName = [settings valueForKey:@"hostName"];
    self.port = [NSNumber numberWithInteger:[[settings valueForKey:@"port"] integerValue]];

    return [self areLoadedSettingsValid];
}
- (BOOL)areLoadedSettingsValid
{
    if (    [@"" isEqualToString:self.jabberID] ||
            [@"" isEqualToString:self.password] ||
            [@"" isEqualToString:self.hostName]
    ) {
        return NO;
    }

    return YES;
}


@end