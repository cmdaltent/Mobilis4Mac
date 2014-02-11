//
// Created by Martin Weissbach on 2/11/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import "NSBundle+Mobilis.h"

@implementation NSBundle (Mobilis)

- (NSString *)bundleName
{
    return [[self infoDictionary] valueForKey:@"CFBundleName"];
}

@end