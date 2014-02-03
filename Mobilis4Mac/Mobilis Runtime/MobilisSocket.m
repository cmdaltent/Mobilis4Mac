//
// Created by Martin Weissbach on 31/01/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <XMPPFramework/XMPPIQ.h>
#import "MobilisSocket.h"
#import "LoggingService.h"
#import "NSXMLElement+XMPP.h"

#define MOBILIS_FILE_UPLOAD      1000

@interface MobilisSocket() <GCDAsyncSocketDelegate>

@property (readwrite) NSMutableData *fileData;

@end

@implementation MobilisSocket

- (id)initWithStream:(XMPPStream *)stream incomingTURNRequest:(XMPPIQ *)iq
{
    self = [super initWithStream:stream incomingTURNRequest:iq];
    if (self)
    {
        if (![self validTURNRequest:iq])
            @throw [NSException exceptionWithName:@"Malformed Request"
                                           reason:@"The incoming TURN Request is invalid"
                                         userInfo:nil];

        self.fileData = [NSMutableData new];
    }
    return self;
}

- (id)initWithStream:(XMPPStream *)stream toJID:(XMPPJID *)jabberID
{
    self = [super initWithStream:stream toJID:jabberID];
    if (self)
    {
        self.fileData = [NSMutableData new];
    }
    return self;
}

- (BOOL)validTURNRequest:(XMPPIQ *)request
{
    if (![request elementID]) return NO;
    if (![request childElement] || ![[request childElement].name isEqualToString:@"query"]) return NO;
    if ([[request childElement] elementsForName:@"streamhost"].count == 0) return NO;

    NSArray *hostNames = [[request childElement] elementsForName:@"streamhost"];
    for (NSXMLElement *hostName in hostNames)
        if (    [[hostName attributeStringValueForName:@"jid"] isEqualToString:@""] ||
                [[hostName attributeStringValueForName:@"host"] isEqualToString:@""] ||
                [[hostName attributeStringValueForName:@"port"] isEqualToString:@""]
           ) return NO;

    return YES;
}

- (void)readFileWithSize:(NSUInteger)fileSize
{
    [asyncSocket readDataToLength:fileSize withTimeout:-1 tag:MOBILIS_FILE_UPLOAD];
}

#pragma mark - GCDAsyncSocketDelegate Overwrites

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [super socket:sock didReadData:data withTag:tag];

    if (tag == MOBILIS_FILE_UPLOAD)
    {
        @synchronized (_fileData) {
            [self.fileData appendData:data];
        }
        [[LoggingService loggingService] logMessage:[NSString stringWithFormat:@"Data read: %lu", data.length] withLevel:LS_TRACE];

        if (self.delegate && [delegate respondsToSelector:@selector(fileTransferSuccessful:)])
            [self.delegate performSelector:@selector(fileTransferSuccessful:) withObject:@YES];
    }
}

@end