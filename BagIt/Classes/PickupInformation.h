//
//  PickupInformation.h
//  BagIt
//
//  Created by Ruth Fong on 12/2/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PickupInformation : NSObject 
{
	// instance variables
	NSArray *locationNames;
	NSMutableArray *possibleTimes;
	NSString *location;
	NSDate *time;
	NSDate *date;
	NSMutableString *concat;
	NSMutableString *orderInfo;
	int meal;
}

// getter/setter prototypes
@property (nonatomic, retain) NSArray *locationNames;
@property (nonatomic, retain) NSMutableArray *possibleTimes;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSMutableString *concat;
@property (nonatomic, retain) NSMutableString *orderInfo;
@property (nonatomic, assign) int meal;

// method prototypes
- (NSString*) buildConcat;
- (id) initMeal: (int) typeOfMeal;

@end
