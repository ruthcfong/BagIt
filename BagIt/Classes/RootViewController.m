//
//  RootViewController.m
//  BagIt
//
//  Created by Ruth Fong on 11/24/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import "PickupController.h"
#import "RootViewController.h"
#import "Constants.h"
#import "UserInformation.h"

#import "SelectionViewController.h"
@implementation RootViewController

@synthesize meals, pickupController, user;

#pragma mark -
#pragma mark View lifecycle

/* (void)
 * viewDidLoad
 *
 * Set the information to be loaded in the view.
 */

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// initialize and fill meal array with the different types of meals
	self.meals = [[NSArray alloc] initWithObjects:
				  @"Breakfast", @"Lunch", @"Dinner", nil];
	
	// set the title of the view
	self.title = @"Select a Meal";
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section 
{
	// let view know that the number of cells in the table equals
	// the number of different types of meals (i.e. 3)
    return [meals count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
	
	// set text of cell to the name of the meal (i.e. Breakfast)
	cell.textLabel.text = [self.meals objectAtIndex:[indexPath row]];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    // prepare to select a meal
    /*SelectionViewController* selectionController = [[SelectionViewController alloc] 
                                                    initWithNibName:@"SelectionViewController" 
                                                    bundle:nil];
    
    // go to the next view if correct HUID & PIN has been entered
    //if (isAuthenticated) 
    {
        selectionController.user = user;
        
        // display the next view
        [self.navigationController pushViewController:selectionController 
                                             animated:YES];
    }
    
    [selectionController release];*/
    
     // initialize the next view controller to accept pickup information
     pickupController = [[PickupController alloc] 
     initWithNibName:@"PickupController" bundle:nil];
     
     // set the title of next view to the type of meal that's being ordered
     switch (indexPath.row) 
     {
     case BREAKFAST:
     pickupController.title = @"Breakfast";
     break;
     case LUNCH:
     pickupController.title = @"Lunch";
     break;
     case DINNER:
     pickupController.title = @"Dinner";
     break;
     default:
     pickupController.title = @"Error";
     break;
     }
     
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:pickupController animated:YES];
     
     // Release controller
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.meals = nil;
	self.pickupController = nil;
}




@end

