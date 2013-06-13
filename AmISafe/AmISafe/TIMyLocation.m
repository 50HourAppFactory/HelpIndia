//
//  TIMyLocation.m
//  TaggleIt
//
//  Created by Sadasivan Arun on 12/13/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import "TIMyLocation.h"

#import <AddressBook/AddressBook.h>

@interface TIMyLocation ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation TIMyLocation
@synthesize name, address, theCoordinate, index;

- (id)initWithName:(NSString*)_name address:(NSString*)_address coordinate:(CLLocationCoordinate2D)_coordinate andIndex:(NSInteger)_index {
    if (self = [super init])
    {
        self.name = _name;
        self.address = _address;
        self.theCoordinate = _coordinate;
        self.index = _index;
    }
    return self;
}

- (NSString *)title {
    return name;
}

- (NSString *)subtitle {
    return address;
}

- (CLLocationCoordinate2D)coordinate {
    return theCoordinate;
}

@end

