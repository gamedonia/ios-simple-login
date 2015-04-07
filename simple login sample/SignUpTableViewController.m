//
//  SignUpTableViewController.m
//  simple login sample v2
//
//  Created by Javier Albillos on 24/2/15.
//  Copyright (c) 2015 Gamedonia. All rights reserved.
//

#import "SignUpTableViewController.h"

#import <GamedoniaSDK/Gamedonia.h>

@interface SignUpTableViewController ()

@end

@implementation SignUpTableViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
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
    _rePassTextField.secureTextEntry = YES;
    
    _eMailTextField.delegate = self;
    _passTextField.delegate = self;
    _rePassTextField.delegate = self;
    _nickTextField.delegate = self;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];

}

- (void) didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) clickSignUp:(id)sender {
    
    NSString *dateString = [NSString alloc];
    dateString = [self getDate];
    
    NSString *mail = [NSString alloc];
    NSString *pass = [NSString alloc];
    NSString *rePass = [NSString alloc];
    NSString *nick = [NSString alloc];
    
    mail = _eMailTextField.text;
    pass = _passTextField.text;
    rePass = _rePassTextField.text;
    nick = _nickTextField.text;
    
    if (![mail isEqual: @""] && ![pass isEqual:@""] && ![rePass isEqual:@""] && ![nick isEqual:@""] && [pass isEqual:rePass]) {
        
        Credentials *credentials = [[Credentials alloc] init];
        [credentials setEmail:mail];
        [credentials setPassword:pass];
        
        GDUser * user = [GDUser alloc];
        NSMutableDictionary *profile = [NSMutableDictionary dictionary];
        
        [profile setValue:nick forKey:@"nickname"];
        [profile setValue:dateString forKey:@"registerDate"];
        
        [user setProfile:profile];
        [user setCredentials:credentials];
        
        [[Gamedonia users] createUser:user
                             callback:^(BOOL success) {
                                 if (success) {
                                     
                                     [[Gamedonia users] loginUserWithEmail:mail password:pass callback:^(BOOL success) {
                                         if (success) {
                                             
                                             [self performSegueWithIdentifier:@"goToUserDetailsFromSignUp" sender:sender];
                                             
                                         } else {
                                             
                                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login failure" message:@"Invalid user name/password. Try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                             [alert show];
                                         }
                                     }];
                                 } else {

                                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register failure" message:@"Could not create the user. Email already in use or invalid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                     [alert show];
                                 }
                             }];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register failure" message:@"Fill all the fields with (*) correctly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

    
}

- (IBAction) clickCancel:(id)sender {
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

-(NSString*) getDate {
    
    NSDate *now = [[NSDate alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:now];
    return stringFromDate;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) handleTap:(UITapGestureRecognizer *)recognizer {
    
    [self.view endEditing:YES];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

@end
