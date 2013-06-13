//
//  ASLocationMapViewController.m
//  AmISafe
//
//  Created by Sadasivan Arun on 3/28/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASLocationMapViewController.h"
#import "TIMyLocation.h"

#define GOOGLEMAPDIRECTIONSTRING @"comgooglemaps://?saddr=(%lf,%lf)&daddr=(%lf,%lf)&center=37.423725,-122.0877&directionsmode=%@&zoom=17"



@interface ASLocationMapViewController ()
{
    ASStationInfoDTO *mStationInfoDto;
}

-(void)loadAllPointsToTheMapView;
-(void)tagPointsToTheMapView:(NSMutableArray *)annotationPointList;
-(void) markCurrentLocation;
-(void)getCurrentLocation;


@property (nonatomic, strong) NSMutableArray *mAnnotationArray;
@end

@implementation ASLocationMapViewController
@synthesize mAnnotationList, mLocationManager, mUserCurrentLocation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithInfo:(ASStationInfoDTO *)stationInfoDto
{
    self = [super init];
    if(self)
    {
        mStationInfoDto = stationInfoDto;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Directions";
    
    if(self.mUserCurrentLocation==nil)
    {
        self.mUserCurrentLocation = [[CLLocation alloc] init];
    }
    
    
    UIBarButtonItem *directionsButton = [[UIBarButtonItem alloc]initWithTitle:@"Route Map" style:UIBarButtonItemStyleBordered target:self action:@selector(getDirectionsButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = directionsButton;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getCurrentLocation];
    
    [mMapView setDelegate:self];
    
    [self loadAllPointsToTheMapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Location Updates
#pragma mark -

-(void)getCurrentLocation
{
    if(self.mLocationManager==nil)
    {
        self.mLocationManager = [[CLLocationManager alloc] init];
        self.mLocationManager.delegate = self;
        self.mLocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        self.mLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    [self.mLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.mUserCurrentLocation = newLocation;
    [self markCurrentLocation];
    [self.mLocationManager stopUpdatingLocation];
    self.mLocationManager = nil;
}

-(void) markCurrentLocation
{    
    CLLocationCoordinate2D location;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.3;
    span.longitudeDelta = 0.3;
    region.span = span;
    location.latitude = self.mUserCurrentLocation.coordinate.latitude;
    location.longitude = self.mUserCurrentLocation.coordinate.longitude;
    region.center = location;
    [mMapView setRegion:region animated:YES];
    TIMyLocation *annotation = [[TIMyLocation alloc] initWithName:@"Me" address:@"" coordinate:location andIndex:1001] ;
    [mMapView addAnnotation:annotation];
    //    [self.mAnnotationArray addObject:annotation];
    
    [self.mAnnotationArray insertObject:annotation atIndex:0];
    
    
}

-(void)tagPointsToTheMapView:(NSMutableArray *)annotationPointList
{
    [mMapView addAnnotations:annotationPointList];
}

-(void)loadAllPointsToTheMapView
{
        CLLocationCoordinate2D location;
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.01;
        span.longitudeDelta = 0.01;
        region.span = span;
        
        location.latitude = mStationInfoDto.latitude;
        location.longitude = mStationInfoDto.longitude;
        region.center = location;
        TIMyLocation *annotation = [[TIMyLocation alloc] initWithName:mStationInfoDto.name address:mStationInfoDto.contactNo coordinate:location andIndex:1002] ;
        [mMapView addAnnotation:annotation];
        [self.mAnnotationArray addObject:annotation];
}

#pragma mark -
#pragma mark Mapview Delegates
#pragma mark -
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[TIMyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [mMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
        } else {
            annotationView.annotation = annotation;
        }
        
        TIMyLocation *myAnnotation = annotation;
        
        if(myAnnotation.index == 1001)
        {
            annotationView.image = [UIImage imageNamed:@"mappinpink.png"];
        }
        else{
            annotationView.image = [UIImage imageNamed:@"mappinazure.png"];
        }
        
        return annotationView;
    }
    
    return nil;
}


-(void)getDirectionsButtonClicked:(id)sender
{
        NSString *urlString = [NSString stringWithFormat:GOOGLEMAPDIRECTIONSTRING,self.mUserCurrentLocation.coordinate.latitude,self.mUserCurrentLocation.coordinate.longitude,mStationInfoDto.latitude,mStationInfoDto.longitude,@"walking"];
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    urlString]];
}

@end
