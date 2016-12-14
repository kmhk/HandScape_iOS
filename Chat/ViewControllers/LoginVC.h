//
//  LoginVC.h
//  Chat
//
//  Created by Nikolay Petrovich on 4/11/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LoginVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *              m_tfID;
@property (weak, nonatomic) IBOutlet UITextField *              m_tfPwd;
@property (weak, nonatomic) IBOutlet UIButton *                 m_btnLogin;

- (IBAction)onBtnNavBack:(id)sender;
- (IBAction)onBtnLogin:(id)sender;

@end
