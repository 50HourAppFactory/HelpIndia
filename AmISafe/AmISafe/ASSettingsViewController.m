//
//  ASSettingsViewController.m
//  AmISafe
//
//  Created by Sadasivan Arun on 3/27/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASSettingsViewController.h"
#import "CSUtility.h"
#import "CSConstants.h"

@interface ASSettingsViewController ()
{
    IBOutlet UITableView *settingsTableView;
    NSInteger clickedIndex;
}
@property (nonatomic, assign)NSInteger noOfContcts;
@property (nonatomic, strong)NSMutableDictionary *personDetailDict;

-(void)loadTableViewWithData;
@end

@implementation ASSettingsViewController
@synthesize contactListArray, noOfContcts, personDetailDict;
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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Settings";
    
    
    self.trackedViewName = @"Settings View";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTableViewWithData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (aCell == nil)
	{
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (self.noOfContcts == indexPath.row) {
        aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aCell.textLabel.text = @"Add new contact.";
        aCell.detailTextLabel.text = @"";
    }
    else{
        aCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        NSDictionary *contactDict = [self.contactListArray objectAtIndex:indexPath.row];
        
        aCell.textLabel.text = [contactDict objectForKey:@"name"];
        aCell.detailTextLabel.text = [contactDict objectForKey:@"phone"];
    }

    return aCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = self.noOfContcts + 1;
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50.0f;
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.noOfContcts) {
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        // Display only a person's phone, email, and birthdate
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                                   [NSNumber numberWithInt:kABPersonEmailProperty],
                                   [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
        
        
        picker.displayedProperties = displayedItems;
        // Show the picker 
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    clickedIndex = indexPath.row;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Delete Contact", @"Call", @"Cancel",nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    [actionSheet showInView:self.navigationController.view];
    [UIView beginAnimations:nil context:nil];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 240)];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //Delete Contact.
            NSMutableArray *array = [CSUtility getValueForKey:@"ContactList" fromPlistFile:ASSettingsWithExt];
            
            [array removeObjectAtIndex:clickedIndex];
            
            [CSUtility setValueForKey:@"ContactList" withValue:array toPlistFile:ASSettingsWithExt];
            
            [self loadTableViewWithData];
        }
            break;
            
        case 1:
        {
            NSMutableArray *array = [CSUtility getValueForKey:@"ContactList" fromPlistFile:ASSettingsWithExt];
            
            NSDictionary *dict = [array objectAtIndex:clickedIndex];
            
            NSString *contactNumber = [dict objectForKey:@"phone"];
            
            NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", contactNumber];
            NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
            break;
            
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
}


-(void)loadTableViewWithData
{
    self.contactListArray = [CSUtility getValueForKey:@"ContactList" fromPlistFile:ASSettingsWithExt];
    
    self.noOfContcts = [self.contactListArray count];

    [settingsTableView reloadData];
}


// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    
    if(self.personDetailDict!=nil)
    {
        [self.personDetailDict removeAllObjects];
        self.personDetailDict = nil;
    }
    
    self.personDetailDict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString *fullName;
    if(lastName!=nil)
    {
        fullName = [NSString stringWithFormat:@"%@ %@",firstName, lastName];
    }
    else{
        fullName = [NSString stringWithFormat:@"%@",firstName];
    }
    
    [self.personDetailDict setObject:fullName forKey:@"name"];
    
    return TRUE;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        
        NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
        
        [self.personDetailDict setObject:phone forKey:@"phone"];
        
        
        NSMutableArray *array = [CSUtility getValueForKey:@"ContactList" fromPlistFile:ASSettingsWithExt];
        
        if(array==nil)
        {
            array = [[NSMutableArray alloc]initWithCapacity:1];
        }
        
        [array addObject:self.personDetailDict];
        
        [CSUtility setValueForKey:@"ContactList" withValue:array toPlistFile:ASSettingsWithExt];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
					property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return NO;
}

@end
