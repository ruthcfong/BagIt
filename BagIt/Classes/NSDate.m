//
//  NSDate.m
//  BreakfastPrototype1
//
//  Created by Ruth Fong on 11/24/11.
//  Copyright 2011 Harvard College. All rights reserved.
//
// Code based off of: http://www.roseindia.net/tutorial/iphone/examples/iphone-Objective-c-date.html
//

#import "NSDate.h"


@implementation NSDate (formatted)


/* (NSString*)
 * toHUDSDate
 *
 * Convert date into a suitable string format, i.e. YYYY-MM-DD. Code derived from:
 * http://www.roseindia.net/tutorial/iphone/examples/iphone-Objective-c-date.html
 */
- (NSString*) toHUDSDate
{	
	// create NSDateFormatter object
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	// set date format
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	// get the string date
	NSString* strDate = [formatter stringFromDate: self];
	
	return strDate;
}

/* (NSString*)
 * toTime
 *
 * Convert time into a suitable string format, i.e. HH%3Amm, to be 
 * appended to the HUDS dining hall URL. Code derived from:
 * http://www.roseindia.net/tutorial/iphone/examples/iphone-Objective-c-date.html
 */
- (NSString*) toHUDSTime
{	
	// create NSDateFormatter object
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	// set date format
	[formatter setDateFormat:@"HHmm"];
	
	// get the string date
	NSMutableString* strDate = [[NSMutableString alloc] init];
	[strDate appendString:[formatter stringFromDate: self]];
	[strDate insertString:@"%3A" atIndex:2];
	return strDate;
}

/* (NSString*)
 * toTime
 *
 * Convert time into a suitable string format, i.e. HH:mma. Code derived from:
 * http://www.roseindia.net/tutorial/iphone/examples/iphone-Objective-c-date.html
 */
- (NSString*) toTime
{	
	// create NSDateFormatter object
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	// set date format
	[formatter setDateFormat:@"h:mm a"];
	
	// get the string date
	NSString* strDate = [formatter stringFromDate: self];
	
	return strDate;
}

/* (NSString*)
 * toDate
 *
 * Convert date into a suitable string format for the user to select in a 
 * picker, i.e. Saturday, December 3.
 */
- (NSString*) toDate
{
	// create NSDateFormatter object
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	// set date format
	[formatter setDateFormat:@"EEEE, MMMM d"];
	
	// get the string date
	NSString* strDate = [formatter stringFromDate: self];
	
	return strDate;
}


@end
