//
// Created by Martin Weissbach on 31/01/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TURNSocket.h"

@protocol MobilisSocketDelegate;


@interface MobilisSocket : TURNSocket

@property (weak, nonatomic) id<MobilisSocketDelegate> delegate;
@property (readonly) NSMutableData *fileData;

- (void)readFileWithSize:(NSUInteger)fileSize;

@end

@protocol MobilisSocketDelegate <NSObject>

- (void)fileTransferSuccessful:(BOOL)success;

@end