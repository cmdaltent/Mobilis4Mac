//
//  MobilisRuntime.m
//  ACDSenseService4Mac
//
//  Created by Martin Weissbach on 27/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <MobilisMXi/MXi/MXiConnectionHandler.h>
#import <MobilisMXi/MXi/Account.h>
#import <MobilisMXi/MXi/MXiBeanConverter.h>
#import <MobilisMXi/MXi/AccountManager.h>
#import <objc/runtime.h>
#import "DeploymentService.h"
#import "MobilisRuntime.h"
#import "LoggingService.h"
#import "MobilisService.h"
#import "SynchronizeRuntimeBean.h"
#import "SettingsManager.h"
#import "InbandRegistration.h"
#import "TURNSocket.h"
#import "MobilisSocket.h"

@interface MobilisRuntime () <MXiConnectionHandlerDelegate, TURNSocketDelegate, MobilisSocketDelegate>

@property (nonatomic, readwrite) MXiConnectionHandler *connectionHandler;
@property (nonatomic, readwrite) DeploymentService *deploymentService;

@property (nonatomic) NSMutableArray *startedServices;

/// Will be set to YES, when a file transfer has been negotiated according XEP-0096
@property(nonatomic) BOOL isExpectingFileTransfer;

@end

@implementation MobilisRuntime {
    __strong MobilisSocket *_currentSocketConnection;
    NSString *_currentUploadFileName;
}

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
    self.isExpectingFileTransfer = NO;

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
    // TODO enable synchronize again
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
    if (!authenticationState) {
        [[LoggingService loggingService] logMessage:[NSString stringWithFormat:@"Authentication of user %@ failed", self.connectionHandler.connection.jabberID.full]
                                          withLevel:LS_ERROR];

        return;
    }

    [[LoggingService loggingService] logMessage:[NSString stringWithFormat:@"Connected as %@", self.connectionHandler.connection.jabberID.full]
                                      withLevel:LS_INFO];
    // TODO: Launch uploaded services here.
    [self.connectionHandler.connection addStanzaDelegate:self
                                            withSelector:@selector(iqStanzaReceived:)
                                        forStanzaElement:IQ];
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

#pragma mark - TURNSocketDelegate

- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket
{
    self.isExpectingFileTransfer = NO;
    [[LoggingService loggingService] logMessage:@"Service Upload successful" withLevel:LS_INFO];

    [_currentSocketConnection readFileWithSize:200488];

//    _currentSocketConnection = nil;
}

- (void)turnSocketDidFail:(TURNSocket *)sender
{
    self.isExpectingFileTransfer = NO;
    [[LoggingService loggingService] logMessage:@"Service Upload failed." withLevel:LS_ERROR];
    _currentSocketConnection = nil;
}

#pragma mark - MobilisSocketDelegate

- (void)fileTransferSuccessful:(BOOL)success
{
    if (success)
    {
        __autoreleasing NSError *error = nil;
        [[DeploymentService new] installUploadedBundle:_currentSocketConnection.fileData
                                          withFileName:_currentUploadFileName
                                                 error:&error];
    }
}

#pragma mark - IQ Stanza Delegate

- (void)iqStanzaReceived:(XMPPIQ *)xmppiq
{
    if ([xmppiq isSetIQ] && [[xmppiq childElement].name isEqualToString:@"prepareServiceUpload"])
        [self processServiceUploadRequest:xmppiq];
    if ([xmppiq isSetIQ] && [[xmppiq childElement].name isEqualToString:@"si"])
        [self processSessionInitiationOffer:xmppiq];
    if (self.isExpectingFileTransfer && [xmppiq isSetIQ] && [[xmppiq childElement].name isEqualToString:@"query"]) {
        @try {
        _currentSocketConnection = [[MobilisSocket alloc] initWithStream:self.connectionHandler.connection.xmppStream
                                                     incomingTURNRequest:xmppiq];
        _currentSocketConnection.delegate = self;
        } @catch (NSException *exception) {
            [self.connectionHandler sendElement:[self createBadRequestResponseForIQ:xmppiq]];
            return;
        }
        [_currentSocketConnection startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    if ([xmppiq isGetIQ] && [[[[[xmppiq childElement] namespaces] firstObject] stringValue] isEqualToString:@"http://jabber.org/protocol/disco#info"])
        [self respondToDiscoInfo:xmppiq];
}

#pragma mark - XMPP native IQ Results

- (void)respondToDiscoInfo:(XMPPIQ *)discoInfoRequest
{
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    NSXMLElement *identity = [NSXMLElement elementWithName:@"identity"];
    [identity addAttributeWithName:@"type" stringValue:@"mac"];
    [identity addAttributeWithName:@"name" stringValue:@"XMPPFramework"];
    [identity addAttributeWithName:@"category" stringValue:@"client"];

    [query addChild:identity];
    [query addChild:[NSXMLElement elementWithName:@"feature" attributeName:@"var" attributeValue:@"http://jabber.org/protocol/si"]];
    [query addChild:[NSXMLElement elementWithName:@"feature" attributeName:@"var" attributeValue:@"http://jabber.org/protocol/si/profile/file-transfer"]];
    // FIXME: Next line: return disco String according Philips DA. Entity Capabilies.
    [query addChild:[NSXMLElement elementWithName:@"feature" attributeName:@"var" attributeValue:@"http://mobilis.inf.tu-dresden.de/instance#servicenamespace=,version=1,name=Obj-C Runtime Service,rt=mobilis@localhost"]];
    [query addChild:[NSXMLElement elementWithName:@"feature" attributeName:@"var" attributeValue:@"http://jabber.org/protocol/disco#info"]];
    [query addChild:[NSXMLElement elementWithName:@"feature" attributeName:@"var" attributeValue:@"http://jabber.org/protocol/disco#items"]];
    [query addChild:[NSXMLElement elementWithName:@"feature" attributeName:@"var" attributeValue:@"http://jabber.org/protocol/bytestreams"]];
    [query addChild:[NSXMLElement elementWithName:@"feature" attributeName:@"var" attributeValue:@"urn:xmpp:ping"]];

    XMPPIQ *iq = [XMPPIQ iqWithType:@"result"
                                 to:discoInfoRequest.from
                          elementID:discoInfoRequest.elementID
                              child:query];
#ifdef DEBUG
    [[LoggingService loggingService] logMessage:[iq prettyXMLString] withLevel:LS_TRACE];
#endif
    [self.connectionHandler sendElement:iq];
}

#pragma mark - Mobilis Service Upload Protocol IQ Results

- (void)processServiceUploadRequest:(XMPPIQ *)xmppiq
{
    NSXMLElement *prepareServiceUpload = [xmppiq childElement];
    BOOL singleMode = false;
    for (NSXMLElement *childElement in [prepareServiceUpload children]) {
        if ([childElement.name isEqualToString:@"filename"])
            _currentUploadFileName = [childElement stringValue];
        if ([childElement.name isEqualToString:@"singleMode"])
            singleMode = [childElement stringValueAsBool];
    }
    
    if ([_currentUploadFileName rangeOfString:@".jar"].location == NSNotFound)
        self.isExpectingFileTransfer = YES;
    else self.isExpectingFileTransfer = NO;

    NSXMLElement *prepareServiceUploadResult = [NSXMLElement elementWithName:@"prepareServiceUpload"
                                                                       xmlns:@"http://mobilis.inf.tu-dresden.de#XMPPBeans:admin:prepareServiceUpload"];
    [prepareServiceUploadResult addChild:[NSXMLElement elementWithName:@"acceptServiceUpload"
                                                           stringValue:self.isExpectingFileTransfer ? @"true" : @"false"]];
    XMPPIQ *result = [XMPPIQ iqWithType:@"result"
                                     to:xmppiq.from
                              elementID:xmppiq.elementID
                                  child:prepareServiceUploadResult];

#ifdef DEBUG
    [[LoggingService loggingService] logMessage:[result prettyXMLString] withLevel:LS_TRACE];
#endif
    [self.connectionHandler sendElement:result];
}

- (NSXMLElement *)createBadRequestResponseForIQ:(XMPPIQ *)xmppiq
{
    NSXMLElement *errorElement = [[NSXMLElement alloc] initWithName:@"error"];
    [errorElement addAttributeWithName:@"type" stringValue:@"modify"];
    [errorElement addChild:[NSXMLElement elementWithName:@"bad-request"
                                                   xmlns:@"urn:ietf:params:xml:ns:xmpp-stanzas"]];

    NSXMLElement *badRequest = [XMPPIQ iqWithType:@"error"
                                               to:xmppiq.from
                                        elementID:xmppiq.elementID
                                            child:errorElement];
    return badRequest;
}

- (void)processSessionInitiationOffer:(XMPPIQ *)xmppiq
{
    if ([self checkForBytstreams:[xmppiq childElement]])
        [self acknowledgeSessionInitiation:xmppiq];
    else [self sendSessionInitationDenialResultToIQ:xmppiq];
}

- (void)acknowledgeSessionInitiation:(XMPPIQ *)xmppiq
{
    NSXMLElement *siElement = [NSXMLElement elementWithName:@"si"
                                                      xmlns:@"http://jabber.org/protocol/si"];
    NSXMLElement *featureElement = [NSXMLElement elementWithName:@"feature"
                                                           xmlns:@"http://jabber.org/protocol/feature-neg"];
    NSXMLElement *xElement = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [xElement addAttributeWithName:@"type" stringValue:@"submit"];
    NSXMLElement *fieldElement = [NSXMLElement elementWithName:@"field"
                                                      children:@[[NSXMLElement elementWithName:@"value"
                                                                                   stringValue:@"http://jabber.org/protocol/bytestreams"]]
                                                    attributes:@[[NSXMLNode attributeWithName:@"var"
                                                                                  stringValue:@"stream-method"]]];

    [xElement addChild:fieldElement];
    [featureElement addChild:xElement];
    [siElement addChild:featureElement];

    XMPPIQ *acknowledgement = [XMPPIQ iqWithType:@"result"
                                              to:xmppiq.from
                                       elementID:xmppiq.elementID
                                           child:siElement];
#ifdef DEBUG
    [[LoggingService loggingService] logMessage:[acknowledgement prettyXMLString]
                                      withLevel:LS_TRACE];
#endif
    [self.connectionHandler sendElement:acknowledgement];
}

- (void)sendSessionInitationDenialResultToIQ:(XMPPIQ *)xmppiq
{
    NSXMLElement *errorChild = [[NSXMLElement alloc] initWithName:@"error"];
    [errorChild addAttributeWithName:@"code" stringValue:@"400"];
    [errorChild addAttributeWithName:@"type" stringValue:@"cancel"];
    NSXMLElement *forbidden = [[NSXMLElement alloc] initWithName:@"forbidden" xmlns:@"urn:ietf:params:xml:ns:xmpp-stanzas"];
    NSXMLElement *text = [[NSXMLElement alloc] initWithName:@"text" xmlns:@"urn:ietf:params:xml:ns:xmpp-stanzas"];
    [text setStringValue:@"Service Upload Rejected"];

    [errorChild addChild:forbidden];
    [errorChild addChild:text];

    XMPPIQ *result = [XMPPIQ iqWithType:@"result"
                                     to:xmppiq.from
                              elementID:xmppiq.elementID
                                  child:errorChild];
    [self.connectionHandler sendElement:result];
}

- (void)sendSessionInitiationResultToIQ:(XMPPIQ *)xmppiq
{
    NSXMLElement *sessionInitiationResult = [[NSXMLElement alloc] initWithName:@"si" xmlns:@"http://jabber.org/protocol/si"];
    NSXMLElement *featureResult = [[NSXMLElement alloc] initWithName:@"feature" xmlns:@"http://jabber.org/protocol/feature-neg"];
    NSXMLElement *xResult = [[NSXMLElement alloc] initWithName:@"x" xmlns:@"jabber:x:data"];
    [xResult addAttributeWithName:@"type" stringValue:@"submit"];
    NSXMLElement *fieldResult = [[NSXMLElement alloc] initWithName:@"field"];
    [fieldResult addAttributeWithName:@"var" stringValue:@"stream-method"];
    [fieldResult addAttributeWithName:@"type" stringValue:@"list-single"];
    NSXMLElement *optionResult = [[NSXMLElement alloc] initWithName:@"option"];
    NSXMLElement *valueResult = [[NSXMLElement alloc] initWithName:@"value" stringValue:@"http://jabber.org/protocol/bytestreams"];

    [optionResult addChild:valueResult];
    [fieldResult addChild:optionResult];
    [xResult addChild:fieldResult];
    [featureResult addChild:xResult];
    [sessionInitiationResult addChild:featureResult];

    XMPPIQ *result = [XMPPIQ iqWithType:@"result"
                                     to:xmppiq.from
                              elementID:xmppiq.elementID
                                  child:sessionInitiationResult];
    [self.connectionHandler sendElement:result];
}

- (BOOL)checkForBytstreams:(NSXMLElement *)element
{
    NSArray *childElements = [element children];
    for (NSXMLElement *elementTags in childElements)
        if ([elementTags.name isEqualToString:@"feature"]) {
            NSArray *fields = [[[elementTags childAtIndex:0] childAtIndex:0] children];
            for (NSXMLElement *option in fields)
                if ([[option childAtIndex:0].stringValue isEqualToString:@"http://jabber.org/protocol/bytestreams"])
                    return YES;
        }
    return NO;
}

@end
