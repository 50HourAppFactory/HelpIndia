//
//  ASViewController.m
//  AmISafe
//
//  Created by Sadasivan Arun on 3/26/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASViewController.h"
#import "ASStationInfoDTO.h"
#import "ASStationInfoService.h"

#import "UIGlossyButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+LayerEffects.h"

#import "ASMapViewController.h"
#import "ASSettingsViewController.h"
#import "ASLocationMapViewController.h"

#import "ASSlider.h"
#import "ASSMSComposerViewController.h"
#import "CSUtility.h"
#import "CSConstants.h"

@interface ASViewController ()
{
    IBOutlet UIView *borderView;
}

@property (nonatomic, strong)NSMutableArray *contactArray;
@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, strong)UITableViewCell *tblViewCell;



#define BUTTONMAP 1000
#define BUTTONCALL 1001


-(void)setForSelectedTableView:(UITableView *)tableView;
-(void)setForNormalTableView:(UITableView *)tableView;
-(void)setupAlertButton;
-(void)setupView;
-(void)getCurrentLocation;

- (IBAction)alertButtonClicked:(id)sender;
- (IBAction)sliderDrag:(id)sender;
@end

@implementation ASViewController
@synthesize contactArray, selectedIndex;
@synthesize tblViewCell;
@synthesize mUserCurrentLocation, mLocationManager;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if(self.mUserCurrentLocation==nil)
    {
        self.mUserCurrentLocation = [[CLLocation alloc] init];
    }
    ASStationInfoService *service = [[ASStationInfoService alloc]init];
    self.contactArray = [service getPoliceContacts];
    self.navigationItem.title = @"AmISafe";
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings.png" ] style:UIBarButtonItemStyleBordered target:self action:@selector(settingsButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    [self setupAlertButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCurrentLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Methods
#pragma mark -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectedIndex==indexPath.row)
    {
        [self setForSelectedTableView:tableView];
    }
    else{
        [self setForNormalTableView:tableView];

    }
    
    UILabel *lblTitle = (UILabel *)[self.tblViewCell viewWithTag:1002];
    UILabel *lblSubtitle =(UILabel *)[self.tblViewCell viewWithTag:1003];
    
    ASStationInfoDTO *stationInfoDto = [self.contactArray objectAtIndex:indexPath.row];
    lblTitle.text = stationInfoDto.name;
    lblSubtitle.text = [NSString stringWithFormat:@"Tel: %@", stationInfoDto.contactNo];

    return tblViewCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = [self.contactArray count];

    
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50.0f;
    if (indexPath.row == self.selectedIndex) {
        height = 107.0f;
    }
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.selectedIndex = indexPath.row;
    
    [UIView transitionWithView:tableView
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{  [tableView reloadData]; }
                    completion:NULL];
    
}

#pragma mark -
#pragma mark Table view related Methods
#pragma mark -

-(void)setForSelectedTableView:(UITableView *)tableView
{
    static NSString *cell_identifier=@"ASSelectedContactCell";
    self.tblViewCell=[tableView dequeueReusableCellWithIdentifier:cell_identifier];
    NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ASSelectedContactCell" owner:self options:nil];
    if([nib count]>0)
    {
        self.tblViewCell=[nib objectAtIndex:0];
    }
    
    UIGlossyButton *b;
    
    b = (UIGlossyButton*) [self.tblViewCell viewWithTag: BUTTONMAP];
	[b useWhiteLabel: YES];
    b.tintColor = [UIColor darkGrayColor];
	[b setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
    
    [b addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    b = (UIGlossyButton*) [self.tblViewCell viewWithTag: BUTTONCALL];
	[b useWhiteLabel: YES];
    b.tintColor = [UIColor darkGrayColor];
    [b setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
    [b addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setForNormalTableView:(UITableView *)tableView
{
    static NSString *cell_identifier=@"ASContactCell";
    self.tblViewCell=[tableView dequeueReusableCellWithIdentifier:cell_identifier];
    NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ASContactCell" owner:self options:nil];
    if([nib count]>0)
    {
        self.tblViewCell=[nib objectAtIndex:0];
    }
}


-(void)callButtonClicked:(id)button
{
    ASStationInfoDTO *stationInfoDto = [self.contactArray objectAtIndex:self.selectedIndex];
    
    NSString *phoneNumber = stationInfoDto.contactNo; // dynamically assigned
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

-(void)mapButtonClicked:(id)button
{
    ASStationInfoDTO *stationInfoDto = [self.contactArray objectAtIndex:self.selectedIndex];
    
    ASLocationMapViewController *locationViewController = [[ASLocationMapViewController alloc]initWithInfo:stationInfoDto];
    
    
    [self.navigationController pushViewController:locationViewController animated:YES];
    
    
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


-(void)settingsButtonClicked:(id)sender
{
    ASSettingsViewController *settingsViewController = [[ASSettingsViewController alloc]init];
    
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

//Location related changes.
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
}




@end
