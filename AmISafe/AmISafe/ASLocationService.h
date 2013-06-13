//
//  ASLocationService.h
//  AmISafe
//
//  Created by Sadasivan Arun on 4/2/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ASStationInfoDTO.h"

@interface ASLocationService : NSObject


@property (nonatomic, strong)CLLocation *mUserCurrentLocation;
@property (nonatomic, strong) CLLocationManager *mLocationManager;
@end
