//
//  LoginViewController.h
//  BagIt
//
//  Created by Ruth Fong on 1/15/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformation.h"
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate>
{
    UITextField* username;
    UITextField* password;
    NSString* orderInfo;
    UserInformation* user;
    NSMutableData *responseData;
    NSString* didWork;
    UIActivityIndicatorView *cLoadingView;
    MBProgressHUD *loadingModal;
}
@property (retain, nonatomic) MBProgressHUD* loadingModal;
@property (retain, nonatomic) IBOutlet     UITextField* username;
@property (retain, nonatomic) IBOutlet     UITextField* password;
@property (retain, nonatomic) NSString* orderInfo;
@property (retain, nonatomic) UserInformation* user;
@property (retain, nonatomic) NSMutableData* responseData;
@property (retain, nonatomic) NSString* didWork;
@property (nonatomic, retain) UIActivityIndicatorView *cLoadingView;

//- (void) keyboardWillShow:(NSNotification *)note;
- (IBAction) submit:(id)sender;
- (IBAction) textFieldReturn: (id) sender;
- (IBAction) backgroundTouched: (id) sender;

@end
