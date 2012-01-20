//
//  BreakfastItemController.m
//  BagIt
//
//  Created by Ruth Fong on 12/3/11.
//  Copyright 2011 Harvard College. All rights reserved.
//	

#import "BreakfastItemController.h"
#import "NSString+URLEncoding.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "CJSONDeserializer.h"
#import "ConnectionDelegate.h"
#import "NSObject+Addons.h"
#import "Order.h"

@implementation BreakfastItemController

@synthesize dataArray, selected, pickupConcat, prevOrderInfo, orderInfo, thisConcat, user, dWork, order, foodsOrdered, loadingModal;

@synthesize data = _data;


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
        dWork = [responseData valueForKey:@"didWork"];
        
        if ([dWork isEqualToString:@"yes"]) 
        {			            
            // create popup alert
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Order Submitted."
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

/* (void)
 * showSubmitAlert
 *
 * Display an UIAlertView showing the user his/her order and prompting
 * him/her to click "Submit" to submit the order or "Cancel" to go back
 * and modify his/her order.
 */
- (void) showSubmitAlert
{
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
        NSString* getURL = [NSString stringWithFormat:@"http://www.dining.harvard.edu/myhuds/students/%@%@",  pickupConcat, thisConcat];
        
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
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }
    
    // check if the user wants to place another order
    else if([title isEqualToString:@"Order"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
    }
    
    // log error because unrecognized alert
    /*else
     {
     
     }*/
	
	return;
}

/* (void)
 * done
 *
 * Display error message if either no items or more than 5 items are selected; 
 * otherwise, shows next view.
 */
- (void) done
{	
	NSString *errorMsg = nil;
	if (selected == MIN_BREAKFAST_LIMIT) {
		errorMsg = @"You have not selected any items.";
	}
	// display alert message if more than 5 items are selected; otherwise, show next view
	else if (selected > MAX_BREAKFAST_LIMIT) 
	{
		errorMsg = @"You can not select more than 5 items.";
	}
	
	// display error message if there's an error
	if (errorMsg != nil) 
	{
		// initialize error message alert
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
														  message:errorMsg
														 delegate:nil 
												cancelButtonTitle:@"OK" 
												otherButtonTitles:nil];
		
		// show error alert
		[message show];
		// Release memory
		[message release];
	}
	else 
	{
		// create valid string to append to HUDS URL
		thisConcat = [self concatItems];
		
		// show user the order and confirm the order
		[self showSubmitAlert];
		
	}
}

/* (NSString *)
 * 
 * concatItems
 *
 * Concatenates the selected items in a format that can be appended to 
 * the HUDS URL via GET method.
 */
- (NSString *) concatItems
{
	// initialize strings to save order information
	NSMutableString *concat = [[NSMutableString alloc] init];
	orderInfo = [[NSMutableString alloc] initWithString: @""];
	
	// iterate through items checking which ones are selected
	for (int i = 0, len = [dataArray count]; i < len; i++) 
	{
		// get item to examine
		NSMutableDictionary *item = [dataArray objectAtIndex:i];
		
		// concatenate item value if the item is selected
		if ([[item objectForKey:@"checked"] boolValue]) 
		{
			// concatenate prefix for item
			[concat appendString:@"&items%5B"];
			
			// get name of item
			NSString* itemName = [item objectForKey:@"text"];
			
			// add item name to order information string
			[orderInfo appendFormat:@"%@\n", itemName];
			
			// escape and concatenate item's name to string for HTTP GET post
			[concat appendString:[NSString urlEncodeValue: itemName]];
			
			// concatenate suffix for item
			[concat appendString:@"%5D=on"];
		}
		
	}
	
	return concat;
}

- (void)viewDidLoad
{
	// load our data from a plist file inside our app bundle
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Breakfast" ofType:@"plist"];
	self.dataArray = [NSMutableArray arrayWithContentsOfFile:path];
	
	// initialize a "Submit" button
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
																	  style:UIBarButtonItemStylePlain target:self action:@selector(done)];          
	// display "Submit" button at top-right
	self.navigationItem.rightBarButtonItem = anotherButton;
	
	// Release allocated memory
	[anotherButton release];
}

- (void)viewWillAppear:(BOOL)animated 
{
	// set count of selected items to 0
	selected = 0;
	
	// count how many selected items there are when screen is displayed
	for (int i = 0, len = [dataArray count]; i < len; i++) 
	{
		// get item to examine
		NSMutableDictionary *item = [dataArray objectAtIndex:i];
		
		// increment count if the item is selected
		if ([[item objectForKey:@"checked"] boolValue]) 
		{
			selected++;
		}
	}
}

// called after the view controller's view is released and set to nil.
// For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
// So release any properties that are loaded in viewDidLoad or can be recreated lazily.
//
- (void)viewDidUnload
{
	self.dataArray = nil;
    self.data = nil;
    self.thisConcat = nil;
}


- (void)dealloc
{	
    [dataArray release];
    [thisConcat release];
    //[self.data release];
    
	[super dealloc];
}


#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [dataArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCustomCellID = @"MyCellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	// grab information about the selected item
	NSMutableDictionary *item = [dataArray objectAtIndex:indexPath.row];
	
	// set the text of current cell to the name of the item
	cell.textLabel.text = [item objectForKey:@"text"];
	
	[item setObject:cell forKey:@"cell"];
	
	// remember if the item is initially selected
	BOOL checked = [[item objectForKey:@"checked"] boolValue];
	
	// display green checkmark next to item's name if it's selected;
	// otherwise, display a faded checkmark
	UIImage *image = (checked) ? [UIImage imageNamed:@"checked.png"] : 
		[UIImage imageNamed:@"unchecked.png"];
	
	// make the cell clickable so items can be selected and deselected
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	button.frame = frame;	// match the button's size with the image size
	
	[button setBackgroundImage:image forState:UIControlStateNormal];
	
	// set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];
	cell.accessoryView = button;
	
	return cell;
}


- (void)checkButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
		[self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{	
	// grab information about item (i.e. name, whether it's checked)
	NSMutableDictionary *item = [dataArray objectAtIndex:indexPath.row];
	
	// remember if item is checked
	BOOL checked = [[item objectForKey:@"checked"] boolValue];
	
	// if item is already selected (i.e. is being deselected), decrement count 
	// of selected items; otherwise, increment count
	selected = (checked) ? selected - 1 : selected + 1;
	
	// flip the item's checked state (i.e. if was selected, deselect and vice versa)
	[item setObject:[NSNumber numberWithBool:!checked] forKey:@"checked"];
	
	UITableViewCell *cell = [item objectForKey:@"cell"];
	UIButton *button = (UIButton *)cell.accessoryView;
	
	// reflect item's new checked state with either a green or faded checkmark
	UIImage *newImage = (checked) ? [UIImage imageNamed:@"unchecked.png"] : [UIImage imageNamed:@"checked.png"];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
}

@end




