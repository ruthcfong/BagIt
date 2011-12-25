//
//  SandwichViewController.h
//  BagIt
//
//  Created by Ruth Fong on 12/3/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SandwichViewController : UIViewController 
{
	IBOutlet UILabel *itemLabel;
	IBOutlet UITextField *itemText;
	IBOutlet UITextField *breadText;
	IBOutlet UITextField *cheeseText;
	IBOutlet UITextField *dressingText;
	IBOutlet UIButton *nextButton;
	BOOL isFirstSandwich;
	BOOL selectedChefs;
	NSString *previousConcat;
	NSString *prevOrderInfo;
	NSMutableString *orderInfo;
}

@property (nonatomic, retain) IBOutlet UILabel *itemLabel;
@property (nonatomic, retain) IBOutlet UITextField *itemText;
@property (nonatomic, retain) IBOutlet UITextField *breadText;
@property (nonatomic, retain) IBOutlet UITextField *cheeseText;
@property (nonatomic, retain) IBOutlet UITextField *dressingText;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, assign) BOOL isFirstSandwich;
@property (nonatomic, assign) BOOL selectedChefs;
@property (nonatomic, retain) NSString *previousConcat;
@property (nonatomic, retain) NSString *prevOrderInfo;
@property (nonatomic, retain) NSMutableString *orderInfo;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSMutableArray *itemNames;
@property (nonatomic, retain) NSArray *breads;
@property (nonatomic, assign) NSInteger	selectedBreadIndex;
@property (nonatomic, retain) NSArray *cheeses;
@property (nonatomic, assign) NSInteger selectedCheeseIndex;
@property (nonatomic, retain) NSArray *dressings;
@property (nonatomic, assign) NSInteger selectedDressingIndex;

- (void) showAlertWithString: (NSString*) errorMsg;
- (IBAction) next;
- (IBAction)selectAnItem:(UIControl *)sender;
- (void)itemWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (IBAction)selectABread:(UIControl *)sender;
- (void)breadWasSelected:(NSNumber *)selectedBreadIndex element:(id)element;
- (IBAction)selectACheese:(UIControl *)sender;
- (void)cheeseWasSelected:(NSNumber *)selectedCheeseIndex element:(id)element;
- (IBAction)selectADressing:(UIControl *)sender;
- (void)dressingWasSelected:(NSNumber *)selectedDressingIndex element:(id)element;
- (NSString *) concatSandwichOrder;


@end