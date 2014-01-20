//
//  MobilisRuntime.m
//  ACDSenseService4Mac
//
//  Created by Martin Weissbach on 27/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <MobilisMXi/MXi/MXiConnectionHandler.h>
#import <MobilisMXi/MXi/Account.h>
#import <MobilisMXi/MXi/DefaultSettings.h>
#import <MobilisMXi/MXi/MXiBeanConverter.h>
#import "MXiConnectionHandler.h"
#import <MobilisMXi/MXi/AccountManager.h>
#import <objc/runtime.h>
#import "DeploymentService.h"
#import "MobilisRuntime.h"
#import "LoggingService.h"
#import "MobilisService.h"
#import "SynchronizeRuntimeBean.h"
#import "SettingsManager.h"
#import "InbandRegistration.h"
#import "MainWindowController.h"

@interface MobilisRuntime () <MXiConnectionHandlerDelegate>

@property (nonatomic, readwrite) MXiConnectionHandler *connectionHandler;
@property (nonatomic, readwrite) DeploymentService *deploymentService;

@property (nonatomic) NSMutableArray *startedServices;

@end

@implementation MobilisRuntime

#pragma mark - Singleton Stack

+ (instancetype)mobilisRuntime
{
    static dispatch_once_t singleton_token;
    __strong static MobilisRuntime *sharedInstance = nil;
    dispatch_once(&singleton_token, ^
    {
        sharedInstance = [(MobilisRuntime *) [super allocWithZone:NULL] initUnique];
    });

    return sharedInstance;
}

- (instancetype)initUnique
{
    self.connectionHandler = [MXiConnectionHandler sharedInstance];
    self.connectionHandler.delegate = self;

    self.deploymentService = [DeploymentService new];

    self.startedServices = [NSMutableArray arrayWithCapacity:5];

    return [self init];
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self mobilisRuntime];
}

#pragma mark - Public Interface

- (void)launchRuntime
{
    Account *account = [AccountManager account];
    [self.connectionHandler launchConnectionWithJID:account.jid
                                           password:account.password
                                           hostName:account.hostName
                                        serviceType:RUNTIME
                                               port:account.port];
}

- (void)shutdownRuntime
{
    [self.connectionHandler.connection disconnect];
}

- (void)loadServiceAtLocation:(NSURL *)urlToBundle
{
    NSBundle *serviceBundle = [NSBundle bundleWithURL:urlToBundle];
    if (![[class_getSuperclass([serviceBundle principalClass]) className] isEqualToString:[MobilisService className]]) {
        [[LoggingService loggingService] logMessage:@"Service Bundle's principal class is invalid."
                                          withLevel:LS_ERROR];
        return;
    }

    InbandRegistration *inbandRegistration = [[InbandRegistration alloc] initInbandRegistrationWithUsername:@"testService"
                                                                                                   password:@"123456"];
    [inbandRegistration launchRegistrationWithCompletionBlock:^(NSError *error)
    {
        SettingsManager *settingsManager = [SettingsManager new];
        MobilisService *service = [((MobilisService *)[[serviceBundle principalClass] alloc]) initServiceWithJID:[XMPPJID jidWithString:@"testservice@localhost"]
                                                                                                        password:@"123456"
                                                                                                        hostName:settingsManager.account.hostName
                                                                                                            port:settingsManager.account.port];
        [self.startedServices addObject:service];
        [[LoggingService loggingService] logMessage:@"Service Installation successful" withLevel:LS_INFO];
    }];
//    [self synchronize];
}

- (void)synchronize
{
    NSMutableArray *serviceJIDs = [NSMutableArray arrayWithCapacity:self.startedServices.count];
    for (MXiService *service in self.startedServices)
        [serviceJIDs addObject:service.jid.full];

    // FIXME: retrieve remote runtime address from user's roster
    SynchronizeRuntimeBean *synchronizeRuntimeBean = [SynchronizeRuntimeBean syncrhonizeServices:[NSArray arrayWithArray:serviceJIDs]
                                                                               withRemoteRuntime:@"mobilis@localhost/Deployment"];
    [synchronizeRuntimeBean setServiceJIDs:serviceJIDs];
    [[MXiConnectionHandler sharedInstance] sendElement:[MXiBeanConverter beanToIQ:synchronizeRuntimeBean]];
}

#pragma mark - MXiConnectionHandlerDelegate

- (void)authenticationFinishedSuccessfully:(BOOL)authenticationState
{
    // TODO: Launch uploaded services here.
}

- (void)connectionDidDisconnect:(NSError *)error
{
    [[LoggingService loggingService] logMessage:[NSString stringWithFormat:@"connectionDidDisconnect: %@",error]
                                      withLevel:LS_ERROR];
}

- (void)serviceDiscoveryError:(NSError *)error
{
    [[LoggingService loggingService] logMessage:[NSString stringWithFormat:@"serviceDiscoveryError: %@", error]
                                      withLevel:LS_ERROR];
}

@end
