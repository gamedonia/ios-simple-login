//
//  ResetPasswordTableViewController.m
//  simple login sample v2
//
//  Created by Javier Albillos on 24/2/15.
//  Copyright (c) 2015 Gamedonia. All rights reserved.
//

#import "ResetPasswordTableViewController.h"

#import <GamedoniaSDK/Gamedonia.h>

@interface ResetPasswordTableViewController ()

@end

@implementation ResetPasswordTableViewController

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
    
    
    _eMailTextField.delegate = self;
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];

}

- (void) didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickResetPass:(id)sender {
    
    NSString *mail = [NSString alloc];
    mail = _eMailTextField.text;
    
    if (![mail isEqual:@""]) {
        
        [[Gamedonia users] resetPassword:mail
                                callback:^(BOOL success) {
                                    
                                    if (success) {
                                        
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Reset done" message:@"An email has been sent to your account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [alert show];
                                        
                                    } else {
                                        
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Reset failure" message:@"The account doesn't exist." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [alert show];
                                        
                                    }
        }];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Empty field" message:@"Fill in your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

    
}

- (IBAction) clickBack:(id)sender {
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
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
