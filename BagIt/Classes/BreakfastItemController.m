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


@implementation BreakfastItemController

@synthesize dataArray, selected, pickupConcat, prevOrderInfo, orderInfo, thisConcat;

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
		// if so, display concatenated string
        NSLog(@"Copy & Paste this string:%@%@", pickupConcat, thisConcat);
    }
	
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
	// Debugging
	// NSLog(@"Number of checked items: %i", selected);
	
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
}


- (void)dealloc
{	
    [dataArray release];
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




