//
//  SignupVC.m
//  Chat
//
//  Created by Nikolay Petrovich on 4/11/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import "SignupVC.h"
#import "Utils.h"
#import <Quickblox/Quickblox.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>
#import "Constants.h"

@interface SignupVC ()<UITextFieldDelegate>
{
    UIImage *imgProfile;
}

@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_m_tfID setDelegate:self];
    [_m_tfPwd setDelegate:self];
    [_m_tfName setDelegate:self];
    [_m_tfPwdConf setDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _m_btnRegister.layer.cornerRadius = 4.0;
    _m_btnRegister.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (BOOL) checkInputValues{
    NSString *idStr = [_m_tfID text];
    NSString *pwdStr = [_m_tfPwd text];
    NSString *pwdConfStr = [_m_tfPwdConf text];
    NSString *nameStr = [_m_tfName text];
    
    UIView* focusView = nil;
    NSString *errMsg = @"";
    if([idStr isEqualToString:@""])
    {
        focusView = _m_tfID;
        errMsg = @"Please input Id";
    }
    else if([pwdStr isEqualToString:@""])
    {
        focusView = _m_tfPwd;
        errMsg =  @"Please input password";
    }
    else if([pwdConfStr isEqualToString:@""])
    {
        focusView = _m_tfPwdConf;
        errMsg = @"Please confirm your password";
    }
    else if([nameStr isEqualToString:@""])
    {
        focusView = _m_tfName;
        errMsg = @"Please input name";
    }
    else if(![pwdConfStr isEqualToString:pwdStr])
    {
        focusView = _m_tfPwd;
        errMsg = @"Password does not match";
    }
    else if([pwdStr length] < 8)
    {
        focusView = _m_tfPwd;
        errMsg = @"Password is too short(Minimum is 8 characters)";
    }
    else if([nameStr length] < 3)
    {
        focusView = _m_tfName;
        errMsg = @"Name is too short(Minimum is 3 characters)";
    }
    
    if(focusView != nil){
        [Utils showAlertView:nil Message:errMsg];
        [focusView becomeFirstResponder];
        return FALSE;
    }
    return  TRUE;
}

- (void) saveLoginInfo{
    [Utils storeValue:_m_tfID.text Key:PREF_KEY_LAST_LOGIN_USER_ID];
    [Utils storeValue:_m_tfPwd Key:PREF_KEY_LAST_LOGIN_USER_PWD];
}

- (IBAction)onBtnNavBack:(id)sender {
    POP_VIEWCONT;
}

- (IBAction)onBtnRegister:(id)sender{
    BOOL checkResult = [self checkInputValues];
    if(!checkResult)
        return;
    
    [self createAccount];
}

#pragma mark- UITextfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{              // called when 'return' key pressed. return NO to ignore.
    [textField resignFirstResponder];
    if(textField == _m_tfID)
    {
        [_m_tfName becomeFirstResponder];
    }
    else if(textField == _m_tfName)
    {
        [_m_tfPwd becomeFirstResponder];
    }
    else if(textField == _m_tfPwd)
    {
        [_m_tfPwdConf becomeFirstResponder];
    }
    else if(textField == _m_tfPwdConf)
    {
        [self onBtnRegister:nil];
    }
    return TRUE;
}

#pragma mark - private method for QuickBlox
- (void)createAccount
{
    [self.view endEditing:YES];
    QBUUser *user = [QBUUser user];
    
    user.login = _m_tfID.text;
    user.password = _m_tfPwd.text;
    user.fullName = _m_tfName.text;
    user.customData = @"AvatarImage";
    
    [Utils showLoadingView];
    
    [QBRequest signUp:user successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
        // success sign up
        NSLog(@"Signup Success");
        [Utils showToast:@"Signup Success!"];
        [Utils hideLoadingView];
        
        NSArray *vcAry = self.navigationController.viewControllers;
        NSMutableArray *vcMAry = [NSMutableArray arrayWithArray:vcAry];
        [vcMAry removeLastObject];
        [self.navigationController setViewControllers:[vcMAry arrayByAddingObject:[Utils viewContWithStoryId:@"LoginVC"]]];
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        // failed sign up
        NSLog(@"Signup failed with %@", response.error);
        [Utils showToast:[NSString stringWithFormat:@"Signup failed with %@", response.error]];
        [Utils hideLoadingView];
    }];
}

@end
