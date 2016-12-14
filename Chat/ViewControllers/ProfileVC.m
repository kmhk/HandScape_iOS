//
//  ProfileVC.m
//  Chat
//
//  Created by Nikolay Petrovich on 4/12/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import "ProfileVC.h"
#import <Quickblox/Quickblox.h>
#import "Utils.h"

BOOL isPickerShow;
@implementation ProfileVC

- (void) viewDidLoad{
    [super viewDidLoad];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView)];
    [self.view addGestureRecognizer:gesture];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    QBUUser *curUser = _gDKeeper.currentQBUser;
    _m_txtEmail.text = curUser.email;
    _m_txtLogin.text = curUser.login;
    _m_txtName.text = curUser.fullName;
    _m_txtPhone.text = curUser.phone;
    _m_txtWebsite.text = curUser.website;
    //[_m_Switch setOn:FALSE];
    [self setTextFieldEnable:TRUE];
    
    isPickerShow = FALSE;
    imgProfile = nil;
    
    UITapGestureRecognizer *imgViewGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedOnProfiePhoto:)];
    [_m_ivProfile addGestureRecognizer:imgViewGest];
    [_m_ivProfile setUserInteractionEnabled:YES];
    
    CGRect rt = _m_ivProfile.frame;
    _m_ivProfile.layer.cornerRadius = _m_ivProfile.frame.size.width / 2;
    _m_ivProfile.clipsToBounds = YES;
    _m_ivProfile.contentMode = UIViewContentModeScaleAspectFill;
    _m_ivProfile.layer.borderWidth = 1.0;
    _m_ivProfile.layer.borderColor = [UIColor colorWithRed:0 green:97/255.0 blue:147.0/255.0 alpha:1.0].CGColor;
    _m_ivProfile.frame = rt;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(isPickerShow)
    {
        if(imgProfile == nil)
        {
            [_m_ivProfile setImage:[UIImage imageNamed:@"btn_addPhoto.png"]];
        }
        else
        {
            [_m_ivProfile setImage:imgProfile];
        }
        isPickerShow = FALSE;
    }
    else
    {
        if(_gDKeeper.curUserPic != nil)
            [_m_ivProfile setImage:_gDKeeper.curUserPic];
        else
            [_m_ivProfile setImage:[UIImage imageNamed:@"btn_addPhoto.png"]];
    }
}

- (void) onTapView{
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void) tapedOnProfiePhoto:(id) sender{
    //Alert Controller Menu
    UIAlertController* alertControllerMenu = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* actTakePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            //            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
            isPickerShow = TRUE;
        }
        
    }];
    
    UIAlertAction* actFromLibrary = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            picker.allowsEditing = YES;
            picker.delegate = self;
            //imgSelected = @"1";
            [self presentViewController:picker animated:YES completion:nil];
            isPickerShow = TRUE;
        }
        
    }];
    
    [alertControllerMenu addAction:actTakePhoto];
    [alertControllerMenu addAction:actFromLibrary];
    
    [alertControllerMenu addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alertControllerMenu animated:YES completion:^{
        
    }];
}

- (void) setTextFieldEnable:(BOOL) bEnable{
    [self.m_txtEmail setEnabled:bEnable];
    [self.m_txtLogin setEnabled:bEnable];
    [self.m_txtName setEnabled:bEnable];
    [self.m_txtPhone setEnabled:bEnable];
    [self.m_txtWebsite setEnabled:bEnable];
}

- (IBAction)onBtnLogout:(id)sender{
}

- (IBAction)onBtnSave:(id)sender
{
    if((![_m_txtEmail.text isEqualToString:@""]) && (![Utils checkEmailValidate:_m_txtEmail.text])){
        [Utils showAlertView:nil Message:@"Please input correct email"];
        return;
    }
    
    if((_m_ivProfile.image != _gDKeeper.curUserPic) && (_gDKeeper.curUserPic != nil)){
        [Utils showLoadingView];
        NSData *avatar = UIImagePNGRepresentation(_m_ivProfile.image);
        [QBRequest TUploadFile:avatar fileName:@"MyAvatar" contentType:@"image/png" isPublic:NO successBlock:^(QBResponse * _Nonnull response, QBCBlob * _Nonnull blob) {
            [self updateUserInfo:blob];
        } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
            
        } errorBlock:^(QBResponse * _Nonnull response) {
            [Utils hideLoadingView];
            [Utils showToast:@"Upload Image Failed!"];
        }];
    }
    else
        [self updateUserInfo:nil];
}

- (IBAction)onSwitchChange:(id)sender {
    UISwitch *switcher = (UISwitch*) sender;
    if(switcher.isOn){
        [self setTextFieldEnable:TRUE];
    }
    else{
        [self setTextFieldEnable:FALSE];
    }
}

- (void) updateUserInfo:(QBCBlob *) blob{
    QBUpdateUserParameters *updateParameters = [QBUpdateUserParameters new];
    
    if (self.m_txtLogin.text.length > 0) updateParameters.login = self.m_txtLogin.text;
    
    if (self.m_txtName.text.length > 0) updateParameters.fullName = self.m_txtName.text;
    
    if (self.m_txtEmail.text.length > 0) updateParameters.email = self.m_txtEmail.text;
    
    if (self.m_txtPhone.text.length > 0) updateParameters.phone = self.m_txtPhone.text;
    
    if (blob != nil) updateParameters.blobID = blob.ID;
    
    [Utils showLoadingView];
    [QBRequest updateCurrentUser:updateParameters successBlock:^(QBResponse *response, QBUUser *user) {
        [Utils hideLoadingView];
        _gDKeeper.curUserPic = _m_ivProfile.image;
        _gDKeeper.currentQBUser = user;
    } errorBlock:^(QBResponse *response) {
        [Utils hideLoadingView];
        
        NSLog(@"Errors=%@", [response.error description]);
        [Utils showToast:[response.error  description]];
    }];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    UIImage *originalImage, *editedImage;
    editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (editedImage)
    {
        imgProfile =[Utils fixOrientation:editedImage];
    }
    else
    {
        imgProfile =  [Utils fixOrientation:originalImage];
    }
    
    _m_ivProfile.image = imgProfile;
}

#pragma mark- UITextfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{              // called when 'return' key pressed. return NO to ignore.
    [textField resignFirstResponder];
    if(textField == _m_txtName)
    {
        [_m_txtLogin becomeFirstResponder];
    }
    else if(textField == _m_txtLogin)
    {
        [_m_txtEmail becomeFirstResponder];
    }
    else if(textField == _m_txtEmail)
    {
        [_m_txtPhone becomeFirstResponder];
    }
    else if(textField== _m_txtPhone)
    {
        [_m_txtWebsite becomeFirstResponder];
    }
    else if(_m_txtWebsite == textField){
        [self onBtnSave:nil];
    }
    return TRUE;
}

@end
