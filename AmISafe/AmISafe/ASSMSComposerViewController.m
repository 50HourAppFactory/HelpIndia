//
//  ASSMSComposerViewController.m
//  AmISafe
//
//  Created by Sadasivan Arun on 4/4/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASSMSComposerViewController.h"

@interface ASSMSComposerViewController ()

@end

@implementation ASSMSComposerViewController
@synthesize messageString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize numberArray;

-(id)initWithSingleNumber:(NSDictionary *)dict
{
    self = [super init];
    
    if(self)
    {
        [self.numberArray addObject:dict];
    }
    return self;
    
}
-(id)initWithAllNumber:(NSMutableArray *)array
{
    self = [super init];
    
    if(self)
    {
        self.numberArray = array;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"Alert"];
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 320, 200)];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.text = @"Sorry. SMS is not supported in this device.";
            [self.view addSubview:label];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *smsComposeViewController = [[MFMessageComposeViewController alloc] init];
    smsComposeViewController.messageComposeDelegate = self;
    NSMutableArray *arrayOfNumbers = [[NSMutableArray alloc]initWithCapacity:1];
    for (NSDictionary *dict in self.numberArray) {
        [arrayOfNumbers addObject:[dict objectForKey:@"phone"]];
    }
    smsComposeViewController.recipients = arrayOfNumbers;
    smsComposeViewController.body = self.messageString;
    [self presentViewController:smsComposeViewController animated:NO completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
