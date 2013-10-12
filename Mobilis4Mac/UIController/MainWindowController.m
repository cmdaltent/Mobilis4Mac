//
//  MainWindowController.m
//  Mobilis4Mac
//
//  Created by Martin Weißbach on 10/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation MainWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [LoggingService sharedInstance].delegate = self;
}

#pragma mark - LoggingServiceDelegate

- (void)logString:(NSString *)logMessageAsString
{
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:logMessageAsString];
    [[self.textView textStorage] appendAttributedString:string];
    
    [self.textView scrollRangeToVisible:NSMakeRange([[self.textView textStorage] length], 0)];
}

@end
