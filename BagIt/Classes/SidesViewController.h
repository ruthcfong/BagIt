//
//  SidesViewController.h
//  BagIt
//
//  Created by Ruth Fong on 12/5/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformation.h"
#import "Order.h"
#import "MBProgressHUD.h"

@interface SidesViewController : UIViewController <UIAlertViewDelegate> 
{
	// IBOutlets
	IBOutlet UITextField *drinkText;
	IBOutlet UITextField *fruitText;
	IBOutlet UITextField *snack1Text;
	IBOutlet UITextField *snack2Text;
	
	// instance variables
	NSString *previousConcat;	
	NSString *thisConcat;
	NSMutableString *prevOrderInfo;
	NSMutableString *orderInfo;
    
    //UserInformation *user;
    NSString* didWork;
    UserInformation* user;
    Order* order;
    NSMutableString* foodsOrdered;
    MBProgressHUD* loadingModal;

}

// getter/setter prototypes
@property (nonatomic, strong) IBOutlet UITextField *drinkText;
@property (nonatomic, strong) IBOutlet UITextField *fruitText;
@property (nonatomic, strong) IBOutlet UITextField *snack1Text;
@property (nonatomic, strong) IBOutlet UITextField *snack2Text;
@property (nonatomic, strong) NSString *previousConcat;
@property (nonatomic, strong) NSString *thisConcat;
@property (nonatomic, strong) NSMutableString *prevOrderInfo;
@property (nonatomic, strong) NSMutableString *orderInfo;
@property (strong, nonatomic) NSMutableData* data;
@property (strong, nonatomic) NSString* didWork;
@property (strong, readwrite, nonatomic) UserInformation* user;
@property (strong, nonatomic) Order* order;
@property (strong, nonatomic) NSMutableString* foodsOrdered;
@property (strong, nonatomic) MBProgressHUD* loadingModal;

@property (nonatomic, strong) NSArray *drinks;
@property (nonatomic, assign) NSInteger	selectedDrinkIndex;
@property (nonatomic, strong) NSArray *fruits;
@property (nonatomic, assign) NSInteger selectedFruitIndex;
@property (nonatomic, strong) NSArray *snacks;
@property (nonatomic, assign) NSInteger selectedSnack1Index;
@property (nonatomic, assign) NSInteger selectedSnack2Index;

- (IBAction) submit;
- (void) showSubmitAlert;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (NSString *) concatSideOrder;
- (IBAction)selectADrink:(UIControl *)sender;
- (void)drinkWasSelected:(NSNumber *)selectedDrinkIndex element:(id)element;
- (IBAction)selectAFruit:(UIControl *)sender;
- (void)fruitWasSelected:(NSNumber *)selectedFruitIndex element:(id)element;
- (IBAction)selectASnack1:(UIControl *)sender;
- (void)snack1WasSelected:(NSNumber *)selectedSnack1Index element:(id)element;
- (IBAction)selectASnack2:(UIControl *)sender;
- (void)snack2WasSelected:(NSNumber *)selectedSnack2Index element:(id)element;
- (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex;


@end
