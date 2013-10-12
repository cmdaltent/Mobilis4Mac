//
// Created by Martin Weißbach on 10/11/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ConnectionHandler.h"

#import "XMPPJID.h"
#import "XMPPStream.h"
#import "XMPPPresence.h"

@interface ConnectionHandler () <XMPPStreamDelegate>

@property (strong, nonatomic) XMPPStream *xmppStream;
@property dispatch_queue_t streamQueue;

- (void)setUpStream;
- (void)connect;
- (void)goOnline;

@end

@implementation ConnectionHandler

+ (id)connectionWithJabberID:(NSString *)jabberID password:(NSString *)password hostName:(NSString *)hostName port:(NSNumber *)port
{
    return [[self alloc] initConnectionWithJabberID:jabberID password:password hostName:hostName port:port];
}

- (id)initConnectionWithJabberID:(NSString *)jabberID password:(NSString *)password hostName:(NSString *)hostName port:(NSNumber *)port
{
    self = [super init];
    if (self) {
        self.jabberID = [XMPPJID jidWithString:jabberID];
        self.password = password;
        if (hostName && ![hostName isEqualToString:@""])
            self.hostName = hostName;
        else self.hostName = [self.jabberID domain];
        self.port = port;
    }

    [self setUpStream];
    [self connect];

    return self;
}

- (void)setUpStream
{
    if (self.xmppStream)
        return;

    self.xmppStream = [[XMPPStream alloc] init];
    self.streamQueue = dispatch_queue_create("Mobilis CH", DISPATCH_QUEUE_CONCURRENT);
    [self.xmppStream addDelegate:self delegateQueue:self.streamQueue];
}

- (void)connect
{
    [self.xmppStream setMyJID:self.jabberID];
    [self.xmppStream setHostName:self.hostName];
    [self.xmppStream setHostPort:(UInt16)[self.port integerValue]];

    NSError *error = nil;
    if (![self.xmppStream connectWithTimeout:30.0 error:&error]) {
        // TODO: Error Log here!!!
    }
}

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];

    // TODO: Notify someone that connection establishment was successful.
}

#pragma mark - XMPPStreamDelegate

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError *error = nil;
    #warning authenticateWithPassword:error: is deprecated. see authenticate:error:
    [self.xmppStream authenticateWithPassword:self.password error:&error];
    if (error) {
        // TODO: Error Log here!!!
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    // TODO: implement Log here!!!
    NSLog(@"xmppStreamdidAuthenticate:");
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    // TODO: implement Log here!!!
    NSLog(@"xmppStreamDidNotAuthenticate:");
}

@end