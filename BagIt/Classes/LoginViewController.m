//
//  LoginViewController.m
//  BagIt
//
//  Created by Ruth Fong on 1/15/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInformation.h"
#import "NSString+URLEncoding.h"
#import "SelectionViewController.h"
#import "NSObject+Addons.h"
#import "CJSONDeserializer.h"
#import "ConnectionDelegate.h"

@implementation LoginViewController

@synthesize username, password, user, orderInfo, responseData, didWork, cLoadingView, loadingModal;

- (IBAction) textFieldReturn: (id) sender
{
	// quit keyboard (i.e. first responder)
	[sender resignFirstResponder];
}

- (IBAction) backgroundTouched: (id) sender
{
    [username resignFirstResponder];
    [password resignFirstResponder];
}

-(IBAction)submit:(id)sender
{

    // hide keyboard
    [self backgroundTouched:sender];
    
    // check that a username and password has been entered in
    if ([username.text isEqualToString:@""] || [password.text isEqualToString:@""]) 
    {
        // display error message
        [self showAlertWithString: @"HUID and/or PIN not entered."];
        return;
    }
    
    // remember the url
    NSURL *url = [NSURL URLWithString: @"https://cloud.cs50.net/~ruthfong/pin.php"]; 
    
    // setup the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

    // remember the user's id and pin
    user = [[UserInformation alloc] initWithHUID:username.text andPIN:password.text];
    
	/*NSData *requestData = [[NSString stringWithFormat:@"huid=%@&password=%@", user.huid, user.pin]dataUsingEncoding:NSUTF8StringEncoding];*/
    
    // debugging
    //NSLog(@"%@", orderInfo);
    
    // setup the data to be submitted
    NSData *requestData = [[NSString stringWithFormat:@"huid=%@&password=%@&url=%@", user.huid, user.pin, [NSString urlEncodeValue:orderInfo]]dataUsingEncoding:NSUTF8StringEncoding];
        
    // setup HTTP headers
	[request setHTTPMethod:@"POST"];
	[request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*//*;q=0.8" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: requestData];
    
    // initialize a data object to save HTTP response body
    responseData = [[NSMutableData alloc] init];
    
    /*ConnectionDelegate* d = [[ConnectionDelegate alloc] init];
    d.viewController = self;
    // initialize the next view to select a meal
    SelectionViewController *selectionViewController = 
    [[SelectionViewController alloc] 
     initWithNibName:@"SelectionViewController" bundle:nil];
    
    // set the view controller's title
    selectionViewController.title = @"Select a meal";
    
    // create popup alert
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"What Now?"
                                                      message:@"Do you want to logout or place another order?"
                                                     delegate:self
                                            cancelButtonTitle:@"Order"
                                            otherButtonTitles:@"Logout", nil];

    // pass to the connection delegate
    d.nextViewController = selectionViewController;
    d.message = message;*/
    // setup connection and start the connection
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];

    [myConnection start];
    
    // show loading modal
    loadingModal = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
    loadingModal.labelText = @"Loading";
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

-(void)viewDidAppear:(BOOL)animated
{
    // clear username & password fields everytime the view is loaded
    username.text = @"";
    password.text= @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    password.secureTextEntry = YES;
    self.title = @"Login";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.username = nil;
    self.password = nil;
    self.user = nil;
    self.orderInfo = nil;
    self.responseData = nil;
    self.didWork = nil;
    self.loadingModal = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    [responseData setLength:0];
    NSLog(@"Yay! Connection was made.");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    // save received data
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    // hide loading modal
	[loadingModal hide:YES];
    
    NSError* error = nil;
    NSDictionary* responseDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData
                                                                                           error:&error];
    
    if (!error) 
    {
        didWork = [responseDictionary valueForKey:@"didWork"];
        
        NSLog(@"%@", didWork);
        //if ([didWork isEqualToString:@"yes"]) 
        {
            NSLog(@"Yay!");
            
            // initialize the next view to select a meal
			SelectionViewController *selectionViewController = 
			[[SelectionViewController alloc] 
			 initWithNibName:@"SelectionViewController" bundle:nil];
			
			// set the view controller's title
			selectionViewController.title = @"Select a meal";
			
            // pass user information to next view
            selectionViewController.user = user;
            
			// display the view
			[self.navigationController pushViewController:selectionViewController 
                                                 animated:YES];
            
        }
        /*else
        {   
            // display error message
            [self showAlertWithString: @"Invalid HUID and/or PIN."];
        }*/
    }
    else
    {
        NSLog(@"%@", error);
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    // Show error
	NSLog(@"something very bad happened here: %@", error);

    // hide loading modal
	[loadingModal hide:YES];
}

@end
