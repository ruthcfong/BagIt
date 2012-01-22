//
//  SandwichViewController.m
//  BagIt
//
//  Created by Ruth Fong on 12/3/11.
//  Copyright 2011 Harvard College. All rights reserved.
//
// Some code based of Tim Cinel's example code for his Action Picker
// (See the copyright note in ActionSheetPicker.h)

#import "SandwichViewController.h"
#import "ActionSheetPicker.h"
#import	"SidesViewController.h"
#import "Constants.h"
#import "NSString+URLEncoding.h"
//#import "UIViewController+Addons.h"
#import "NSObject+Addons.h"
#import "UserInformation.h"
#import "PickupController.h"
#import "Order.h"

@implementation SandwichViewController

// instance variables
@synthesize itemLabel, optionalLabel, chefsNoteLabel, itemText, breadText, 
cheeseText, dressingText, nextButton, order, entreeOrdered, 
isFirstSandwich, selectedChefs, previousConcat, prevOrderInfo, orderInfo, user;

@synthesize selectedIndex = _selectedIndex;
@synthesize dataArray = _dataArray;
@synthesize itemNames = _itemNames;
@synthesize breads = _breads;
@synthesize selectedBreadIndex = _selectedBreadIndex;
@synthesize cheeses = _cheeses;
@synthesize selectedCheeseIndex = _selectedCheeseIndex;
@synthesize dressings = _dressings;
@synthesize selectedDressingIndex = _selectedDressingIndex;

/* {(id)
 * initIsFirstSandwich: (BOOL) isFirst
 *
 * Initialize new instance of SandwichViewController, taking
 * into account whether or not this instance is suppose to 
 * represent the required first sandwich field.
 */
- (id) initIsFirstSandwich: (BOOL) isFirst
{
	isFirstSandwich = isFirst;
	return self;
}

/* (void)
 * next
 *
 * Display error message if either no item is selected; 
 * otherwise, shows next view.
 */
- (void) next
{	
	// concat sandwich order
	NSString* concat = [self concatSandwichOrder];
	
	// check for an error
	if (concat != nil) 
	{
        // save entree ordered
        entreeOrdered = [[NSMutableString alloc] initWithString:orderInfo];
        
        // prepare for the next part of the order
        if ([orderInfo length] != 0) 
        {
            [orderInfo appendString:@"\n"];
        }
		[orderInfo insertString:prevOrderInfo atIndex:BEGINNING];
		        
        // remember the foods and options ordered
         NSMutableArray* selectedEntreeOptions = [[NSMutableArray alloc] initWithCapacity:4];
    
        [selectedEntreeOptions addObject:[[NSNumber alloc] initWithInt:self.selectedIndex]];
        [selectedEntreeOptions addObject:[[NSNumber alloc] initWithInt:self.selectedBreadIndex]];
        [selectedEntreeOptions addObject:[[NSNumber alloc] initWithInt:self.selectedCheeseIndex]];
        [selectedEntreeOptions addObject:[[NSNumber alloc] initWithInt:self.selectedDressingIndex]];

		// display screen for ordering second sandwich if this screen is
		// for ordering the first entree
		if (isFirstSandwich) 
		{			
            // initialize second sandwich controller
			SandwichViewController *sandwichController2 = 
			[[SandwichViewController alloc] 
			 initWithNibName:@"SandwichViewController" bundle:nil];
			
			// set this sandwich controller to represent the second sandwich
			sandwichController2.isFirstSandwich = NO;
			
			// pass the 2nd sandwich controller the string that should be
			// concatenated to the HUDS website
			sandwichController2.previousConcat = [NSString 
												  stringWithFormat:@"%@%@", 
												  previousConcat, concat];
			
			// pass the next controller the current order information
			sandwichController2.prevOrderInfo = orderInfo;
			
			// set the next screen's title
			sandwichController2.title = @"Entree 2";
			
			// remember whether a chef's salad was ordered
			sandwichController2.selectedChefs = selectedChefs;
			            
            // pass user and order information to next sandwich's controller
            sandwichController2.user = user;
            order.selectedEntree1Indices = selectedEntreeOptions;
            order.entree1Order = entreeOrdered; //[[NSMutableString alloc] initWithString:entreeOrdered];
            sandwichController2.order = order;
            
			// display the next screen
			[self.navigationController pushViewController:sandwichController2 
												 animated:YES];
		}
		
		// display screen for specifying sides if this screen is for
		// ordering the second entree
		else 
		{
			// initialize extra sides controller
			SidesViewController *sidesViewController = 
			[[SidesViewController alloc] 
			 initWithNibName:@"SidesViewController" bundle:nil];
			
			// pass the 2nd sandwich controller the concatenated GET string
			sidesViewController.previousConcat = [NSString 
												   stringWithFormat:@"%@%@", 
												   previousConcat, concat];
			
			// pass the next controller the current order information
			sidesViewController.prevOrderInfo = orderInfo;
			
			// set the view controller's title
			sidesViewController.title = @"Sides";
			
            // pass user & order information to the side view & remember the order 
            sidesViewController.user = user;
            order.selectedEntree2Indices = selectedEntreeOptions;
            order.entree2Order = entreeOrdered;
            sidesViewController.order = order;
            
			// display the view
			[self.navigationController pushViewController:sidesViewController 
												 animated:YES];
		}
	}
}


/* (NSString *)
 * concatSandwichOrder
 *
 * Return a string that stores the configured entree information and 
 * can be appended to the HUDS URL. This method also records the order
 * information in another more human-readable string.
 */

- (NSString *) concatSandwichOrder
{
	// set sandwich prefix based on whether
	// this viewcontroller represents the first sandwich
	NSString *sandwichPrefix = [[NSString alloc] 
								initWithFormat: @"&sandwiches[%i]",
								(isFirstSandwich) ? 0 : 1];
	
	// initialize array of prefixes
	NSArray *prefixes = [[NSArray alloc] initWithObjects:
						 @"[type]=",
						 @"[bread]=",  
						 @"[cheese]=",
						 @"[dressing]=",
						 nil];
	
	// initialize strings that will represent the order
	NSMutableString *concat = [[NSMutableString alloc] initWithString:@""];
	orderInfo = [[NSMutableString alloc] initWithString:@""];
	
	// check if an item is selected
	if (self.selectedIndex == UNSELECTED_ITEM) 
	{
		// if it's the first sandwich, yell at the user and return nil
		// to signal that sandwich selection is required
		if (isFirstSandwich) 
		{
			// display error message
			[self showAlertWithString: 
			 @"You must select at least one sandwich or salad" ];
			
			// release memory
			
			return nil;
		}
		// otherwise, return a blank string
		else 
		{
			return @"";
		}
		
	}
	
    /*
	// if this is the first sandwich, remember whether or not
	// a chef's salad was selected
	if (isFirstSandwich) 
	{
		selectedChefs = (self.selectedIndex == CHEFS_SALAD) ? YES: NO;
        
        // display 
        if (selectedChefs)
        {
            [chefsNoteLabel setText:@"*The Chef's Salad counts as two items. If you order the Chef Salad, other salads or sandwiches will be ignored."];
            [chefsNoteLabel setHidden:false];
        }

	}
	// if the user tries to order a chef's salad and another entree,
	// yell at the user
	else if (selectedChefs || self.selectedIndex == CHEFS_SALAD)
	{
		// show error message
		[self showAlertWithString:
		 @"A chef's salad counts as two entrees. You can't order other entrees \
		 with a chef's salad. Please change your order accordingly."];
		
		// release memory
		[concat release];
		
		return nil;
	}*/
	
	
	// get information about selected item
	NSMutableDictionary *item = [self.dataArray 
								 objectAtIndex:self.selectedIndex];
	
	// remember which prefix to use for which type of food
	int prefixIndex = 0;
	
	// concatenate the sandwich to the string
	switch (self.selectedIndex) 
	{
		// if no sandwich is selected, concatenate nothing
		case UNSELECTED_ITEM:
			break;
		
			// remember if a chef's salad is ordered
		case CHEFS_SALAD:
			selectedChefs = YES;
		
		// concatenate the appropriate string to represent the entree
		default:
			// concatenate appropriate prefix
			[concat appendFormat:@"%@%@", 
			 sandwichPrefix, [prefixes 
							  objectAtIndex:prefixIndex]];
			
			// concatenate item's name appropriately for URL
			[concat appendString:[NSString urlEncodeValue: 
								  [item objectForKey:@"text"]]];
			
			// add item name to string of order information
			[orderInfo appendFormat:@"%@", 
			 [self.itemNames objectAtIndex:self.selectedIndex]];
			
			break;
	}
	
	// prepare to concatenate bread's prefix
	prefixIndex++;
	
	// concatenate the bread, if any, to the string
	switch (self.selectedBreadIndex) 
	{
		// if no bread is selected, concatenate nothing
		case UNSELECTED_SIDE:
			break;
		
		// concatenate the appropriate string to represent the selected bread
		default:
			// concatenate appropriate prefix
			[concat appendFormat:@"%@%@", 
			 sandwichPrefix, [prefixes 
							  objectAtIndex:prefixIndex]];
			
			// concatenate bread's name appropriately for URL
			[concat appendString:[NSString 
								  urlEncodeValue: 
								  [self.breads 
								   objectAtIndex:
								   self.selectedBreadIndex]]];
			
			// add bread's name to readable string about order information
			[orderInfo appendFormat:@", on %@", 
			 [self.breads objectAtIndex:self.selectedBreadIndex]];
			
			break;
	}
	
	// prepare to concatenate cheese's prefix
	prefixIndex++;
	
	// concatenate the cheese, if any, to the string
	switch (self.selectedCheeseIndex) 
	{
		// if nothing is selected, concatenate nothing
		case UNSELECTED_SIDE:
			break;
		
		// if "NO CHEESE" is selected, concatenate "NO" and remember that
		// no cheese is desired
		case NO_CHEESE: 
			// concatenate appropriate prefix
			[concat appendFormat:@"%@%@", 
			 sandwichPrefix, [prefixes
							  objectAtIndex:prefixIndex]];
			
			// concatenate NO string
			[concat appendString:@"NO"];
			
			// add "No Cheese" to order information string
			[orderInfo appendString:@", with no cheese"];
			
			break;
			
		// appropriately concatenate cheese selection for GET method
		default:
			// concatenate appropriate prefix
			[concat appendFormat:@"%@%@", 
			 sandwichPrefix, [prefixes
							  objectAtIndex:prefixIndex]];
			
			// concatenate cheese's name appropriately for URL
			[concat appendString:
			 [NSString urlEncodeValue: 
			  [self.cheeses objectAtIndex:self.selectedCheeseIndex]]];
			
			// add cheese name to order information string
			[orderInfo appendFormat:@", with %@", 
			 [self.cheeses objectAtIndex:self.selectedCheeseIndex]];
			
			break;
	}
	
	// prepare to concatenate dressing's prefix
	prefixIndex++;
	
	// concatenate the dressing, if any, to the string
	switch (self.selectedDressingIndex) 
	{
		// if nothing is selected, concatenate nothing
		case UNSELECTED_SIDE:
			break;
			
		// appropriately concatenate cheese selection for GET method
		default:
			// concatenate appropriate prefix
			[concat appendFormat:@"%@%@", 
			 sandwichPrefix, [prefixes
							  objectAtIndex:prefixIndex]];
			
			// concatenate cheese's name appropriately for URL
			[concat appendString:
			 [NSString urlEncodeValue: 
			  [self.dressings objectAtIndex:self.selectedDressingIndex]]];
			
			// add dressing name to order information string
			[orderInfo appendFormat:@", with %@", 
			 [self.dressings objectAtIndex:self.selectedDressingIndex]];
			
			break;
	}
	
	// release allocated memory
	
	// return concatenated string
	return concat;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// load our data from a plist file inside our app bundle
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Sandwich" 
													 ofType:@"plist"];
	self.dataArray = [NSMutableArray arrayWithContentsOfFile:path];
	
	// remember number of items
	int len = [self.dataArray count];
	
	// initialize array to store item names
	self.itemNames = [[NSMutableArray alloc] initWithCapacity:len];
	
    /*
    // add blank selection
	[self.itemNames addObject:@"select"];
     */
    
	// generate array of item names
	for (int i = 0; i < len; i++) 
	{
		// get item information from dataArray
		NSMutableDictionary *item = [self.dataArray objectAtIndex:i];
		
		// add item name to array storing the names
		[self.itemNames addObject: [item objectForKey:@"text"]];
		
	}
	
    /*
	// add blank selection
	[self.itemNames addObject:@"select"];*/
	
	// remember types of breads, cheeses, and dressings
	self.breads = [[NSArray alloc] initWithObjects:@"select", @"White Bread", 
				   @"Whole Wheat Bread", @"Marble Rye", nil];
	self.cheeses = [[NSArray alloc] initWithObjects:@"select", @"No Cheese",
					@"American", @"Cheddar", @"Swiss", nil];
	self.dressings = [[NSArray alloc] initWithObjects:@"select",
					  @"Blue Cheese", @"Ranch", @"Light Italian", nil];
	
	// set the initial selections to select nothing
	self.selectedIndex = UNSELECTED_ITEM;
	self.selectedBreadIndex = 0;
	self.selectedCheeseIndex = 0;
	self.selectedDressingIndex = 0;
	
	// display initial selections
	[self itemWasSelected:[NSNumber numberWithInteger:self.selectedIndex] 
				  element:itemText];
	[self breadWasSelected:[NSNumber numberWithInteger:self.selectedBreadIndex] 
				   element:breadText];
	[self cheeseWasSelected: [NSNumber numberWithInteger:self.selectedCheeseIndex]
					element:cheeseText];
	[self dressingWasSelected: [NSNumber numberWithInteger:self.selectedDressingIndex] 
					  element:dressingText];

	// set text labels according to whether the view represents the first or second entree
	if (isFirstSandwich) 
	{
		[itemLabel setText:@"Item 1"];
        [optionalLabel setHidden:true];
        
	}
	else 
	{
		[itemLabel setText:@"Item 2"];
        [optionalLabel setHidden:false];
	}
    
    // hide the chef's salad note initially
    [chefsNoteLabel setHidden:true];
	
}

#pragma mark Select Items (i.e. sandwich)

/* (IBAction)
 * selectAnItem:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which entree to order.
 */

- (IBAction)selectAnItem:(UIControl *)sender 
{
    // initialize and show picker
	[ActionSheetPicker showPickerWithTitle:@"Select an Item" 
                                      rows:self.itemNames 
                          initialSelection:self.selectedIndex
                                    target:self
                                    action:@selector(itemWasSelected:element:) 
                                    origin:sender];
	
}

/* (void)
 * itemWasSelected:(NSNumber *)selectedIndex element:(id)element
 *
 * When an entree is selected from the picker, remember which entree
 * was selected and display that entree's name in the appropriate text field
 */

- (void)itemWasSelected:(NSNumber *)selectedIndex element:(id)element 
{
	// remember which entree was selected
    self.selectedIndex = [selectedIndex intValue];
	
	// if the "select" option was selected, display "select"
	if (self.selectedIndex == UNSELECTED_ITEM) 
	{
		[element setText:@"select"];
		return;
	}
	
	// display which entree was selected in the element (i.e. a text field)
    if ([element respondsToSelector:@selector(setText:)]) 
	{
        [element setText:[self.itemNames objectAtIndex:self.selectedIndex]];
    }
	
	// get information about selected item
	NSMutableDictionary *item = [self.dataArray 
								 objectAtIndex:self.selectedIndex];
	
	// show the appropriate options	
	breadText.hidden = ![[item objectForKey:@"needsBread"] boolValue];
	cheeseText.hidden = ![[item objectForKey:@"needsCheese"] boolValue];
	dressingText.hidden = ![[item objectForKey:@"needsDressing"] boolValue];
	
	// set all unnecessary options to unselected
	if (![[item objectForKey:@"needsBread"] boolValue]) 
		self.selectedBreadIndex = UNSELECTED_SIDE;
	if (![[item objectForKey:@"needsCheese"] boolValue]) 
		self.selectedCheeseIndex = UNSELECTED_SIDE;
	if (![[item objectForKey:@"needsDressing"] boolValue]) 
		self.selectedDressingIndex = UNSELECTED_SIDE;
    
    // if this is the first sandwich, remember whether or not
	// a chef's salad was selected
	if (isFirstSandwich) 
	{
		selectedChefs = (self.selectedIndex == CHEFS_SALAD) ? YES: NO;
        
        // if a chef's salad was ordered, display the note about chef's salad
        if (selectedChefs)
        {
            /*[chefsNoteLabel setText:@"*The Chef's Salad counts as two items. If you order the Chef Salad, other salads or sandwiches will be ignored."];*/
            [chefsNoteLabel setHidden:false];
        }
        
	}
	// if the user tries to order a chef's salad and another entree,
	// yell at the user
	else if (selectedChefs || self.selectedIndex == CHEFS_SALAD)
	{
        // if a chef's salad was ordered, display the note about chef's salad
        /*[chefsNoteLabel setText:@"*The Chef's Salad counts as two items. If you order the Chef Salad, other salads or sandwiches will be ignored."];*/
        [chefsNoteLabel setHidden:false];
        
        /*
		// show error message
		[self showAlertWithString:
		 @"A chef's salad counts as two entrees. You can't order other entrees \
		 with a chef's salad. Please change your order accordingly."];
		
		// release memory
		[concat release];
		
		return nil;*/
	}
    
    // hide the note if a chef's salad hasn't been ordered
    if(selectedChefs == false && self.selectedIndex != CHEFS_SALAD)
    {
        [chefsNoteLabel setHidden:true];
    }

	
}

#pragma mark Select Bread

/* (IBAction)
 * selectABread:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which bread, if any/if needed, to be used in making the entree.
 */

- (IBAction)selectABread:(UIControl *)sender 
{
	// initialize and show picker
    [ActionSheetPicker showPickerWithTitle:@"Select Bread" 
                                      rows:self.breads 
                          initialSelection:self.selectedBreadIndex 
                                    target:self
                                    action:@selector(breadWasSelected:element:) 
                                    origin:sender];
	
}

/* (void)
 * breadWasSelected:(NSNumber *)selectedBreadIndex element:(id)element
 * 
 * When a type of bread is selected from the picker, remember which type
 * was selected and display that type of bread's name in the appropriate text field
 */

- (void)breadWasSelected:(NSNumber *)selectedBreadIndex element:(id)element 
{
	// remember which type of bread was selected
    self.selectedBreadIndex = [selectedBreadIndex intValue];
	
	// display the selected bread's name in the appropriate element (i.e. text field)
    if ([element respondsToSelector:@selector(setText:)]) 
	{
        [element setText:[self.breads objectAtIndex:self.selectedBreadIndex]];
    }
}

#pragma mark Select Cheese

/* (IBAction)
 * selectACheese:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which cheese, if any, to use to make the entree.
 */

- (IBAction)selectACheese:(UIControl *)sender 
{
	// initialize and show picker
    [ActionSheetPicker showPickerWithTitle:@"Select Cheese" 
                                      rows:self.cheeses 
                          initialSelection:self.selectedCheeseIndex 
                                    target:self
                                    action:@selector(cheeseWasSelected:element:) 
                                    origin:sender];
	
}

/* (void)
 * cheeseWasSelected:(NSNumber *)selectedCheeseIndex element:(id)element
 * 
 * When a type of cheese is selected from the picker, remember which type
 * was selected and display that type of cheese's name in the appropriate text field
 */

- (void)cheeseWasSelected:(NSNumber *)selectedCheeseIndex element:(id)element 
{
	// remember which type of cheese, if any, was selected
    self.selectedCheeseIndex = [selectedCheeseIndex intValue];
	
	// display selected cheese's name in the appropriate element (i.e. text field)
    if ([element respondsToSelector:@selector(setText:)]) 
	{
        [element setText:[self.cheeses objectAtIndex:self.selectedCheeseIndex]];
    }
}

#pragma mark Select Dressing

/* (IBAction)
 * selectADressing:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which dressing, if any, to add to the order.
 */

- (IBAction)selectADressing:(UIControl *)sender 
{
	// initialize and show picker
    [ActionSheetPicker showPickerWithTitle:@"Select Dressing" 
                                      rows:self.dressings 
                          initialSelection:self.selectedDressingIndex 
                                    target:self
                                    action:@selector(dressingWasSelected:element:) 
                                    origin:sender];
	
}

/* (void)
 * dressingWasSelected:(NSNumber *)selectedDressingIndex element:(id)element
 *
 * When a type of dressing is selected from the picker, remember which type
 * was selected and display that dressing's name in the appropriate text field
 */

- (void)dressingWasSelected:(NSNumber *)selectedDressingIndex element:(id)element 
{
	// remember which type of dressing was selected
    self.selectedDressingIndex = [selectedDressingIndex intValue];
    
	// display the selected dressing's name in the appropriate element (i.e. text field)
	if ([element respondsToSelector:@selector(setText:)]) 
	{
        [element setText:[self.dressings objectAtIndex:self.selectedDressingIndex]];
    }
}



 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	 // Return YES for supported orientations.
	 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	// Release allocated memory
    self.itemLabel = nil;
    self.optionalLabel = nil;
    self.chefsNoteLabel = nil;
    self.itemText = nil;
    self.breadText = nil;
    self.cheeseText = nil;
    self.dressingText = nil;
    self.nextButton = nil;
    self.entreeOrdered = nil;
    self.orderInfo = nil;
	self.itemNames = nil;
	self.breads = nil;
	self.cheeses = nil;
	self.dressings = nil;
    self.dataArray = nil;
    self.itemNames = nil;
    //self.user = nil;
}


@end
