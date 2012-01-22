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
@property (strong, nonatomic) MBProgressHUD* loadingModal;
@property (strong, nonatomic) IBOutlet     UITextField* username;
@property (strong, nonatomic) IBOutlet     UITextField* password;
@property (strong, nonatomic) NSString* orderInfo;
@property (strong, nonatomic) UserInformation* user;
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) NSString* didWork;
@property (nonatomic, strong) UIActivityIndicatorView *cLoadingView;

//- (void) keyboardWillShow:(NSNotification *)note;
- (IBAction) submit:(id)sender;
- (IBAction) textFieldReturn: (id) sender;
- (IBAction) backgroundTouched: (id) sender;

@end
