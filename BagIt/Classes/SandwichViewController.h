//
//  SandwichViewController.h
//  BagIt
//
//  Created by Ruth Fong on 12/3/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "UserInformation.h"

@interface SandwichViewController : UIViewController 
{
	IBOutlet UILabel *itemLabel;
    IBOutlet UILabel *optionalLabel;
    IBOutlet UILabel *chefsNoteLabel;
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
    UserInformation* user;
    NSMutableString* entreeOrdered;

}

@property (nonatomic, strong) IBOutlet UILabel *itemLabel;
@property (nonatomic, strong) IBOutlet UILabel *optionalLabel;
@property (nonatomic, strong) IBOutlet UILabel *chefsNoteLabel;
@property (nonatomic, strong) IBOutlet UITextField *itemText;
@property (nonatomic, strong) IBOutlet UITextField *breadText;
@property (nonatomic, strong) IBOutlet UITextField *cheeseText;
@property (nonatomic, strong) IBOutlet UITextField *dressingText;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;
@property (nonatomic, assign) BOOL isFirstSandwich;
@property (nonatomic, assign) BOOL selectedChefs;
@property (nonatomic, strong) NSString *previousConcat;
@property (nonatomic, strong) NSString *prevOrderInfo;
@property (nonatomic, strong) NSMutableString *orderInfo;
@property (nonatomic, strong) NSMutableString *entreeOrdered;
@property (nonatomic, strong) UserInformation* user;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *itemNames;
@property (nonatomic, strong) NSArray *breads;
@property (nonatomic, assign) NSInteger	selectedBreadIndex;
@property (nonatomic, strong) NSArray *cheeses;
@property (nonatomic, assign) NSInteger selectedCheeseIndex;
@property (nonatomic, strong) NSArray *dressings;
@property (nonatomic, assign) NSInteger selectedDressingIndex;

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
