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

@interface PickupController : UIViewController <UITextFieldDelegate, ActionSheetPickerDelegate>
{
	// instance variables
	PickupInformation *pickupInfo;
	UITextField *locationText;
	UITextField *dateText;
	UITextField *timeText;
	BreakfastItemController *breakfastItemController;
	SandwichViewController *sandwichController;
}

// getter/setter prototypes
@property (nonatomic, retain) SandwichViewController *sandwichController;
@property (nonatomic, retain) BreakfastItemController *breakfastItemController;
@property (nonatomic, retain) PickupInformation *pickupInfo;
@property (nonatomic, retain) IBOutlet UITextField *locationText;
@property (nonatomic, retain) IBOutlet UITextField *dateText;
@property (nonatomic, retain) IBOutlet UITextField *timeText;
@property (nonatomic, retain) NSArray *locations;
@property (nonatomic, retain) NSArray *times;
@property (nonatomic, retain) NSMutableArray *displayTimes;
@property (nonatomic, retain) NSMutableArray *dateKeys;
@property (nonatomic, retain) NSMutableArray *dateObjects;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedTimeIndex;
@property (nonatomic, assign) NSInteger selectedDateIndex;
@property (nonatomic, retain) ActionSheetPicker *actionSheetPicker;

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
