//
//  BreakfastItemController.h
//  BagIt
//
//  Created by Ruth Fong on 12/3/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformation.h"
#import "Order.h"
#import "MBProgressHUD.h"

@interface BreakfastItemController : UITableViewController 
{
	
	// declare instance variables
	@private NSMutableArray *dataArray;
	NSInteger selected;
	NSString *pickupConcat;
	NSString *prevOrderInfo;
	NSMutableString *orderInfo;
    NSMutableString *foodsOrdered;
	NSString *thisConcat;
    UserInformation* user;
    NSMutableData* responseData;
    NSString* dWork;
    Order* order;
    MBProgressHUD* loadingModal;
}

// declare setters/getters methods
@property (nonatomic, retain) NSMutableArray *dataArray;
@property NSInteger selected;
@property (nonatomic, retain) NSString *pickupConcat;
@property (nonatomic, retain) NSString *prevOrderInfo;
@property (nonatomic, retain) NSMutableString *orderInfo;
@property (nonatomic, retain) NSMutableString *foodsOrdered;
@property (nonatomic, retain) NSString *thisConcat;
@property (nonatomic, retain) UserInformation* user;
@property (retain, nonatomic) NSMutableData* responseData;
@property (retain, nonatomic) NSString* dWork;
@property (nonatomic, retain) Order* order;
@property (nonatomic, retain) MBProgressHUD* loadingModal;

// method prototypes
- (void) done;
- (NSString *) concatItems;

@end
