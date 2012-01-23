//
//  BreakfastItemController.h
//  BagIt
//
//  Created by Ruth Fong on 12/3/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformation.h"
#import "MBProgressHUD.h"

@interface BreakfastItemController : UITableViewController <UITableViewDelegate>
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
    MBProgressHUD* loadingModal;
}

// declare setters/getters methods
@property (nonatomic, strong) NSMutableArray *dataArray;
@property NSInteger selected;
@property (nonatomic, strong) NSString *pickupConcat;
@property (nonatomic, strong) NSString *prevOrderInfo;
@property (nonatomic, strong) NSMutableString *orderInfo;
@property (nonatomic, strong) NSMutableString *foodsOrdered;
@property (nonatomic, strong) NSString *thisConcat;
@property (nonatomic, strong) UserInformation* user;
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) NSString* dWork;
@property (nonatomic, strong) MBProgressHUD* loadingModal;

// method prototypes
- (void) done;
- (NSString *) concatItems;

@end
