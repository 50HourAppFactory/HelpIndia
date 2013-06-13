//
//  ASHomeViewController.m
//  AmISafe
//
//  Created by Sadasivan Arun on 4/19/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASHomeViewController.h"
#import "ASStationInfoService.h"
#import "ASStationInfoDTO.h"
#import "TIMyLocation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIGlossyButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+LayerEffects.h"
#import "ASLocationMapViewController.h"
#import "ASSlider.h"
#import "CSUtility.h"
#import "CSConstants.h"
#import "ASSMSComposerViewController.h"
#import "ASSettingsViewController.h"
#import "ASRepositoryService.h"
#import "GAITracker.h"
#import "GAI.h"

#define BUTTONCALL 1005

@interface ASHomeViewController ()
{
    NSArray *arrGrouponTitle ;
    int currentPage;
    NSMutableArray *districtArray;
    IBOutlet UITableView *tableView;
}

@property (nonatomic, strong)NSMutableArray *contactArray;
@property (nonatomic, strong)NSMutableArray *stateArray;
@property (nonatomic, strong)NSMutableDictionary *districtDict;
@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, strong)NSMutableArray *districtArray;
@property (nonatomic, strong)NSMutableArray *stationArray;
@property (nonatomic, strong)UIGlossyButton *callButton;

-(void)setUPGrouponSliderForState;
-(void)setUPGrouponSliderForDistrict:(NSMutableArray *)districtArray;
-(void)setUpDistrictForStateIndex:(NSInteger)index;
-(void)setUpStationsForDistrictIndex:(NSInteger)index;
-(void)menuChangedForDistrictWithIndex:(NSInteger)index;
-(void)setUpMapItemsFor:(ASStationInfoDTO *)stationInfoDto inMapView:(MKMapView *)mapView;

-(void)setupAlertButton;
-(void)getCurrentLocation;
-(void)setUpDistanceLabel:(UILabel *)distanceLabel forStation:(ASStationInfoDTO *)stationDto;
-(void)nearestStation;
-(float)kilometresBetweenPlace1:(CLLocation*) currentLocation andPlace2:(CLLocation*) place2;
-(void)scrollToSavedStation:(ASStationInfoDTO *)savedStation;
@end

@implementation ASHomeViewController
@synthesize contactArray, stateArray, selectedIndex, districtDict,districtArray,stationArray,mUserCurrentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Initialize the current location.
    
    self.trackedViewName = @"Home View";
    self.title = @"Amisafe Home Screen";
    [self getCurrentLocation];
    
    self.navigationItem.title = @"Stations";
    // Dispose of any resources that can be recreated.
    ASStationInfoService *service = [[ASStationInfoService alloc]init];
    //Get all details from the database.
    self.contactArray = [service getPoliceContacts];
    //Get the state array.
    self.stateArray = [service getAllStateArray:self.contactArray];
    // Do any additional setup after loading the view from its nib.
    [self setUPGrouponSliderForState];
    //Set up alert button.
    [self setupAlertButton];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //Set up the settings button.
    [self setupRightBarButton];
    
    UIImage *myImage = [UIImage imageNamed:@"nearMe.png"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    myButton.showsTouchWhenHighlighted = YES;
    myButton.frame = CGRectMake(0.0, 0.0, myImage.size.width, myImage.size.height);
    
    [myButton addTarget:self action:@selector(nearestStation) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]
                           initWithCustomView:myButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    //Set up callbutton.
    
    [self.callButton useWhiteLabel: YES];
    self.callButton.tintColor = [UIColor darkGrayColor];
    [self.callButton setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
    [self.callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupRightBarButton
{
    UIImage *settingsImage = [UIImage imageNamed:@"settings_icon.png"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:settingsImage forState:UIControlStateNormal];
    rightButton.showsTouchWhenHighlighted = YES;
    rightButton.frame = CGRectMake(0.0, 0.0, settingsImage.size.width, settingsImage.size.height);
    
    [rightButton addTarget:self action:@selector(settingsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                       initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setUPGrouponSliderForState
{
    [self.m_viewGroupon setGrouponSlider:self.stateArray toScrollView:self.m_scrollGroupon];
    [self setUpDistrictForStateIndex:0];
    [self menuChangedForStateWithIndex:0];
}

-(void)setUPGrouponSliderForDistrict:(NSMutableArray *)districtArray
{
    [self.m_districtViewGroupon setGrouponSlider:self.districtArray toScrollView:self.m_districtScrollGroupon];
    [self.m_districtViewGroupon startScrollViewToFirst];
    [self menuChangedForDistrictWithIndex:0];
    
}

-(void)menuChangedForStateWithIndex:(NSInteger)index
{
    [self.m_viewGroupon changeTitleColorForIndex:index];
    NSLog(@"%d",index);
}

-(void)menuChangedForDistrictWithIndex:(NSInteger)index
{
    [self.m_districtViewGroupon changeTitleColorForIndex:index];
    [self setUpStationsForDistrictIndex:index];
    NSLog(@"%d",index);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.tag==1)
    {
//        if(!self.m_scrollGroupon.isDragging) return;
//        {
            CGFloat pageWidth = self.m_scrollGroupon.frame.size.width;
            int page = floor((self.m_scrollGroupon.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            if (currentPage != page) {
                currentPage = page;
                //Get the state name from the "page" index of state array.
                [self setUpDistrictForStateIndex:page];
                [self menuChangedForStateWithIndex:page];
            }
//        }
    }
    else if(scrollView.tag == 2)
    {
//        if(!self.m_districtScrollGroupon.isDragging) return;
//        {
            CGFloat pageWidth = self.m_districtScrollGroupon.frame.size.width;
            int page = floor((self.m_districtScrollGroupon.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            if (currentPage != page) {
                currentPage = page;
                //Get the state name from the "page" index of state array.]
                [self menuChangedForDistrictWithIndex:page];
            }
//        }
    }

}

-(void)setUpDistrictForStateIndex:(NSInteger)index
{
    //Get the array of district corresponding to the state name from the district dict.
    if ([self.districtArray count]>0)
    {
        [self.districtArray removeAllObjects];
    }
    ASStationInfoService *service = [[ASStationInfoService alloc]init];
    self.districtArray = [service getAllDistrictsFrom:self.contactArray andState:[self.stateArray objectAtIndex:index]];
    [self setUPGrouponSliderForDistrict:self.districtArray];
}

-(void)setUpStationsForDistrictIndex:(NSInteger)index
{
    if (self.stationArray==nil) {
        self.stationArray = [[NSMutableArray alloc]initWithCapacity:2];
    }
    else{
        if ([self.stationArray count]>0) {
            [self.stationArray removeAllObjects];
    
        }
    
    }
    ASStationInfoService *service = [[ASStationInfoService alloc]init];
    self.stationArray = [service getAllStationsFrom:self.contactArray andDistrict:[self.districtArray objectAtIndex:index]];
    [tableView reloadData];
    NSLog(@"Station Array Count = %d",[self.stationArray count]);
}


#pragma mark -
#pragma mark Table View Methods
#pragma mark -


-(UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cell_identifier=[NSString stringWithFormat:@"ASContactCell"];
    UITableViewCell *tblViewCell=[tableView dequeueReusableCellWithIdentifier:cell_identifier];
    UILabel *lblTitle;
    UILabel *lblSubtitle;
    UILabel *lblDistance;
    MKMapView *mMapView;
    UIGlossyButton *callButton;
    UIButton *mapButton;
    if(!tblViewCell)
    {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ASContactCell" owner:self options:nil];
        if([nib count]>0)
        {
            tblViewCell=[nib objectAtIndex:0];
        }
    }
    //Set up callbutton.
    callButton = (UIGlossyButton*) [tblViewCell viewWithTag: BUTTONCALL];
    [callButton useWhiteLabel: YES];
    callButton.tintColor = [UIColor darkGrayColor];
    [callButton setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
    [callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //Set up labels.
    lblTitle = (UILabel *)[tblViewCell viewWithTag:1002];
    lblSubtitle =(UILabel *)[tblViewCell viewWithTag:1003];
    lblDistance =(UILabel *)[tblViewCell viewWithTag:1007];
    //Set up map View.
    mMapView = (MKMapView *)[tblViewCell viewWithTag:1004];
    //Set up map button.
    mapButton = (UIButton *)[tblViewCell viewWithTag:1006];
    [mapButton addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    ASStationInfoDTO *stationInfoDto = [self.stationArray objectAtIndex:indexPath.row];
    lblTitle.text = stationInfoDto.name;
    lblSubtitle.text = [NSString stringWithFormat:@"Tel: %@", stationInfoDto.contactNo];
    [self setUpDistanceLabel:lblDistance forStation:stationInfoDto];
    [self setUpMapItemsFor:stationInfoDto inMapView:mMapView];
    return tblViewCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = [self.stationArray count];
    
    
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 110.0f;
    
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    
}

-(void)setUpMapItemsFor:(ASStationInfoDTO *)stationInfoDto inMapView:(MKMapView *)mapView
{
    CLLocationCoordinate2D location;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.3;
    span.longitudeDelta = 0.3;
    region.span = span;
    location.latitude = stationInfoDto.latitude;
    location.longitude = stationInfoDto.longitude;
    region.center = location;
    [mapView setRegion:region animated:YES];
    TIMyLocation *annotation = [[TIMyLocation alloc] initWithName:@"" address:@"" coordinate:location andIndex:1001] ;
    [mapView addAnnotation:annotation];
    [mapView.layer setCornerRadius:10.0];
    mapView.layer.masksToBounds = YES;
}


-(void)callButtonClicked:(id)sender
{
    ASStationInfoDTO *stationInfoDto = [stationArray objectAtIndex:self.selectedIndex];
    NSString *phoneNumber = stationInfoDto.contactNo; // dynamically assigned
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

-(void)mapButtonClicked:(id)sender
{
    ASStationInfoDTO *stationInfoDto = [stationArray objectAtIndex:self.selectedIndex];
    ASLocationMapViewController *locationMapVc = [[ASLocationMapViewController alloc] initWithInfo:stationInfoDto];
    
    [self.navigationController pushViewController:locationMapVc animated:YES];
}


#pragma mark -
#pragma mark Slider related Methods
#pragma mark -

-(void)setupAlertButton
{
    //For alert label.
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 26,140,26)];
    alertLabel.textAlignment = NSTextAlignmentRight;
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.textColor = [UIColor blackColor];
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.text = @"Slide to Alert!!!";
    [[self.view viewWithTag:1200] addSubview:alertLabel];
    
    UILabel *warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(78, 5,140,18)];
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.backgroundColor = [UIColor clearColor];
    warningLabel.textColor = [UIColor redColor];
    warningLabel.font = [UIFont systemFontOfSize:18];
    warningLabel.text = @"WARNING!!!";
    [[self.view viewWithTag:1200] addSubview:warningLabel];
    
    
    //For Slider.
    
    
    UIImage *trackImage = [UIImage imageNamed:@"sliderTrack.png"];
	UIImageView *sliderBackground = [[UIImageView alloc] initWithImage:trackImage];
	// Create the superview same size as track backround, and add the background image to it
	UIView *view = [[UIView alloc] initWithFrame:sliderBackground.frame];
	[view addSubview:sliderBackground];
    ASSlider *alertSlider = [[ASSlider alloc] initWithFrame:sliderBackground.frame];
    [alertSlider addTarget:self action:@selector(sliderTouched:) forControlEvents:UIControlEventTouchUpInside];
    CGRect sliderFrame = alertSlider.frame;
	sliderFrame.size.width -= 46;
	alertSlider.frame = sliderFrame;
	alertSlider.center = sliderBackground.center;
	alertSlider.backgroundColor = [UIColor clearColor];
    UIImage *thumbImage = [UIImage imageNamed:@"sliderThumb.png"];
	[alertSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    [alertSlider setMinimumTrackImage:[UIImage imageNamed:@"sliderMaxMin-02.png"] forState:UIControlStateNormal];
	[alertSlider setMaximumTrackImage:[UIImage imageNamed:@"sliderMaxMin-02.png"] forState:UIControlStateNormal];
    
    
    NSString *labelText = NSLocalizedString(@"Slide to Alert", @"SlideToCancel label");
	UIFont *labelFont = [UIFont systemFontOfSize:24];
	CGSize labelSize = [labelText sizeWithFont:labelFont];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, labelSize.width, labelSize.height)];
    
	// Center the label over the slidable portion of the track
	CGFloat labelHorizontalCenter = alertSlider.center.x + (thumbImage.size.width / 2);
	label.center = CGPointMake(labelHorizontalCenter, alertSlider.center.y);
    
	// Set other label attributes and add it to the view
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.font = labelFont;
	label.text = labelText;
	[view addSubview:label];
    
    
    [view addSubview:alertSlider];
    [[self.view viewWithTag:1200] addSubview:view];
}

- (void)sliderTouched:(id)sender
{
    UISlider *slider = sender;
    
    
    
    if (slider.value==1) {
        //Get the data from the Plist.
        NSMutableArray *array = [CSUtility getValueForKey:@"ContactList" fromPlistFile:ASSettingsWithExt];
        
        if ([array count]>0) {
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            
            [tracker sendEventWithCategory:@"uiAction"
                                withAction:@"buttonDrag"
                                 withLabel:@"AlertButton"
                                 withValue:[NSNumber numberWithInt:0]];
            
            NSString *urlString = [NSString stringWithFormat:GOOGLEMAPURLSCHEME,self.mUserCurrentLocation.coordinate.latitude,self.mUserCurrentLocation.coordinate.longitude];
            
            NSString *message = [NSString stringWithFormat:ALERTMESSAGE,urlString];
            
            ASSMSComposerViewController *smscomposeVc = [[ASSMSComposerViewController alloc]initWithAllNumber:array];
            
            smscomposeVc.messageString = message;
            [self.navigationController pushViewController:smscomposeVc animated:NO];
        }
        else{
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:WARNINGSTRING delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alertView.tag = 1000;
            [alertView show];
            
            
        }
        
    }
    
    [UIView transitionWithView:slider
                      duration:0.5
                       options:UIViewAnimationOptionTransitionNone
                    animations:^{  slider.value = 0.00; }
                    completion:NULL];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex

{
    switch (alertView.tag) {
        case 1000:
        {
            ASSettingsViewController *settingsViewController = [[ASSettingsViewController alloc]init];
            
            [self.navigationController pushViewController:settingsViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

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
    if(self.mUserCurrentLocation==nil)
    {
        self.mUserCurrentLocation = [[CLLocation alloc] init];
    }
    self.mUserCurrentLocation = newLocation;
    [tableView reloadData];
}

-(void)setUpDistanceLabel:(UILabel *)distanceLabel forStation:(ASStationInfoDTO *)stationDto
{
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:stationDto.latitude longitude:stationDto.longitude];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:self.mUserCurrentLocation.coordinate.latitude longitude:self.mUserCurrentLocation.coordinate.longitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    if (distance>4000000) {
        distanceLabel.text = [NSString stringWithFormat:@"Distance unavailable. Try again later."];
    }
    else{
        distanceLabel.text = [NSString stringWithFormat:@"You are about %0.02f km from here.",distance/1000];
    }
}

-(void)settingsButtonClicked:(id)sender
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Settings"
                         withValue:[NSNumber numberWithInt:0]];
    
    ASSettingsViewController *settingsViewController = [[ASSettingsViewController alloc]init];
    
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

-(void)nearestStation
{
    //Fetching nearest location.
    
    //Get current location.
    
    
    //Get all data from the repository into an array
    
    //Iterate through the array
    
    //Within the array calculate the distance between the new location and the current location.
    
    //Compare the distance of the new location with the previously calculated location and whichever is less is saved untill next iteration
    
    //Outside the loop, the station dto that is saved becomes the nearest station.
    
    ASStationInfoDTO *savedStation  = nil;
    float savedDistance = 0;
    ASRepositoryService *reposervice= [[ASRepositoryService alloc]init];
    NSMutableArray *stationInfoArray = [reposervice getStationContactInfo];
    
    for (int i=0; i<[stationInfoArray count]; i++) {
        ASStationInfoDTO *tempStationDto = [stationInfoArray objectAtIndex:i];
        
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:tempStationDto.latitude longitude:tempStationDto.longitude];
        
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:self.mUserCurrentLocation.coordinate.latitude longitude:self.mUserCurrentLocation.coordinate.longitude];
        
        float distance = [self kilometresBetweenPlace1:locA andPlace2:locB];
        
        if (i==0) {
            savedDistance  = distance;
            savedStation = tempStationDto;
        }
        else{
            if (savedDistance>=distance) {
                savedDistance = distance;
                savedStation = tempStationDto;
            }
        }
        
    }
    [self scrollToSavedStation:savedStation];
    
    
}

-(float)kilometresBetweenPlace1:(CLLocation*) currentLocation andPlace2:(CLLocation*) place2
{
    
    CLLocationDistance distance = [currentLocation distanceFromLocation:place2];
    NSString *strDistance = [NSString stringWithFormat:@"%.2f", distance];
    NSLog(@"%@",strDistance);
    return [strDistance floatValue];
}

-(void)scrollToSavedStation:(ASStationInfoDTO *)savedStation
{
    NSInteger stateArrayindex = [self.stateArray indexOfObject:savedStation.state];
    [UIView transitionWithView:tableView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionNone
                    animations:^
    {
        [self.m_viewGroupon moveScrollViewTo:stateArrayindex];
    }
                    completion:NULL];
    
    [self menuChangedForStateWithIndex:stateArrayindex];
    [self setUpDistrictForStateIndex:stateArrayindex];
    
    NSInteger districtArrayIndex = [self.districtArray indexOfObject:savedStation.district];
    [UIView transitionWithView:tableView
                      duration:0.9
                       options:UIViewAnimationOptionTransitionNone
                    animations:^
     {
         [self.m_districtViewGroupon moveScrollViewTo:districtArrayIndex];
     }
                    completion:NULL];
    
    [self menuChangedForDistrictWithIndex:districtArrayIndex];
    
}


@end
