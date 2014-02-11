//
// Created by Martin Weissbach on 2/11/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Mobilis)

/*!
    Returns the receiver's bundle name.

    @return The receiver's bundle name, which is defined by the <tt>CFBundleName</tt> identifier in the info dictionary.
 */
- (NSString *)bundleName;

@end