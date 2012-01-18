//
//  SidesViewController.h
//  BagIt
//
//  Created by Ruth Fong on 12/5/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformation.h"
#import "SubmissionSuperViewController.h"
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
    UIActivityIndicatorView *cLoadingView;    
    
    NSString* dWork;
    UserInformation* user;

}

// getter/setter prototypes
@property (nonatomic, retain) IBOutlet UITextField *drinkText;
@property (nonatomic, retain) IBOutlet UITextField *fruitText;
@property (nonatomic, retain) IBOutlet UITextField *snack1Text;
@property (nonatomic, retain) IBOutlet UITextField *snack2Text;
@property (nonatomic, retain) NSString *previousConcat;
@property (nonatomic, retain) NSString *thisConcat;
@property (nonatomic, retain) NSMutableString *prevOrderInfo;
@property (nonatomic, retain) NSMutableString *orderInfo;
@property (retain, nonatomic) NSMutableData* data;
@property (retain, nonatomic) NSString* dWork;
@property (retain, readwrite, nonatomic) UserInformation* user;

@property (nonatomic, retain) NSArray *drinks;
@property (nonatomic, assign) NSInteger	selectedDrinkIndex;
@property (nonatomic, retain) NSArray *fruits;
@property (nonatomic, assign) NSInteger selectedFruitIndex;
@property (nonatomic, retain) NSArray *snacks;
@property (nonatomic, assign) NSInteger selectedSnack1Index;
@property (nonatomic, assign) NSInteger selectedSnack2Index;

@property (nonatomic, retain) UIActivityIndicatorView *cLoadingView;

- (void)initSpinner;
- (void)spinBegin;
- (void)spinEnd;

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
