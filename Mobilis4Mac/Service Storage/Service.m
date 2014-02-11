//
//  Service.m
//  Mobilis4Mac
//
//  Created by Martin Weissbach on 03/02/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import "Service.h"

#import "PersistenceStack.h"

@implementation Service

@dynamic name;
@dynamic location;
@dynamic jabberID;
@dynamic password;

- (id)initWithServiceName:(NSString *)serviceName location:(NSURL *)storageLocation andJabberID:(NSString *)jabberID password:(NSString *)password
{
    self = [super initWithEntity:[NSEntityDescription entityForName:@"Service"
                                             inManagedObjectContext:[PersistenceStack persistenceStack].managedObjectContext]
  insertIntoManagedObjectContext:[PersistenceStack persistenceStack].managedObjectContext];
    if (self) {
        self.name = serviceName;
        self.location = storageLocation;
        self.jabberID = jabberID;
        self.password = password;
    }
    
    return self;
}

@end
