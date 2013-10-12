//
//  AppDelegate.h
//  Mobilis4Mac
//
//  Created by Martin Weißbach on 10/11/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;

@class MobilisServer;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong) MobilisServer *mobilisServer;

@property (strong, nonatomic) MainWindowController *mainWindowController;

@end
