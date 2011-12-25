//
//  RootViewController.h
//  BagIt
//
//  Created by Ruth Fong on 11/24/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickupController;

@interface RootViewController : UITableViewController 
{
	// instance variables
	NSArray *meals;
	PickupController *pickupController;
}

// getter/setter prototypes
@property (nonatomic, retain) IBOutlet PickupController *pickupController;
@property (nonatomic, retain) NSArray *meals;

@end