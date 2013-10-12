//
// Created by Martin Weißbach on 10/11/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MobilisServer.h"

#import "ServerSettingsLoader.h"
#import "Agent.h"

@interface MobilisServer ()

@property (strong) Agent *agent;

- (void)loadServerSettings;

@end

@implementation MobilisServer

- (void)launchServer
{
#warning The launchServer method is not completely implemented!
    [self loadServerSettings];

    NSLog(@"Conection establishement launched.");
}

#pragma mark - Startup Helper

- (void)loadServerSettings
{
    ServerSettingsLoader *serverSettingsLoader = [ServerSettingsLoader new];
    if (![serverSettingsLoader loadSettings]) {
        @throw [NSException exceptionWithName:@"Severe Error"
                                       reason:@"Server Settings could not be loaded"
                                     userInfo:nil];
    }
    [self setupAgentWithLoadedSettings:serverSettingsLoader];
}
- (void)setupAgentWithLoadedSettings:(ServerSettingsLoader *)loader
{
    self.agent = [[Agent alloc] initWithJabberID:loader.jabberID
                                        password:loader.password
                                        hostName:loader.hostName
                                            port:loader.port];
}

@end