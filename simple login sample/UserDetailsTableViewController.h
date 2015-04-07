//
//  UserDetailsTableViewController.h
//  simple login sample v2
//
//  Created by Javier Albillos on 24/2/15.
//  Copyright (c) 2015 Gamedonia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *regDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end
