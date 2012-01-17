//
//  RootViewController.h
//  BagIt
//
//  Created by Ruth Fong on 11/24/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformation.h"
@class PickupController;

@interface RootViewController : UIViewController
{
	// instance variables
	NSArray *meals;
	PickupController *pickupController;
    UserInformation *user;
}

// getter/setter prototypes
@property (nonatomic, retain) IBOutlet PickupController *pickupController;
@property (nonatomic, retain) NSArray *meals;
@property (nonatomic, retain) UserInformation* user;

@end