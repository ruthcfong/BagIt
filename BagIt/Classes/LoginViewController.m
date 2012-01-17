//
//  LoginViewController.m
//  BagIt
//
//  Created by Ruth Fong on 1/15/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInformation.h"
#import "ConnectionDelegate.h"
#import "NSString+URLEncoding.h"
//#import "UIViewController+Addons.h"
#import "SelectionViewController.h"
#import "NSObject+Addons.h"
@implementation LoginViewController

@synthesize username, password, orderInfo;

- (IBAction) textFieldReturn: (id) sender
{
	// quit keyboard (i.e. first responder)
	[sender resignFirstResponder];
}

- (IBAction) backgroundTouched: (id) sender
{
	[sender resignFirstResponder];
}

-(IBAction)submit:(id)sender
{
    // TODO - check whether or not the login worked (create a second php script that doesn't submit an order)
    ConnectionDelegate* d = [[ConnectionDelegate alloc] init];
    
    NSURL *url = [NSURL URLWithString: @"https://cloud.cs50.net/~ruthfong/pin.php"]; 
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	
    NSURLResponse *response = nil;
    
    // create a UserInformation object with the entered username and password
    UserInformation* user = [[UserInformation alloc] initWithHUID:username.text andPIN:password.text];
    
	/*NSData *requestData = [[NSString stringWithFormat:@"huid=%@&password=%@", user.huid, user.pin]dataUsingEncoding:NSUTF8StringEncoding];*/
    
    NSLog(@"%@", orderInfo);
    
    NSData *requestData = [[NSString stringWithFormat:@"huid=%@&password=%@&order=%@", user.huid, user.pin, [NSString urlEncodeValue:orderInfo]]dataUsingEncoding:NSUTF8StringEncoding];
    
	[request setHTTPMethod:@"POST"];
	[request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*//*;q=0.8" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: requestData];
    
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:d];
    
    [myConnection start];
    
    //TODO - give option to place another order
    //[self.navigationController popToRootViewControllerAnimated:YES];

   /*if(!d.didWork)
   {
       // display error message
       [self showAlertWithString: 
        @"Incorrect HUID/PIN" ];
   }*/
    
    /*bool isAuthenticated = false;
    
    // prepare to select a meal
    SelectionViewController* selectionController = [[SelectionViewController alloc] 
                               initWithNibName:@"SelectionViewController" 
                               bundle:nil];
    
    // go to the next view if correct HUID & PIN has been entered
    if (isAuthenticated) 
    {
        selectionController.user = user;
        
        // display the next view
        [self.navigationController pushViewController:selectionController 
                                             animated:YES];
    }
    else
    {
        
        [myConnection cancel];
    }*/
    
    
	/*ConnectionDelegate* d = [[ConnectionDelegate alloc] init];
    
    NSURL *url = [NSURL URLWithString: @"http://cloud.cs50.net/~ruthfong/pin.php"]; 
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	
    // create a UserInformation object with the entered username and password
    UserInformation* user = [[UserInformation alloc] initWithHUID:username.text andPIN:password.text];
    
	NSData *requestData = [[NSString stringWithFormat:@"huid=%@&password=%@&order=%@", user.huid, user.pin, [NSString urlEncodeValue:orderInfo]]dataUsingEncoding:NSUTF8StringEncoding];
    
	[request setHTTPMethod:@"POST"];
	[request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*//*;q=0.8" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: requestData];
    
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:d];
    
    [myConnection start];*/
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    password.secureTextEntry = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.username = nil;
    self.password = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
