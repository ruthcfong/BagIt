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
@synthesize viewController=_viewController;
@synthesize nextViewController = _nextViewController;
@synthesize  message, didWork, loadingModal;

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
    NSError* error = nil;
    NSDictionary* responseData = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data 
                                                                                   error:&error];
    if (!error) 
    {
        didWork = [responseData valueForKey:@"didWork"];
        
        //if ([didWork isEqualToString:@"yes"]) 
        {
            NSLog(@"Yay!");
            
            // show alert
            [message show];
            
            // release memory

			// display the view
			[_viewController.navigationController pushViewController:_nextViewController 
												animated:YES];

        }
        /*else
        {
            // display error message
            [self showAlertWithString: @"Order couldn't be submitted. Please try again."];
        }*/
        
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
