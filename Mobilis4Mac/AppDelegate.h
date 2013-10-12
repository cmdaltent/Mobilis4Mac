//
//  AppDelegate.h
//  Mobilis4Mac
//
//  Created by Martin Weißbach on 10/11/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MobilisServer;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (strong) MobilisServer *mobilisServer;

@end
