//
//  SignupVC.h
//  Chat
//
//  Created by Nikolay Petrovich on 4/11/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *              m_tfID;
@property (weak, nonatomic) IBOutlet UITextField *              m_tfPwd;
@property (weak, nonatomic) IBOutlet UITextField *              m_tfPwdConf;
@property (weak, nonatomic) IBOutlet UITextField *              m_tfName;

@property (weak, nonatomic) IBOutlet UIButton *                 m_btnRegister;

- (IBAction)onBtnNavBack:(id)sender;
- (IBAction)onBtnRegister:(id)sender;
@end
