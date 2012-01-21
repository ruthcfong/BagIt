//
//  SidesViewController.m
//  BagIt
//
//  Created by Ruth Fong on 12/5/11.
//  Copyright 2011 Harvard College. All rights reserved.
//
//	Some code based of Tim Cinel's example code for his Action Picker
// (See the copyright note in ActionSheetPicker.h)

#import "SidesViewController.h"
#import "ActionSheetPicker.h"
#import "NSString+URLEncoding.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "ConnectionDelegate.h"
#import "UserInformation.h"
#import "CJSONDeserializer.h"
#import "NSObject+Addons.h"
#import "SelectionViewController.h"
#import "SandwichViewController.h"

@implementation SidesViewController

// synthesize instance variables
@synthesize drinkText, fruitText, snack1Text, snack2Text, previousConcat, 
thisConcat, prevOrderInfo, orderInfo, foodsOrdered, user, didWork, loadingModal, order;

// synthesize private variables
@synthesize drinks = _drinks;
@synthesize	selectedDrinkIndex = _selectedDrinkIndex;
@synthesize fruits = _fruits;
@synthesize selectedFruitIndex = _selectedFruitIndex;
@synthesize snacks = _snacks;
@synthesize selectedSnack1Index = _selectedSnack1Index;
@synthesize selectedSnack2Index = _selectedSnack2Index;
@synthesize data=_data;

- (id)init
{
    self = [super init];
    
    if (self) {
        self.data = [[NSMutableData alloc] init];
    }
    
    return self;
}

#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    [self.data setLength:0];
    NSLog(@"Yay! Connection was made.");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    // save received data
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    // hide loading modal
	[loadingModal hide:YES];
    
    NSError* error = nil;
    NSDictionary* responseData = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data 
                                                                                     error:&error];
    if (!error) 
    {
        NSLog(@"%@", [responseData valueForKey:@"didWork"]);
        didWork = [responseData valueForKey:@"didWork"];
        
        if ([didWork isEqualToString:@"yes"]) 
        {
            NSLog(@"Yay!");
			
            // delete user information
            //[self.user release];
            //[self.user initWithHUID:@"" andPIN:@""];
            
            // create popup alert
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Order Submitted"
                                                              message:@"Your order has been successfully submitted.\n\nDo you want to logout or place another order?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Order"
                                                    otherButtonTitles:@"Logout", nil];
            
            // show alert
            [message show];
            
            // release memory
            [message release];
        }
        else
        {
            // display error message
            [self showAlertWithString: @"Order couldn't be submitted. Please try again."];
        }
        
    }
    else
    {
        NSLog(@"%@", error);
    }
    
    [error release];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    // Show error
	NSLog(@"something very bad happened here: %@", error);
    
    // hide loading modal
	[loadingModal hide:YES];
}


/* (IBAction)
 * submit
 *
 * Construct a string that can be appended to the HUDS URL using a 
 * GET submission, confirm that the user indeed wants to submit this order,
 * and submit the order using a GET submission.
 */

- (IBAction) submit
{
	// concat side order
	thisConcat = [self concatSideOrder];
}

/* (NSString *)
 * concatSideOrder
 *
 * Return a string that can represents the side order and can be appended to
 * the URL of HUDS using a GET submission.
 */

- (NSString *) concatSideOrder
{
	// initialize array of prefixes
	NSArray *prefixes = [[NSArray alloc] initWithObjects:
						 @"&drink=",
						 @"&fruit=",  
						 @"&snacks[0]=",
						 @"&snacks[1]=",
						 nil];
	
	// initialize strings that will represent and remember the order
	NSMutableString *concat = [[NSMutableString alloc] initWithString:@""];
	orderInfo = [[NSMutableString alloc] initWithString:@""];
	
	// initialize an array to store the arrays of side options
	NSArray *arrOfSides = [[NSArray alloc] initWithObjects:
						   self.drinks, self.fruits, self.snacks, nil];
	
	// initialize an array to store the indexes of the selected sides
	NSInteger arrOfSelections[NUM_OF_SIDES] = {self.selectedDrinkIndex,
		self.selectedFruitIndex, self.selectedSnack1Index, 
		self.selectedSnack2Index};
	
	// iterate through each type of side, concatenating the appropriate string
	// if a side was selected
	for (int i = 0; i < NUM_OF_SIDES; i++) 
	{
		// account for the fact that snacks 1 & 2 use the same array of snacks
		int indexOfSide;
		if (i == ON_SECOND_SNACK) 
		{
			indexOfSide = i-1;
		}
		else 
		{
			indexOfSide = i;
		}
		
		// remember selected current side
		int selectedIndex = arrOfSelections[i];
		
		// concatenate string if something has been
		// selected for the current side 
		switch (selectedIndex) 
		{
			// concatenate nothing if no side was selected
			case UNSELECTED:
				break;
			default:
				// concatenate appropriate prefix
				[concat appendFormat:@"%@", [prefixes
											 objectAtIndex:i]];
				
				// concatenate side's name appropriately for URL
				[concat appendString:
				 [NSString urlEncodeValue:[[arrOfSides objectAtIndex:indexOfSide] 
											objectAtIndex:selectedIndex]]];
				
				// add side's name to order information & foodsOrdered strings
				[orderInfo appendFormat:@"%@\n", 
				 [[arrOfSides objectAtIndex:indexOfSide] 
				  objectAtIndex:selectedIndex]];
                [foodsOrdered appendFormat:@"%@\n", 
				 [[arrOfSides objectAtIndex:indexOfSide] 
				  objectAtIndex:selectedIndex]];

				
				break;
		}
	}
	
	// Show Submit popup alert
	[self showSubmitAlert];
	// Release memory
	[arrOfSides release];
	
	// Return concatenated string
	return concat;
}

/* (void)
 * showSubmitAlert
 *
 * Display an UIAlertView showing the user his/her order and prompting
 * him/her to click "Submit" to submit the order or "Cancel" to go back
 * and modify his/her order.
 */
- (void) showSubmitAlert
{
    // remember the sides ordered
    order.sideOrder = [[NSMutableString alloc] initWithString:orderInfo];
	// synthesize order information to display in popup message
	[orderInfo insertString:prevOrderInfo atIndex:BEGINNING];
	
	// create popup alert
	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Submit Order"
													  message:orderInfo
													 delegate:self
											cancelButtonTitle:@"Cancel"
											otherButtonTitles:@"Submit", nil];
	// show alert
	[message show];
	
	// release memory
	[message release];
	
	return;
}

/* (void)
 * alertView:(UIAlertView *)alertView 
 * clickedButtonAtIndex:(NSInteger)buttonIndex
 *
 * If the "Submit" button is pressed on the popup alert, "submit" the order by
 * displaying the concatenated string representing the order in the Console.
 */
- (void)alertView:(UIAlertView *)alertView 
	clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// remember button's name
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	
	// check if "Submit" button was clicked
    if([title isEqualToString:@"Submit"])
    {
        
        // remember the foods and options ordered
        NSMutableArray* selectedSideOptions = [[NSMutableArray alloc] initWithCapacity:4];
        
        [selectedSideOptions addObject:[[NSNumber alloc] initWithInt:self.selectedDrinkIndex]];
        [selectedSideOptions addObject:[[NSNumber alloc] initWithInt:self.selectedFruitIndex]];
        [selectedSideOptions addObject:[[NSNumber alloc] initWithInt:self.selectedSnack1Index]];
        [selectedSideOptions addObject:[[NSNumber alloc] initWithInt:self.selectedSnack2Index]];
        
        order.selectedSideIndices = selectedSideOptions;
        
        NSString* getURL = [NSString stringWithFormat:@"http://www.dining.harvard.edu/myhuds/students/%@%@",previousConcat, thisConcat];
        
       // NSLog(@"%@", getURL);
        
        // remember the custom URL & human-readable string that represent the order
        order.orderURL = getURL;
        order.orderInformation = orderInfo;
        
        //NSLog(@"%@", order.orderInformation);
        
        // remember the url
        NSURL *url = [NSURL URLWithString: @"https://cloud.cs50.net/~ruthfong/pin.php"]; 
        
        // setup the request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                
        // setup the data to be submitted
        NSData *requestData = [[NSString stringWithFormat:@"huid=%@&password=%@&url=%@", user.huid, user.pin, [NSString urlEncodeValue:getURL]]dataUsingEncoding:NSUTF8StringEncoding];
        
        // setup HTTP headers
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*//*;q=0.8" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        //ConnectionDelegate* d = [[ConnectionDelegate alloc] init];
        
        // setup connection and start the connection
        
        // initialize a data object to save HTTP response body
        self.data = [[NSMutableData alloc] init];

        NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        [myConnection start];
        
        // show loading modal
        loadingModal = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
        loadingModal.labelText = @"Loading";
    }
    
    // check if the logout button was clicked
    else if([title isEqualToString:@"Logout"])
    {
        // delete user information
        [user release];
        
        
        // Go back to the root controller
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
             
    // check if the user wants to place another order
    else if([title isEqualToString:@"Order"])
    {
        /*int count = [self.navigationController.viewControllers count];
        SandwichViewController* prevController = [self.navigationController.viewControllers objectAtIndex:count-2];
        
        prevController.anotherOrder = true;
        
        [self.navigationController popViewControllerAnimated: NO];*/
        
        SelectionViewController * selectionViewController = [self.navigationController.viewControllers objectAtIndex:1];
        //selectionViewController.user = [[UserInformation alloc] initWithUser:user];
        [self.navigationController popToViewController:selectionViewController animated:NO];
       
        /*
        // initialize the next view to select a meal
        SelectionViewController *selectionViewController = 
        [[SelectionViewController alloc] 
         initWithNibName:@"SelectionViewController" bundle:nil];
        
        // set the view controller's title
        selectionViewController.title = @"Select a meal";
        
        // pass user information to next view
        selectionViewController.user = user;
        
        // display the view
        [self.navigationController pushViewController:selectionViewController 
                                             animated:YES]; 
        
       //[self.navigationController popViewControllerAnimated: NO];
         */
        
        /*int count = [self.navigationController.viewControllers count];
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count-3] animated:YES];*/


    }
    
    // log error because unrecognized alert
    /*else
    {
        
    }*/
	
	return;
}

/* (void)
 * viewDidLoad
 *
 * Implement viewDidLoad to do additional setup after loading the view, 
 * typically from a nib.
 */

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// remember types of drinks, fruits, and snacks
	self.drinks = [[NSArray alloc] initWithObjects:@"select", @"Orange Juice", 
				   @"Skim Milk", @"Whole Milk", @"Chocolate Milk", @"Coke",
				   @"Diet Coke", @"Sprite", @"Diet Sprite", @"Water", nil];
	self.fruits = [[NSArray alloc] initWithObjects:@"select", @"Apple",
				   @"Banana", @"Orange", nil];
	self.snacks = [[NSArray alloc] initWithObjects:@"select",
				   @"Potato Chips", @"Cookie", @"Yogurt", 
				   @"Carrots", @"Pretzels", nil];
	
	// set the initial selections to select nothing
	self.selectedDrinkIndex = UNSELECTED;
	self.selectedFruitIndex = UNSELECTED;
	self.selectedSnack1Index = UNSELECTED;
	self.selectedSnack2Index = UNSELECTED;
	
	
	// display initial selections
	[self drinkWasSelected:[NSNumber numberWithInteger:self.selectedDrinkIndex] 
				   element:drinkText];
	
	[self fruitWasSelected: 
	 [NSNumber numberWithInteger:self.selectedFruitIndex]element:fruitText];
	
	[self snack1WasSelected: 
	 [NSNumber numberWithInteger:self.selectedSnack1Index] 
					element:snack1Text];
	
	[self snack2WasSelected: 
	 [NSNumber numberWithInteger:self.selectedSnack2Index] 
					element:snack2Text];
	
}

#pragma mark Select drinks

/* (IBAction)
 * selectADrink:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which drink, if any, to add to the order.
 */
- (IBAction)selectADrink:(UIControl *)sender 
{
	// Instantiate and display picker with different drink options
    [ActionSheetPicker showPickerWithTitle:@"Select a Drink" 
                                      rows:self.drinks 
                          initialSelection:self.selectedDrinkIndex 
                                    target:self
                                    action:@selector(drinkWasSelected:element:) 
                                    origin:sender];
	
}

/* (void)
 * drinkWasSelected:(NSNumber *)selectedDrinkIndex element:(id)element
 *
 * When a drink is selected from the picker, remember which drink
 * was selected and display that drink's name in the appropriate text field
 */

- (void)drinkWasSelected:(NSNumber *)selectedDrinkIndex element:(id)element
{
	// remember which drink was selected
    self.selectedDrinkIndex = [selectedDrinkIndex intValue];
	
	// display the drink's name in the appropriate element (i.e. drink text field)
    if ([element respondsToSelector:@selector(setText:)]) 
	{
        [element setText:[self.drinks objectAtIndex:self.selectedDrinkIndex]];
    }
}

#pragma mark Select fruits

/* (IBAction)
 * selectAFruit:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which fruit, if any, to add to the order.
 */

- (IBAction)selectAFruit:(UIControl *)sender 
{
	// Instantiate and display picker with different fruit options
    [ActionSheetPicker showPickerWithTitle:@"Select a Fruit" 
                                      rows:self.fruits 
                          initialSelection:self.selectedFruitIndex 
                                    target:self
                                    action:@selector(fruitWasSelected:element:) 
                                    origin:sender];
	
}

/* (void)
 * fruitWasSelected:(NSNumber *)selectedFruitIndex element:(id)element
 *
 * When a fruit is selected from the picker, remember which fruit
 * was selected and display that fruit's name in the appropriate text field
 */

- (void)fruitWasSelected:(NSNumber *)selectedFruitIndex element:(id)element 
{
	// remember which fruit was selected
    self.selectedFruitIndex = [selectedFruitIndex intValue];
	
	// display fruit's name in appropriate element (i.e. fruit text field)
    if ([element respondsToSelector:@selector(setText:)]) {
        [element setText:[self.fruits objectAtIndex:self.selectedFruitIndex]];
    }
}

#pragma mark Select Snack 1

/* (IBAction)
 * selectASnack1:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which snack (for snack 1 slot), if any, to add to the order.
 */
- (IBAction)selectASnack1:(UIControl *)sender 
{
	// Instantiate and display a picker with the different snack options
    [ActionSheetPicker showPickerWithTitle:@"Select a Snack" 
                                      rows:self.snacks 
                          initialSelection:self.selectedSnack1Index 
                                    target:self
                                    action:@selector(snack1WasSelected:element:) 
                                    origin:sender];
	
}

/* (void)
 * snack1WasSelected:(NSNumber *)selectedSnack1Index element:(id)element
 *
 * When a snack is selected from the picker for snack 1 slot, remember which snack
 * was selected and display that snack's name in the appropriate text field
 */

- (void)snack1WasSelected:(NSNumber *)selectedSnack1Index element:(id)element {
    // remember which snack was selected
	self.selectedSnack1Index = [selectedSnack1Index intValue];
	// display that snack's name in appropriate element (i.e. snack 1 text field)
    if ([element respondsToSelector:@selector(setText:)]) {
        [element setText:[self.snacks objectAtIndex:self.selectedSnack1Index]];
    }
}

#pragma mark Select Snack 2

/* (IBAction)
 * selectASnack2:(UIControl *)sender
 *
 * Show a picker (similar to a drop down menu) that allows the user to select 
 * which snack (for snack 2 slot), if any, to add to the order.
 */

- (IBAction)selectASnack2:(UIControl *)sender 
{
	// Instantiate and display a picker with the different snack options
    [ActionSheetPicker showPickerWithTitle:@"Select a Snack" 
                                      rows:self.snacks 
                          initialSelection:self.selectedSnack2Index 
                                    target:self
                                    action:@selector(snack2WasSelected:element:) 
                                    origin:sender];
	
}

/* (void)
 * snack2WasSelected:(NSNumber *)selectedSnack2Index element:(id)element
 *
 * When a snack is selected from the picker for snack 2 slot, remember which snack
 * was selected and display that snack's name in the appropriate text field
 */

- (void)snack2WasSelected:(NSNumber *)selectedSnack2Index element:(id)element 
{
    // remember which snack was selected
    self.selectedSnack2Index = [selectedSnack2Index intValue];
	
	// display snack's name in appropriate element (i.e. snack 2 text field)
    if ([element respondsToSelector:@selector(setText:)]) {
        [element setText:[self.snacks objectAtIndex:self.selectedSnack2Index]];
    }
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	// Release allocated memory
	self.drinks = nil;
	self.fruits = nil;
	self.snacks = nil;
    //self.user = nil;
}


- (void)dealloc 
{
	// Release allocated memory
	[self.drinks release];
	[self.fruits release];
	[self.snacks release];
	//[self.user release];
    [super dealloc];
}


@end
