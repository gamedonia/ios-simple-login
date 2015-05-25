
//
//  LoginTableViewController.m
//  simple login sample v2
//
//  Created by Javier Albillos on 24/2/15.
//  Copyright (c) 2015 Gamedonia. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginTableViewController.h"

#include <CoreGraphics/CGGeometry.h>

#import <GamedoniaSDK/Gamedonia.h>

#import <FacebookSDK/FacebookSDK.h>



@interface LoginTableViewController ()

@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    float grey = (float) 238/255.0f;
    self.view.backgroundColor = [UIColor colorWithRed:(grey)
                                                green:(grey)
                                                 blue:(grey)
                                                alpha:1.0f];
    
    UIImageView *CurrentImage = [UIImageView alloc];
    CurrentImage = [CurrentImage initWithImage:[UIImage imageNamed:@"background"]];
    CurrentImage.frame = self.view.bounds;
    
    [self.tableView setBackgroundView:CurrentImage];
    
    
    _passTextField.secureTextEntry = YES;
    
    _eMailTextField.delegate = self;
    _passTextField.delegate = self;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    //Facebook check for open sessions
    // Whenever a person opens app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // Call this method EACH time the session state changes,
                                          //  NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    NSString *ses_token = [NSString alloc];
    ses_token = [[Gamedonia users] getSessionToken];
    
    if(ses_token != nil)
    {
        [[Gamedonia users] loginUserWithSessionToken:ses_token callback:^(BOOL success) {
            
            if(success) {
                
                [self performSegueWithIdentifier:@"goToUserDetails" sender:self];
            }
            else{
                
                NSLog(@"No active session token detected.");
            }
        }];
        
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    _passTextField.text = @"";
    
    [self textFieldShouldReturn:_eMailTextField];
    [self textFieldShouldReturn:_passTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickLogin:(id)sender {
    
    NSString *mail = [NSString alloc];
    NSString *pass = [NSString alloc];
    
    mail = _eMailTextField.text;
    pass = _passTextField.text;
    
    NSString *alertText;
    NSString *alertTitle;
    
    if (![mail isEqual: @""] && ![pass isEqual:@""]) {
        
        [[Gamedonia users] loginUserWithEmail:mail password:pass callback:^(BOOL success) {
            
            if (success) {
                
                [self performSegueWithIdentifier:@"goToUserDetails" sender:sender];
                
            } else {
                
                NSString *alertText;
                NSString *alertTitle;
                alertTitle = @"Login failure";
                alertText = @"Invalid user name/password. Try again.";
                [self showMessage:alertText withTitle:alertTitle];
            }
        }];
    }
    else {
        
        alertTitle = @"Empty fields";
        alertText = @"One or more fields are empty.";
        [self showMessage:alertText withTitle:alertTitle];
    }
    
}

- (IBAction)clickFacebook:(id)sender {
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
        
    } else {
        
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             /*
              // Retrieve the app delegate
              AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
              // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
              [appDelegate sessionStateChanged:session state:state error:error];
              */
             
             [self sessionStateChanged:session state:state error:error];
             
         }];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *) recognizer {
    
    [self.view endEditing:YES];
}

// Handles session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen) {
        
        // Show the user the logged-in UI
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                
                NSString *fb_access_token = [NSString alloc];
                fb_access_token = [FBSession activeSession].accessTokenData.accessToken;
                
                NSString *fb_uid = [NSString alloc];
                fb_uid =[result valueForKey:@"id"];
                
                NSString *fb_name = [NSString alloc];
                fb_name =[result valueForKey:@"name"];
                
                
                Credentials *credentials = [[Credentials alloc] init];
                [credentials setFb_uid: fb_uid];
                [credentials setFb_access_token:fb_access_token];
                
                GDUser * user = [GDUser alloc];
                NSMutableDictionary *profile = [NSMutableDictionary dictionary];
                
                NSString *dateString = [NSString alloc];
                dateString = [self getDate];
                
                [profile setValue:fb_name forKey:@"nickname"];
                [profile setValue:dateString forKey:@"registerDate"];
                
                [user setProfile:profile];
                [user setCredentials:credentials];
                
                
                [[Gamedonia users] createUser:user
                                     callback:^(BOOL cr_success) {
                                         
                                         [[Gamedonia users] loginUserWithFacebook:fb_uid
                                                                    fbAccessToken:fb_access_token
                                                                         callback:^(BOOL success) {
                                                                             if (success) {
                                                                                 
                                                                                 [self performSegueWithIdentifier:@"goToUserDetails" sender:self];
                                                                                 
                                                                             } else {
                                                                                 NSLog(@"Failed to login the user.");
                                                                             }
                                                                         }];
                                         
                                     }];
                
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
        
        // If the session is closed
    }
    
    // Handle errors
    if (error) {
        
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES) {
            
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
            
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
                
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        
    }
}


-(NSString*)getDate
{
    NSDate *now = [[NSDate alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:now];
    return stringFromDate;
}


-(void)showMessage:(NSString*)message withTitle:(NSString*)title{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    //cell.frame.size.height = view.frame.size.height;
    return cell;
}



@end
