//
//  ResetPasswordTableViewController.h
//  simple login sample v2
//
//  Created by Javier Albillos on 24/2/15.
//  Copyright (c) 2015 Gamedonia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordTableViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *eMailTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetPassButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end
