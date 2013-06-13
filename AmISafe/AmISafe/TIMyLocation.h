//
//  TIMyLocation.h
//  TaggleIt
//
//  Created by Sadasivan Arun on 12/13/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TIMyLocation : NSObject<MKAnnotation>
{
//    CLLocationCoordinate2D coordinate;
//    NSString *title;
//    NSString *subTitle;
}

@property (nonatomic, assign)NSInteger index;

- (id)initWithName:(NSString*)_name address:(NSString*)_address coordinate:(CLLocationCoordinate2D)_coordinate andIndex:(NSInteger)_index;
//- (MKMapItem*)mapItem;

@end
