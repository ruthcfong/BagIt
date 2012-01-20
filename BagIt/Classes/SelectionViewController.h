//
//  SelectionViewController.h
//  BagIt
//
//  Created by Ruth Fong on 11/24/11.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformation.h"
#import "Order.h"
@class PickupController;

@interface SelectionViewController : UITableViewController 
{
	// instance variables
	NSArray *meals;
	PickupController *pickupController;
    UserInformation *user;
    Order* order;
}

// getter/setter prototypes
@property (nonatomic, retain) IBOutlet PickupController *pickupController;
@property (nonatomic, retain) NSArray *meals;
@property (nonatomic, retain) UserInformation* user;
@property (nonatomic, retain) Order* order;

@end