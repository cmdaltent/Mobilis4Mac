//
//  PerstistenceStack.h
//  Mobilis4Mac
//
//  Created by Martin Weissbach on 03/02/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PersistenceStack : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)persistenceStack;

@end
