//
//  Service.h
//  Mobilis4Mac
//
//  Created by Martin Weissbach on 03/02/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Service : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSURL * location;
@property (nonatomic, retain) NSString * jabberID;
@property (nonatomic, retain) NSString * password;

- (id)initWithServiceName:(NSString *)serviceName location:(NSURL *)storageLocation andJabberID:(NSString *)jabberID password:(NSString *)password;

@end
