//
// Created by Martin Weissbach on 17/01/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InbandRegistration : NSObject

- (id)initInbandRegistrationWithUsername:(NSString *)username password:(NSString *)password;

- (void)launchRegistrationWithCompletionBlock:(void (^)(NSError *error))completionBlock;

@end