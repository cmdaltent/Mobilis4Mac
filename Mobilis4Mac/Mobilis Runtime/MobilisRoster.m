//
// Created by Martin Weissbach on 2/11/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <XMPPFramework/XMPPRoster.h>
#import "MobilisRoster.h"
#import "MXiConnection.h"
#import "XMPPRosterCoreDataStorage.h"


@implementation MobilisRoster
{
    __strong XMPPRoster *_roster;
}

- (id)initWithConnection:(MXiConnection *)connection
{
    self = [super init];
    if (self)
    {
        _roster = [[XMPPRoster alloc] initWithRosterStorage:[[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore]];
        [_roster activate:connection.xmppStream];

        [self updateRoster];
    }

    return self;
}

- (void)updateRoster
{
    [_roster fetchRoster];
}

- (NSArray *)remoteMobilisRuntimes
{
    NSMutableArray *remoteRuntimes = [[NSMutableArray alloc] initWithCapacity:5];
    NSArray *rosterElements = [((XMPPRosterCoreDataStorage *) _roster.xmppRosterStorage) jidsForXMPPStream:_roster.xmppStream];
    for (XMPPJID *rosterObject in rosterElements)
    {
        XMPPUserCoreDataStorageObject *userObject = [((XMPPRosterCoreDataStorage *)_roster.xmppRosterStorage) userForJID:rosterObject
                                                                                                              xmppStream:_roster.xmppStream
                                                                                                    managedObjectContext:((XMPPRosterCoreDataStorage *)_roster.xmppRosterStorage).mainThreadManagedObjectContext];
        for (XMPPGroupCoreDataStorageObject *group in userObject.groups)
        {
            if ([group.name isEqualToString:@"srg:runtimes"]) {
                [remoteRuntimes addObject:rosterObject];
            }
        }
    }

    return [remoteRuntimes copy];
}

@end