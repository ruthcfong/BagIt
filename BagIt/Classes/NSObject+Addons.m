//
//  NSObject+Addons.m
//  BagIt
//
//  Created by Ruth Fong on 1/16/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import "NSObject+Addons.h"

@implementation NSObject (NSObject_Addons)

/* (void)
 * showAlertWithString: (NSString*) errorMsg
 *
 * Displays an error message detailing what the user did wrong.
 */
- (void) showAlertWithString: (NSString*) errorMsg
{
	// create error alert
	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
													  message:errorMsg
													 delegate:nil 
											cancelButtonTitle:@"OK" 
											otherButtonTitles:nil];
	
	// display alert
	[message show];
	
	// release memory
}

@end
