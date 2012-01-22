//
//  PickupController.h
//  BagIt
//
//  Created by Ruth Fong on 12/3/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickupInformation.h"
#import "ActionSheetPicker.h"
#import "BreakfastItemController.h"
#import "SandwichViewController.h"
#import "UserInformation.h"
#import "Order.h"

@interface PickupController : UIViewController <UITextFieldDelegate, ActionSheetPickerDelegate>
{
	// instance variables
	PickupInformation *pickupInfo;
	UITextField *locationText;
	UITextField *dateText;
	UITextField *timeText;
	BreakfastItemController *breakfastItemController;
	SandwichViewController *sandwichController;
    UserInformation* user;
    Order* order;
}

// getter/setter prototypes
@property (nonatomic, strong) SandwichViewController *sandwichController;
@property (nonatomic, strong) BreakfastItemController *breakfastItemController;
@property (nonatomic, strong) PickupInformation *pickupInfo;
@property (nonatomic, strong) IBOutlet UITextField *locationText;
@property (nonatomic, strong) IBOutlet UITextField *dateText;
@property (nonatomic, strong) IBOutlet UITextField *timeText;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) NSArray *times;
@property (nonatomic, strong) NSMutableArray *displayTimes;
@property (nonatomic, strong) NSMutableArray *dateKeys;
@property (nonatomic, strong) NSMutableArray *dateObjects;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedTimeIndex;
@property (nonatomic, assign) NSInteger selectedDateIndex;
@property (nonatomic, strong) ActionSheetPicker *actionSheetPicker;
@property (nonatomic, strong) UserInformation *user;
@property (nonatomic, strong) Order *order;

// method prototypes
- (IBAction)next:(id)sender;
- (IBAction)selectALocation:(id)sender;
- (IBAction)selectATime: (id)sender;
- (IBAction)selectADate:(id)sender;
- (void)dateWasSelected:(NSNumber *)selectedDate element:(id)element;
- (void)locationWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)timeWasSelected:(NSNumber *)selectedTime element:(id)element;
- (void)actionPickerCancelled;
- (void)actionPickerDoneWithValue:(id)value;

@end
