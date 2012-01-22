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
@property (nonatomic, strong) IBOutlet PickupController *pickupController;
@property (nonatomic, strong) NSArray *meals;
@property (nonatomic, strong) UserInformation* user;
@property (nonatomic, strong) Order* order;

@end