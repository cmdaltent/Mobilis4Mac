//
// Created by Martin Weißbach on 10/14/13.
// Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface MobilisService : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic, readonly) NSBundle *serviceBundle;

- (id)initWithBundle:(NSBundle *)bundle;

- (NSString *)serviceName;

@end