//
//  SubmissionSuperViewController.m
//  BagIt
//
//  Created by Ruth Fong on 1/17/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import "SubmissionSuperViewController.h"
#import "CJSONDeserializer.h"
#import "NSObject+Addons.h"
#import "UserInformation.h"
@implementation SubmissionSuperViewController

@synthesize data=_data;
@synthesize didWork, dWork;
@synthesize user;

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
    NSLog(@"%@", str);
    
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
			
            // delete user information
            [self.user release];
            [self.user initWithHUID:@"" andPIN:@""];
            
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
        [self.navigationController popToRootViewControllerAnimated:NO];
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
