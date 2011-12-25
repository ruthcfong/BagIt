//
//  PickupInformation.m
//  BagIt
//
//  Created by Ruth Fong on 12/2/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import "PickupInformation.h"
#import "NSDate.h"
#import "Constants.h"

@implementation PickupInformation

// instance variables
@synthesize locationNames, possibleTimes, location, time, date, concat, 
	orderInfo, meal;

/* (id)
 *
 * initIsBreakfast: (BOOL) isBfast
 *
 * Initialize instance of PickupInformation by initializing instance variables,
 * partially based on what type of meal's being bagged.
 */
- (id) initMeal: (int) typeOfMeal
{
    if (self = [super init])
    {
		// initialize an array of location names, including an empty
		// "select" location
        locationNames = [NSArray arrayWithObjects: @"select", @"Annenberg", @"Adams", 
						 @"Cabot", @"Currier", @"Dunster", @"Eliot", 
						 @"Kirkland", @"Leverett", @"Lowell", @"Mather", 
						 @"Pforzheimer", @"Quincy" ,@"Winthrop" , nil];
		
		// initialize array of possible times
		possibleTimes = [[NSMutableArray alloc] init];
		
		// remember what type of meal is being ordered
		meal = typeOfMeal;
		
		// initialize variables for first pick-up time, 
		// the number of seconds in 30 minutes, and the 
		// number of pickup times pending which meal's being bagged
		int halfAnHour = SECONDS * 30;
		int initTime = SECONDS * MINUTES * (7 + TIMEZONE_CORRECTION);
		
		// set the pick-up time for lunch and dinner to 7:30
		if (meal != BREAKFAST) 
		{
			initTime += halfAnHour;
		}
		
		// depending on whether breakfast is being ordered, determine number of
		// different possible pickup times
		int numOfIntervals = (meal == BREAKFAST) ? NUM_OF_BREAKFAST_INTERVALS : 
		NUM_OF_NORMAL_INTERVALS;
		
		// add all the possible pick-up times to array
		for (int i = 0; i < numOfIntervals; i++) 
		{
			[possibleTimes addObject: 
			 [NSDate dateWithTimeIntervalSinceReferenceDate:
			  (NSTimeInterval)(halfAnHour*i + initTime)]];
		}
		
		
    }
    return self;
}

/* (NSString *)
 * buildConcat
 *
 * Return a concatenated string that represents the pickup information and
 * can be appened to the HUDS URL. Also saves a readable version of the 
 * pickup information in another string.
 */

- (NSString*) buildConcat
{
	// define an array to store prefixes of HTTP GET posts to HUDS
	NSArray *prefixes;
	
	// initialize array of prefixes according to whether breakfast is 
	// being ordered
	if (meal == BREAKFAST) 
	{
		prefixes = [[NSArray alloc] initWithObjects:
					@"?action=submit", @"&pickup=",
					@"&order%5Blocation_id%5D=",
					@"&order%5Bdelivery_time%5D=", 
					@"&pickup_list=", 
					nil];
	}
	else 
	{
		prefixes = [[NSArray alloc] initWithObjects:
					@"?action=submit", @"&pickup=",
					@"&order[location_id]=",
					@"&order[delivery_time]=",
					nil];
	}
	
	// remember HTTP GET post abbreviations for locations
	NSArray	*locationCodes = [NSArray arrayWithObjects: @"0", @"FD", @"AD", 
							  @"CB", @"CU",@"DN", @"EL", @"KI", @"LE", @"LO", 
							  @"MA", @"PF", @"QU", @"WI", nil];
	
	// initialize associative array to store location names and abbreviations
	NSDictionary *locationDict = [NSDictionary 
								  dictionaryWithObjects: locationCodes
								  forKeys: locationNames];
	
	// initialize and allocate memory to save the concatenated string
	// and the more readable, order information string
	concat = [[NSMutableString alloc] init];
	orderInfo = [[NSMutableString alloc] init];
	
	// prepare to remember which meal is being ordered/skipped
	[orderInfo appendString:@"Skipped meal: "];
	
	// remember which meal is being ordered/skipped in both concatenated, 
	// HTTP GET post string as well as the human-readable string about the order
	switch (meal) 
	{
		case BREAKFAST:
			[concat	appendString:@"breakfast/"];
			[orderInfo appendString:@"Breakfast\n"];
			break;
		case LUNCH:
			[concat	appendString:@"lunch/"];
			[orderInfo appendString:@"Lunch\n"];
			break;
		case DINNER:
			[concat	appendString:@"dinner/"];
			[orderInfo appendString:@"Dinner\n"];
			break;
		default:
			break;
	}
	
	// initialize a nil error message
	NSMutableString* errorMsg = nil;
	
	// go through the different pickup information fields (i.e. date, location, time, etc.)
	// that are needed for the HTTP GET post
	for (int i = 0, len = [prefixes count]; i < len; i++) 
	{
		// add prefix to the running HTTP GET post string
		[concat appendString: [prefixes objectAtIndex:i]];
		
		// go through each of the different names and values necessary for the
		// HTTP GET post
		switch (i) 
		{
			// add date to the GET string and order information string
			case IS_DATE:
				[concat appendString: [date toHUDSDate]];
				[orderInfo appendFormat:@"Pickup Date: %@\n", [date toDate]];
				break;
				
			// add location to the GET string and order information string
			case IS_LOCATION:
				[concat appendString: [locationDict objectForKey:location]];
				
				// if no location is selected, remember to display an error message
				if ([[locationDict objectForKey:location] isEqualToString:@"0"]) 
				{
					errorMsg = [[NSMutableString alloc] init];
					[errorMsg appendString:@"You didn't select a location"];
					break;
				}
				
				[orderInfo appendFormat:@"Pickup Location: %@\n", location];
				break;
			
			// add time to GET string and order information string
			case IS_TIME:
				
				// if no time is selected, remember to display an error message
				if (time == nil) 
				{
					// if no previous errors, initialize and set error message
					if (errorMsg == nil) 
					{
						errorMsg = [[NSMutableString alloc] init];
						[errorMsg appendString:@"You didn't select a time"];
					}
					// otherwise, just add to the error message
					else 
					{
						[errorMsg appendString:@" and a time"];
					}
					
					// add "0" to the GET string to signify no time was selected
					[concat appendString: @"0"];
					break;
				}
				
				// add formatted time to GET string and readable time to
				// order information string
				[concat appendString:[time toHUDSTime]];
				[orderInfo appendFormat:@"Pickup Time: %@\n", [time toTime]];
				break;
			
			// add the necessary pickup list value (=0)
			case IS_PICKUP_LIST:
				[concat appendString:@"0"];
				break;
			
			default:
				break;
		}
		
	}
	
	// if there is an error message, display it
	if (errorMsg != nil)
	{
		// end error message with a period
		[errorMsg appendString:@"."];
		
		// initialize and set error message
		UIAlertView *message = [[UIAlertView alloc] 
								initWithTitle:@"Error"
								message:errorMsg
								delegate:nil 
								cancelButtonTitle:@"OK" 
								otherButtonTitles:nil];
		
		// show error message
		[message show];
		
		// release memory used for the alert & method
		[message release];
		[errorMsg release];
		[prefixes release];
		
		return nil;
		
	}
	
	// release memory
	[prefixes release];	
	
	return concat;
}

@end
