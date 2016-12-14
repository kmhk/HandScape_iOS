//
//  ProfileVC.h
//  Chat
//
//  Created by Nikolay Petrovich on 4/12/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController<UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    UIImage *imgProfile;
}
@property (weak, nonatomic) IBOutlet UITextField*   m_txtName;
@property (weak, nonatomic) IBOutlet UITextField*   m_txtLogin;
@property (weak, nonatomic) IBOutlet UITextField*   m_txtEmail;
@property (weak, nonatomic) IBOutlet UITextField*   m_txtPhone;
@property (weak, nonatomic) IBOutlet UITextField*   m_txtWebsite;
@property (weak, nonatomic) IBOutlet UISwitch*      m_Switch;
@property (weak, nonatomic) IBOutlet UIButton*      m_btnSave;

@property (weak, nonatomic) IBOutlet UIImageView *m_ivProfile;

- (IBAction)onBtnLogout:(id)sender;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onSwitchChange:(id)sender;
@end
