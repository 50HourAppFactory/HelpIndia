//
//  ASLocationService.m
//  AmISafe
//
//  Created by Sadasivan Arun on 4/2/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASLocationService.h"
#import "TIMyLocation.h"

#define GOOGLEMAPDIRECTIONSTRING @"comgooglemaps://?saddr=(%lf,%lf)&daddr=(%lf,%lf)&center=37.423725,-122.0877&directionsmode=%@&zoom=17"

@interface ASLocationService ()
{
    
}

-(void)initialize;
@end

@implementation ASLocationService


-(void)initialize
{
//    if(self.mUserCurrentLocation==nil)
//    {
//        self.mUserCurrentLocation = [[CLLocation alloc] init];
//    }
    
    if(self.mLocationManager==nil)
    {
        self.mLocationManager = [[CLLocationManager alloc] init];
        self.mLocationManager.delegate = self;
        self.mLocationManager.distanceFilter = kCLDistanceFilterNone; 
        self.mLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    [self.mLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.mUserCurrentLocation = newLocation;
    [self.mLocationManager stopUpdatingLocation];
    //Place code for message service here.
    self.mLocationManager = nil;
}

@end
