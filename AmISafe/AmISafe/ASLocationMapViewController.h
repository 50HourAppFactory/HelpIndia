//
//  ASLocationMapViewController.h
//  AmISafe
//
//  Created by Sadasivan Arun on 3/28/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASStationInfoDTO.h"
@interface ASLocationMapViewController : UIViewController<MKAnnotation, MKMapViewDelegate, CLLocationManagerDelegate>
{
    IBOutlet MKMapView *mMapView;
}

- (id)initWithInfo:(ASStationInfoDTO *)stationInfoDto;

@property (nonatomic) NSMutableArray *mAnnotationList;
@property (nonatomic, strong)CLLocation *mUserCurrentLocation;
@property (nonatomic, strong) CLLocationManager *mLocationManager;
@end
