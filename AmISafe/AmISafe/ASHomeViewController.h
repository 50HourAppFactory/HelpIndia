//
//  ASHomeViewController.h
//  AmISafe
//
//  Created by Sadasivan Arun on 4/19/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAGrouponView.h"
#import <CoreLocation/CoreLocation.h>
#import "GAITrackedViewController.h"

@interface ASHomeViewController : GAITrackedViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet YAGrouponView *m_viewGroupon;
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollGroupon;

@property (strong, nonatomic) IBOutlet YAGrouponView *m_districtViewGroupon;
@property (strong, nonatomic) IBOutlet UIScrollView *m_districtScrollGroupon;
@property (nonatomic, strong)CLLocation *mUserCurrentLocation;
@property (nonatomic, strong) CLLocationManager *mLocationManager;

-(void)menuChangedForStateWithIndex:(NSInteger)index;
@end
