//
//  ConnectionDelegate.m
//  BagIt
//
//  Created by Ruth Fong on 1/15/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import "ConnectionDelegate.h"
#import "CJSONDeserializer.h"
#import "NSObject+Addons.h"
#import "SelectionViewController.h"

@implementation ConnectionDelegate

@synthesize data=_data;
@synthesize loginViewController=_loginViewController;

@synthesize didWork, dWork;

- (id)init
{
    self = [super init];
    
    if (self) {
        self.data = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSString* str = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    NSDictionary* responseData = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data 
                                                                                   error:&error];
    if (!error) 
    {
        NSLog(@"%@", [responseData valueForKey:@"didWork"]);
        // iterate over all returned data
        //NSMutableArray* courses = [[NSMutableArray alloc] init];
        //didWork = 
        dWork = [responseData valueForKey:@"didWork"];
        
        if ([dWork isEqualToString:@"yes"]) 
        {
            NSLog(@"Yay!");
            
            // initialize the next view to select a meal
			SelectionViewController *selectionViewController = 
			[[SelectionViewController alloc] 
			 initWithNibName:@"SelectionViewController" bundle:nil];
			
			// set the view controller's title
			selectionViewController.title = @"Select a meal";
			
            // create popup alert
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"What Now?"
                                                              message:@"Do you want to logout or place another order?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Order"
                                                    otherButtonTitles:@"Logout", nil];
            
            // show alert
            [message show];
            
            // release memory
            [message release];

			// display the view
			//[loginViewController.navigationController pushViewController:selectionViewController 
												// animated:YES];

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

}

/*
* If the "Submit" button is pressed on the popup alert, "submit" the order by
* displaying the concatenated string representing the order in the Console.
*/
- (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// remember button's name
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	
	// if "Logout" was clicked, delete user info and return to the login page
    if([title isEqualToString:@"Logout"])
    {
        
        // Go back to the root controller
        //[self.navigationController popToRootViewControllerAnimated:NO];
        
        // Release controller
        //[loginController release];
    }
    // otherwise, return to the meal selection view
    else
    {
        
    }
	
	return;
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.data setLength:0];
    NSLog(@"Yay! Connection was made.");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Boo hoo. Something went terribly wrong.");
    NSLog(@"The error is as follows:%@", error);
}

@end
