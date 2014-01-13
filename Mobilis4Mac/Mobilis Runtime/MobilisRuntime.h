//
//  MobilisRuntime.h
//  ACDSenseService4Mac
//
//  Created by Martin Weissbach on 27/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DeploymentService;

@interface MobilisRuntime : NSObject

@property (nonatomic, readonly) DeploymentService *deploymentService;

+ (instancetype)mobilisRuntime;

- (void)launchRuntime;
- (void)shutdownRuntime;

- (void)loadServiceAtLocation:(NSURL *)urlToBundle;

- (void)synchronize;

@end
