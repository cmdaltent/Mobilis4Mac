//
//  MobilisXMPPStream.m
//  Mobilis4Mac
//
//  Created by Martin Weißbach on 10/14/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "MobilisXMPPStream.h"
#import "LoggingService.h"

@implementation MobilisXMPPStream

- (void)sendElement:(NSXMLElement *)element
{
    [[LoggingService sharedInstance] logString:[element XMLString]];

    [super sendElement:element];
}

@end
