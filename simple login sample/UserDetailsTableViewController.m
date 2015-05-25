//
//  UserDetailsTableViewController.m
//  simple login sample v2
//
//  Created by Javier Albillos on 24/2/15.
//  Copyright (c) 2015 Gamedonia. All rights reserved.
//

#import "UserDetailsTableViewController.h"

#import <GamedoniaSDK/Gamedonia.h>

#import <FacebookSDK/FacebookSDK.h>

@interface UserDetailsTableViewController ()

@end

@implementation UserDetailsTableViewController

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
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    [[Gamedonia users] getMe:^(BOOL success, GDUserProfile *userProfile) {
        
        if (success) {
            
            _nickLabel.text = [[userProfile profile] valueForKey:@"nickname"];
            _regDateLabel.text = [[userProfile profile] valueForKey:@"registerDate"];
            
        } else {
            
            NSLog(@"Get me call failed.");
        }
    }];
    
}

- (void) didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) clickLogout:(id)sender {
    
    [[Gamedonia users] logoutUser:^(BOOL success) {
        
        if (success) {
            
            [[self navigationController] popToRootViewControllerAnimated:YES];
            
        } else {
            
            NSLog(@"Logout failed.");
        }
    }];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


@end
