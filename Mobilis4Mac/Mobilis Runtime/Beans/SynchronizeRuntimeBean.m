//
// Created by Martin Weißbach on 10/24/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//


#import "SynchronizeRuntimeBean.h"
#import "NSXMLElement+XMPP.h"


@implementation SynchronizeRuntimeBean

+ (instancetype)syncrhonizeServices:(NSArray *)serviceJIDs withRemoteRuntime:(NSString *)remoteJID
{
    return [[self alloc] initWithBeanType:SET targetRuntimeJID:remoteJID serviceJIDs:serviceJIDs];
}

+ (instancetype)synchronizationResult:(NSArray *)serviceJIDs forRemoteRuntime:(NSString *)remoteJID
{
    return [[self alloc] initWithBeanType:RESULT targetRuntimeJID:remoteJID serviceJIDs:serviceJIDs];
}

- (id)initWithBeanType:(BeanType)beanType targetRuntimeJID:(NSString *)fullJID serviceJIDs:(NSArray *)serviceJIDs
{
    self = [super initWithBeanType:beanType];
    if (self) {
        self.to = [XMPPJID jidWithString:fullJID];
        self.serviceJIDs = serviceJIDs;
    }

    return self;
}

- (id)init
{
    return [self initWithBeanType:RESULT];
}

- (void)fromXML:(NSXMLElement *)xml
{
    NSArray *serviceJIDs = [xml elementsForName:@"publishNewService"];
    NSMutableArray *tempJIDs = [NSMutableArray arrayWithCapacity:serviceJIDs.count];

    for (NSXMLElement *serviceElement in serviceJIDs) {
        [tempJIDs addObject:[[serviceElement elementForName:@"serviceJID"] stringValue]];
    }

    self.serviceJIDs = [NSArray arrayWithArray:tempJIDs];
}

- (NSXMLElement *)toXML
{
    NSXMLElement *synchronizeRuntimesBean = [NSXMLElement elementWithName:@"publishNewService"
                                                                    xmlns:@"http://mobilis.inf.tu-dresden.de#XMPPBean:deployment:publishNewService"];
    for (NSString *serviceJID in self.serviceJIDs) {
        NSXMLElement *serviceJIDElement = [NSXMLElement elementWithName:@"serviceJID" stringValue:serviceJID];
        [synchronizeRuntimesBean addChild:serviceJIDElement];
    }

    return synchronizeRuntimesBean;
}

@end