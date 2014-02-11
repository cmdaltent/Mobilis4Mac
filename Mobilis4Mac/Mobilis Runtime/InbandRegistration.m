//
// Created by Martin Weissbach on 17/01/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <MobilisMXi/MXi/MXiConnection.h>
#import "InbandRegistration.h"
#import "MobilisRuntime.h"
#import "SettingsManager.h"
#import "Account.h"
#import "RandomString.h"


@implementation InbandRegistration {

    __strong NSString *_username;
    __strong NSString *_password;

    __strong NSString *_currentlyUsedID;

    __strong void (^_completionBlock)(NSError *);
}

- (void)dealloc
{
    _username = nil;
    _password = nil;

    [[MobilisRuntime mobilisRuntime].connectionHandler.connection removeStanzaDelegate:self forStanzaElement:IQ];
    [[MobilisRuntime mobilisRuntime].connectionHandler.connection removeErrorDelegate:self];
}

- (id)initInbandRegistrationWithUsername:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
        _currentlyUsedID = nil;

        [[MobilisRuntime mobilisRuntime].connectionHandler.connection addStanzaDelegate:self
                                                                           withSelector:@selector(iqStanzaReceived:)
                                                                       forStanzaElement:IQ];
        [[MobilisRuntime mobilisRuntime].connectionHandler.connection addErrorDelegate:self
                                                                           withSelecor:@selector(iqErrorReceived:)];
    }

    return self;
}

- (void)launchRegistrationWithCompletionBlock:(void (^)(NSError *error))completionBlock
{
    _completionBlock = [completionBlock copy];

    NSXMLElement *queryElement = [[NSXMLElement alloc] initWithName:@"query" xmlns:@"jabber:iq:register"];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get"
                                 to:[XMPPJID jidWithString:[SettingsManager new].account.hostName]
                          elementID:[self generateID]
                              child:queryElement];

    [[MobilisRuntime mobilisRuntime].connectionHandler sendElement:iq];
}
- (NSString *)generateID
{
    _currentlyUsedID = [RandomString randomStringWithLength:5];
    return _currentlyUsedID;
}

#pragma mark - Public Class Methods

+ (NSString *)generateServiceJid:(NSString *)serviceName
{
    SettingsManager *settingsManager = [SettingsManager new];
    return [NSString stringWithFormat:@"%@.%@@%@",
                    [XMPPJID jidWithString:settingsManager.account.jid].user,
                    [serviceName lowercaseString],
                    settingsManager.account.hostName];
}

#pragma mark - Stanza Delegate Implementation

- (void)iqStanzaReceived:(XMPPIQ *)xmppiq
{
    if ([xmppiq isResultIQ] && [[xmppiq attributeStringValueForName:@"id"] isEqualToString:_currentlyUsedID]) {
        if ([xmppiq childElement]) {
            for (NSXMLElement *childElement in [[xmppiq childElement] children])
                if ([childElement.name isEqualToString:@"x"]) {
                    [self furtherProcessIQ:childElement];
                }
        } else {
            _completionBlock(nil);
        }
    }
}

- (void)furtherProcessIQ:(NSXMLElement *)element
{
    NSXMLElement *usernameField = nil;
    NSXMLElement *passwordField = nil;
    
    NSArray *childElements = [element children];
    for (NSXMLElement *childElement in childElements)
        if ([childElement.name isEqualToString:@"field"]) {
            if ([[childElement attributeStringValueForName:@"var"] isEqualToString:@"username"]) {
                usernameField = [self fieldElementWithValue:_username andTemplate:childElement];
            }
            if ([[childElement attributeStringValueForName:@"var"] isEqualToString:@"password"]) {
                passwordField = [self fieldElementWithValue:_password andTemplate:childElement];
            }
        }    
    if (!usernameField || !passwordField) _completionBlock([NSError errorWithDomain:@"Inband Registration" code:1 userInfo:nil]);
    
    XMPPIQ *registerIQ = [self createRegisterIQWithUsernameField:usernameField andPasswordField:passwordField];
    [[MobilisRuntime mobilisRuntime].connectionHandler sendElement:registerIQ];
}

- (NSXMLElement *)fieldElementWithValue:(__strong NSString *)value andTemplate:(NSXMLElement *)template
{
    return  [NSXMLElement elementWithName:template.name
                                 children:@[[NSXMLElement elementWithName:@"value" stringValue:value]]
                               attributes:@[[NSXMLNode attributeWithName:@"var" stringValue:[template attributeStringValueForName:@"var"]],
                                            [NSXMLNode attributeWithName:@"type" stringValue:[template attributeStringValueForName:@"type"]],
                                            [NSXMLNode attributeWithName:@"label" stringValue:[template attributeStringValueForName:@"label"]]]];
}

- (XMPPIQ *)createRegisterIQWithUsernameField:(NSXMLElement *)username andPasswordField:(NSXMLElement *)password
{
    NSXMLElement *registerQuery = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:register"];

    NSXMLElement *xElement = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [xElement addAttributeWithName:@"type" stringValue:@"submit"];
    [xElement addChild:[NSXMLElement elementWithName:@"field"
                                            children:@[[NSXMLElement elementWithName:@"value"
                                                                         stringValue:@"jabber:iq:register"]]
                                          attributes:@[[NSXMLNode attributeWithName:@"type" stringValue:@"hidden"],
                                          [NSXMLNode attributeWithName:@"var" stringValue:@"FORM_TYPE"]]]];
    [xElement addChild:username];
    [xElement addChild:password];

    [registerQuery addChild:xElement];
    return [XMPPIQ iqWithType:@"set"
                           to:[XMPPJID jidWithString:[SettingsManager new].account.hostName]
                    elementID:[self generateID]
                        child:registerQuery];
}

#pragma mark - Error Delegate Implementation

- (void)iqErrorReceived:(NSXMLElement *)errorIQ
{
    for (NSXMLElement *element in [errorIQ children]) {
        if ([element.name isEqualToString:@"error"]) {
            [self processErrorIQ:element];
        }
    }
}

- (void)processErrorIQ:(NSXMLElement *)errorElement
{
    if ([[errorElement attributeStringValueForName:@"code"] isEqualToString:@"409"]) {
        _completionBlock([NSError errorWithDomain:@"Service Already Registered" code:409 userInfo:nil]);
    }
}

@end