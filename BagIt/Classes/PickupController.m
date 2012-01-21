//
//  PickupController.m
//  BagIt
//
//  Created by Ruth Fong on 12/3/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import "PickupController.h"
#import "NSDate+TCUtils.h"
#import "NSDate.h"
#import "Constants.h"
#import "UserInformation.h"
#import "SelectionViewController.h"
#import "Order.h"

@implementation PickupController

// instance variables
@synthesize pickupInfo, locationText, dateText, timeText,
	breakfastItemController, sandwichController, user, order;

@synthesize locations = _locations;
@synthesize times = _times;
@synthesize displayTimes = _displayTimes;
@synthesize dateKeys = _dateKeys;
@synthesize dateObjects = _dateObjects;

@synthesize selectedIndex = _selectedIndex;
@synthesize selectedTimeIndex = _selectedTimeIndex;
@synthesize selectedDateIndex = _selectedDateIndex;
@synthesize actionSheetPicker = _actionSheetPicker;


- (void) viewDidLoad
{
    [super viewDidLoad];
    
	// initialize an instance of PickupInformation and set what meal is
	// being ordered
	if (pickupInfo == nil) 
	{
		if ([self.title isEqualToString:@"Breakfast"]) 
		{
			pickupInfo = [[PickupInformation alloc] initMeal: BREAKFAST];
		}
		else if ([self.title isEqualToString:@"Lunch"])
		{
			pickupInfo = [[PickupInformation alloc] initMeal: LUNCH];
		}
		else 
		{
			pickupInfo = [[PickupInformation alloc] initMeal: DINNER];
		}
	}
	
	// set location names and pick-up times to display
    self.locations = pickupInfo.locationNames;
	self.times = pickupInfo.possibleTimes;
	
	// initialize array of the times to display as strings, 
	// including a empty "select" time
	self.displayTimes = [[[NSMutableArray alloc] 
						 initWithCapacity:[self.times count]] autorelease];
	[self.displayTimes addObject:@"select"];
	
	// add times to display to an array
	for (NSDate *time in self.times) 
	{
		[self.displayTimes addObject:[time toTime]];
	}
	
	// initialize arrays of keys and objects of dates to display
	self.dateKeys = [[NSMutableArray alloc] initWithCapacity:DAYS_IN_WEEK];
    self.dateObjects = [[NSMutableArray alloc] initWithCapacity:DAYS_IN_WEEK];
    
	// fill keys and object arrays with 7 days starting with tomorrow
	for (int i = 0; i < DAYS_IN_WEEK; i++) 
	{
        // check if the order is being made before 4am
        NSDate* fourAM = [NSDate dateWithNaturalLanguageString:@"today at 4am"];
        NSDate* today = [NSDate date];
        int startDate = ([today compare:fourAM] == NSOrderedAscending) ? 0 : 1;
        NSLog(@"%i", startDate);
        
		// create a NSDate object that's i days after tomorrow
		// and add to an array of NSDate objects
		[self.dateObjects addObject: [[NSDate date] 
									  dateByAdddingCalendarUnits:NSDayCalendarUnit 
									  amount:+startDate+i]];
		
		// create and add the string version of the just-created date
		// to an array of keys
		[self.dateKeys addObject: [[self.dateObjects objectAtIndex:i] toDate]];
		
	}
	
	// set and display initial location, date, and time to 
	// Annenverg, tomorrow, and nothing respectively
	self.selectedIndex = 1;
	self.selectedDateIndex = 0;
	self.selectedTimeIndex = 0;
	
	[self locationWasSelected: [NSNumber numberWithInteger:self.selectedIndex] 
					  element:locationText];
	[self dateWasSelected: [NSNumber numberWithInteger:self.selectedDateIndex] 
				  element:dateText];
	[self timeWasSelected: [NSNumber numberWithInteger:self.selectedTimeIndex]
				  element:timeText];
	
}

- (void)viewDidUnload 
{
	// release allocated memory
	self.locations = nil;
	self.dateKeys = nil;
	self.dateObjects = nil;
	self.displayTimes = nil;
    self.actionSheetPicker = nil;
	//self.user = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)next:(id)sender
{
	// set the pick-up date, location, and time, if one's provided
	pickupInfo.date = [self.dateObjects objectAtIndex:self.selectedDateIndex];
	pickupInfo.location = [pickupInfo.locationNames objectAtIndex: 
						   self.selectedIndex];
	
	if (self.selectedTimeIndex == 0) 
	{
		pickupInfo.time = nil;
	}
	else
	{
		pickupInfo.time = [pickupInfo.possibleTimes objectAtIndex: 
						   self.selectedTimeIndex-1];
	}
	
    
    // save pickup options
    NSMutableArray* selectedPickupOptions = [[NSMutableArray alloc] initWithCapacity:4];
    [selectedPickupOptions addObject:[[NSNumber alloc] initWithInt:self.selectedIndex]];
    [selectedPickupOptions addObject:[[NSNumber alloc] initWithInt:self.selectedDateIndex]];
    [selectedPickupOptions addObject:[[NSNumber alloc] initWithInt:self.selectedTimeIndex]];
    order.selectedPickupOptions = [[NSMutableArray alloc] initWithArray: selectedPickupOptions];
    
    [selectedPickupOptions release];
    
	// display either the breakfast item or sandwich item view,
	// depending on meal
	if (pickupInfo.meal == BREAKFAST) 
	{
		// initialize breakfast controller
		breakfastItemController = [[BreakfastItemController alloc] 
								   initWithNibName:@"BreakfastItemController" 
								   bundle:nil];
		
		// concatenate appropriate string for a HTTP GET post
		NSString* concat = [pickupInfo buildConcat];
		
		// check if there were any errors
		if (concat != nil) 
		{
			// pass the breakfast controller the concatenated GET string
			breakfastItemController.pickupConcat = [pickupInfo buildConcat];
			
			
			// pass the breakfast controller the order information
			breakfastItemController.prevOrderInfo = [pickupInfo orderInfo];
			
			// set the view controller's title
			breakfastItemController.title = @"Select 5 items";
			
            // pass user and order information to breakfast view
            breakfastItemController.user = user;
            breakfastItemController.order = order;
            
            // display the view
			[self.navigationController pushViewController:breakfastItemController 
												 animated:YES];
			
		}
	}
	else 
	{
		// initialize sandwich controller
		sandwichController = [[SandwichViewController alloc] 
							  initWithNibName:@"SandwichViewController" 
							  bundle:nil];
		// set this sandwich controller to represent the first sandwich
		sandwichController.isFirstSandwich = YES;
		
		// concatenate appropriate string for a HTTP GET post
		NSString* concat = [pickupInfo buildConcat];
		
		// check if there were any errors
		if (concat != nil) 
		{
			// pass the sandwich controller the concatenated GET string
			sandwichController.previousConcat = [pickupInfo buildConcat];
			
			// pass the sandwich controller the order information
			sandwichController.prevOrderInfo = [pickupInfo orderInfo];
			
            // pass user and order information to sandwich view
            sandwichController.user = user;
            sandwichController.order = order;
            
			// set the view controller's title
			sandwichController.title = @"Entree 1";
            
			// display the view
			[self.navigationController pushViewController:sandwichController 
												 animated:YES];
			
		}
	}
	
}

/* (IBAction)
 * selectALocation:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which location to pick up the order.
 */

- (IBAction)selectALocation:(UIControl *)sender 
{
	// Instantiate and display a picker with the possible pick-up locations
    [ActionSheetPicker showPickerWithTitle:@"Select a Location" 
                                      rows:self.locations 
                          initialSelection:self.selectedIndex 
                                    target:self
                                    action:@selector(locationWasSelected:element:) 
                                    origin:sender];
    
}

/* (IBAction)
 * selectATime:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which time to pick up the order.
 */

- (IBAction)selectATime:(UIControl *)sender 
{
	// Instantiate and display a picker with the possible pick-up times
    [ActionSheetPicker showPickerWithTitle:@"Select a Time"  
                                      rows:self.displayTimes 
                          initialSelection:self.selectedTimeIndex
                                    target:self
                                    action:@selector(timeWasSelected:element:) 
                                    origin:sender];
    
}

/* (IBAction)
 * selectADate:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which day to pick up the order.
 */
- (IBAction)selectADate:(UIControl *)sender 
{
	// Instantiate and display a picker with the possible pick-up dates
	[ActionSheetPicker showPickerWithTitle:@"Select a Date"  
                                      rows:self.dateKeys
                          initialSelection:self.selectedDateIndex
                                    target:self
                                    action:@selector(dateWasSelected:element:) 
                                    origin:sender];

}


#pragma mark -
#pragma mark Implementation

/* (void)
 * locationWasSelected:(NSNumber *)selectedIndex element:(id)element
 *
 * When a location is selected from the picker, remember which location
 * was selected and display that locations's name in the appropriate text field
 */

- (void)locationWasSelected:(NSNumber *)selectedIndex element:(id)element
{
	// remember which location was selected
    self.selectedIndex = [selectedIndex intValue];
    
	// display location's name in element (i.e. location text field)
	if ([element respondsToSelector:@selector(setText:)]) 
	{
        [element setText:[self.locations objectAtIndex:self.selectedIndex]];
    }
}

/* (void)
 * dateWasSelected:(NSNumber *)selectedDateIndex element:(id)element
 *
 * When a date is selected from the picker, remember which date
 * was selected and display that date in the appropriate text field
 */

- (void)dateWasSelected:(NSNumber *)selectedDateIndex element:(id)element 
{
    // remember which date was selected
	self.selectedDateIndex = [selectedDateIndex intValue];
    
	// display the date in element (i.e. date text field)
	if ([element respondsToSelector:@selector(setText:)]) 
	{
        [element setText:[self.dateKeys objectAtIndex: self.selectedDateIndex]];
    }
}

/* (void)
 * timeWasSelected:(NSNumber *)selectedTimeIndex element:(id)element
 *
 * When a time is selected from the picker, remember which time
 * was selected and display that time in the appropriate text field
 */

- (void)timeWasSelected:(NSNumber *)selectedTimeIndex element:(id)element 
{
	// remember the selected time
    self.selectedTimeIndex = [selectedTimeIndex intValue];
	
	// display the selected time in element (i.e. time text field)
    if ([element respondsToSelector:@selector(setText:)]) 
	{
        [element setText:[self.displayTimes objectAtIndex:self.selectedTimeIndex]];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark -
#pragma mark Memory Management

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// Release allocated memory
- (void)dealloc 
{
    [self.pickupInfo release];
    [self.locations release];
	[self.dateKeys release];
	[self.dateObjects release];
	[self.displayTimes release];
    [self.actionSheetPicker release];
    //[self.user release];
    [super dealloc];
}

#pragma - ActionSheetPickerDelegate

- (void)actionPickerCancelled {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

- (void)actionPickerDoneWithValue:(id)value {
    NSLog(@"Delegate has been informed that ActionSheetPicker completed with value: %@", value);
}

@end