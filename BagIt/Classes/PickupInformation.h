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
@property (nonatomic, strong) NSArray *locationNames;
@property (nonatomic, strong) NSMutableArray *possibleTimes;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableString *concat;
@property (nonatomic, strong) NSMutableString *orderInfo;
@property (nonatomic, assign) int meal;

// method prototypes
- (NSString*) buildConcat;
- (id) initMeal: (int) typeOfMeal;

@end
