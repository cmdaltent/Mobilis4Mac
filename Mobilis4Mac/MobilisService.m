//
// Created by Martin Weißbach on 10/14/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MobilisService.h"

@implementation MobilisService

- (id)initWithBundle:(NSBundle *)bundle
{
    self = [super init];
    if (self) {
        self.identifier = [bundle bundleIdentifier];
        self.version = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

        _serviceBundle = bundle;
    }

    return self;
}

- (NSString *)serviceName
{
    return [self.serviceBundle objectForInfoDictionaryKey:@"CFBundleName"];
}


@end