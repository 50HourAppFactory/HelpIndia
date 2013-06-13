//
//  ASViewController.h
//  AmISafe
//
//  Created by Sadasivan Arun on 3/26/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ASViewController : UIViewController

{
    IBOutlet UISlider *sliderToRule;
}
@property (nonatomic, strong)CLLocation *mUserCurrentLocation;
@property (nonatomic, strong) CLLocationManager *mLocationManager;

@end
