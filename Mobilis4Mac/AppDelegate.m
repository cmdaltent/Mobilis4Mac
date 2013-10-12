//
//  AppDelegate.m
//  Mobilis4Mac
//
//  Created by Martin Weißbach on 10/11/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "AppDelegate.h"
#import "MobilisServer.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.mobilisServer = [MobilisServer new];
    [self.mobilisServer launchServer];
}

@end
