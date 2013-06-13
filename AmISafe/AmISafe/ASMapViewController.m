//
//  ASMapViewController.m
//  AmISafe
//
//  Created by Sadasivan Arun on 3/27/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASMapViewController.h"

#define URLMAINSCHEMEFORDIRECTIONS @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&view=map&output=embed"
#define URLMAINSCHEME @"http://maps.google.com/maps?saddr=%f,%f&view=map&output=embed"

@interface ASMapViewController ()
{
    ASStationInfoDTO *mStationInfoDto;
    IBOutlet UIWebView *googleMapView;
}
-(NSString *)generateUrlLinkForGoogle;

@end

@implementation ASMapViewController

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
    NSString *urlString = [self generateUrlLinkForGoogle];
    NSURL *url = [NSURL URLWithString:urlString];
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //Load the request in the UIWebView.
    [googleMapView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)generateUrlLinkForGoogle
{
    NSString *urlString= [NSString stringWithFormat:URLMAINSCHEME,mStationInfoDto.latitude,mStationInfoDto.longitude];

    return urlString;
}

@end
