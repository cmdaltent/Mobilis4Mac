//
//  DeploymentService.h
//  ACDSenseService4Mac
//
//  Created by Martin Weissbach on 27/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//


@interface DeploymentService : NSObject

- (NSURL *)installLocalFile:(NSURL *)fileURL error:(NSError * __autoreleasing *)error;

- (NSURL *)installUploadedBundle:(NSData *)bundleData withFileName:(NSString *)fileName error:(NSError *__autoreleasing *)error;

@end
