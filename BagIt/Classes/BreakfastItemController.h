//
//  BreakfastItemController.h
//  BagIt
//
//  Created by Ruth Fong on 12/3/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreakfastItemController : UITableViewController 
{
	
	// declare instance variables
	@private NSMutableArray *dataArray;
	NSInteger selected;
	NSString *pickupConcat;
	NSString *prevOrderInfo;
	NSMutableString *orderInfo;
	NSString *thisConcat;
	
}

// declare setters/getters methods
@property (nonatomic, retain) NSMutableArray *dataArray;
@property NSInteger selected;
@property (nonatomic, retain) NSString *pickupConcat;
@property (nonatomic, retain) NSString *prevOrderInfo;
@property (nonatomic, retain) NSMutableString *orderInfo;
@property (nonatomic, retain) NSString *thisConcat;

// method prototypes
- (void) done;
- (NSString *) concatItems;

@end