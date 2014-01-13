//
//  MainWindowController.m
//  ACDSenseService4Mac
//
//  Created by Martin Weissbach on 26/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "MainWindowController.h"

#import "LoggingService.h"

@interface MainWindowController () <LoggingServiceDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *loggingTextView;

@end

@implementation MainWindowController

- (void)dealloc
{
    [[LoggingService loggingService] removeDelegate:self];
}

- (void)windowDidLoad
{
    [[LoggingService loggingService] addDelegate:self];
}

#pragma mark - LoggingServiceDelegate

- (void)logString:(NSAttributedString *)logMessage
{
    [self.loggingTextView.textStorage appendAttributedString:logMessage];
}

@end
