//
//  ASSettingsViewController.h
//  AmISafe
//
//  Created by Sadasivan Arun on 3/27/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "GAITrackedViewController.h"
@interface ASSettingsViewController : GAITrackedViewController<ABPeoplePickerNavigationControllerDelegate,
    ABPersonViewControllerDelegate,
    ABNewPersonViewControllerDelegate,
    ABUnknownPersonViewControllerDelegate>

@property (nonatomic, strong)NSMutableArray *contactListArray;
@end
