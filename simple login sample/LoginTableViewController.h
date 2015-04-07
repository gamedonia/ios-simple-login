//
//  LoginTableViewController.h
//  simple login sample v2
//
//  Created by Javier Albillos on 24/2/15.
//  Copyright (c) 2015 Gamedonia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GamedoniaSDK/Gamedonia.h>

@interface LoginTableViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *eMailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;


@end
