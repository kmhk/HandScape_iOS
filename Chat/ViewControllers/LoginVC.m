//
//  LoginVC.m
//  Chat
//
//  Created by Nikolay Petrovich on 4/11/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import "LoginVC.h"
#import "Utils.h"
#import <Quickblox/Quickblox.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>
#import "ChatManager.h"
#import "QBUUser+IndexAndColor.h"
#import "Settings.h"
#import "ServicesManager.h"
#import "SVProgressHUD.h"
#import "UsersDataSource.h"
#import "UserTableViewCell.h"
#import "UsersDataSource.h"

@interface LoginVC ()<UITextFieldDelegate> // NotificationServiceDelegate>
@property (strong, nonatomic) Settings *settings;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_m_tfID setDelegate:self];
    [_m_tfPwd setDelegate:self];
    
    _m_btnLogin.layer.cornerRadius = 4.0;
    _m_btnLogin.clipsToBounds = YES;
    
    if([Utils loadValue:PREF_KEY_LAST_LOGIN_USER_ID])
        [_m_tfID setText:[Utils loadValue:PREF_KEY_LAST_LOGIN_USER_ID]];
    
#ifdef TEST_MODE
    if([Utils loadValue:PREF_KEY_LAST_LOGIN_USER_PWD])
        [_m_tfPwd setText:[Utils loadValue:PREF_KEY_LAST_LOGIN_USER_PWD]];
#endif
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView)];
    [self.view addGestureRecognizer:gesture];
    
//    if (ServicesManager.instance.currentUser != nil) {
//        // loggin in with previous user
////        ServicesManager.instance.currentUser.password = kTestUsersDefaultPassword;
//        [SVProgressHUD showWithStatus:[NSLocalizedString(@"SA_STR_LOGGING_IN_AS", nil) stringByAppendingString:ServicesManager.instance.currentUser.login]];
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//        
//        __weak __typeof(self)weakSelf = self;
//        [ServicesManager.instance logInWithUser:ServicesManager.instance.currentUser completion:^(BOOL success, NSString *errorMessage) {
//            if (success) {
//                __typeof(self) strongSelf = weakSelf;
//                [strongSelf registerForRemoteNotifications];
//                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SA_STR_LOGGED_IN", nil)];
//                
//                if (ServicesManager.instance.notificationService.pushDialogID == nil) {
//                    [strongSelf performSegueWithIdentifier:kGoToDialogsSegueIdentifier sender:nil];
//                }
//                else {
//                    [ServicesManager.instance.notificationService handlePushNotificationWithDelegate:self];
//                }
//                
//            } else {
//                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SA_STR_ERROR", nil)];
//            }
//        }];
//    }
}


//- (void)retrieveUsers
//{
//    __weak __typeof(self)weakSelf = self;
//    
//    // Retrieving users from cache.
//    [[[ServicesManager instance].usersService loadFromCache] continueWithBlock:^id(BFTask *task) {
//        //
//        if ([task.result count] > 0) {
//            [weakSelf loadDataSourceWithUsers:[[ServicesManager instance] filteredUsersByCurrentEnvironment]];
//        } else {
//            [weakSelf downloadLatestUsers];
//        }
//        
//        return nil;
//    }];
//}

//- (void)downloadLatestUsers
//{
//    if (self.isUsersAreDownloading) return;
//    
//    self.usersAreDownloading = YES;
//    
//    __weak __typeof(self)weakSelf = self;
//    [SVProgressHUD showWithStatus:NSLocalizedString(@"SA_STR_LOADING_USERS", nil) maskType:SVProgressHUDMaskTypeClear];
//    
//    // Downloading latest users.
//    [[ServicesManager instance] downloadLatestUsersWithSuccessBlock:^(NSArray *latestUsers) {
//        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SA_STR_COMPLETED", nil)];
//        [weakSelf loadDataSourceWithUsers:latestUsers];
//        weakSelf.usersAreDownloading = NO;
//    } errorBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"SA_STR_CANT_DOWNLOAD_USERS", nil), error.localizedRecoverySuggestion]];
//        weakSelf.usersAreDownloading = NO;
//    }];
//}

- (void)loadDataSourceWithUsers:(NSArray *)users
{
//    self.dataSource = [[UsersDataSource alloc] initWithUsers:users];
//    self.dataSource.isLoginDataSource = YES;
//    self.tableView.dataSource = self.dataSource;
//    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated{
//    _m_tfPwd.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) onTapView{
    [self.view endEditing:YES];
}

- (BOOL) checkInputValues{
    NSString *idStr = [_m_tfID text];
    NSString *pwdStr = [_m_tfPwd text];
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
    
    if(focusView != nil){
        [Utils showAlertView:nil Message:errMsg];
        [focusView becomeFirstResponder];
        return FALSE;
    }
    return  TRUE;
}

- (void) saveLoginInfo{
    [Utils storeValue:_m_tfID.text Key:PREF_KEY_LAST_LOGIN_USER_ID];
    [Utils storeValue:_m_tfPwd.text Key:PREF_KEY_LAST_LOGIN_USER_PWD];
}

- (IBAction)onBtnNavBack:(id)sender {
    POP_VIEWCONT;
}

- (IBAction)onBtnLogin:(id)sender{
    BOOL checkResult = [self checkInputValues];
    if(!checkResult)
        return;

    [self.view endEditing:YES];
    
    QBUUser *user = [QBUUser user];
    user.login = _m_tfID.text;
//    user.ID = 11630393;
    user.password = _m_tfPwd.text;
    
    [self user_login:user];
}

- (void) chat_login:(QBUUser *) user{
    [Utils showLoadingView];
    __weak __typeof(self)weakSelf = self;
	
	[ServicesManager.instance logInWithUser:user completion:^(BOOL success, NSString *errorMessage) {
		if (success) {
			[SVProgressHUD dismiss];
			[weakSelf applyConfiguration];
            [self saveLoginInfo];
			PUSH_VIEWCONT(@"MainTabBarVC");
		} else {
			[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Login chat error!", nil)];
		}
		
		[Utils hideLoadingView];
	}];
}

- (void)applyConfiguration {
    
    NSMutableArray *iceServers = [NSMutableArray array];
    
    for (NSString *url in self.settings.stunServers) {
        
        QBRTCICEServer *server = [QBRTCICEServer serverWithURL:url username:@"" password:@""];
        [iceServers addObject:server];
    }
    
    [iceServers addObjectsFromArray:[self quickbloxICE]];
    
    [QBRTCConfig setICEServers:iceServers];
    [QBRTCConfig setMediaStreamConfiguration:self.settings.mediaConfiguration];
    [QBRTCConfig setStatsReportTimeInterval:1.f];
}

- (NSArray *)quickbloxICE {
    
    NSString *password = @"baccb97ba2d92d71e26eb9886da5f1e0";
    NSString *userName = @"quickblox";
    
    QBRTCICEServer * stunServer = [QBRTCICEServer serverWithURL:@"stun:turn.quickblox.com"
                                                       username:@""
                                                       password:@""];
    
    QBRTCICEServer * turnUDPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=udp"
                                                          username:userName
                                                          password:password];
    
    QBRTCICEServer * turnTCPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=tcp"
                                                          username:userName
                                                          password:password];
    
    
    return@[stunServer, turnTCPServer, turnUDPServer];
}

- (void) user_login:(QBUUser *) user{
    [Utils showLoadingView];

    QBRequest *request = nil;
    if (user.login) {
        request = [QBRequest logInWithUserLogin:user.login password:user.password successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable retUser) {
			
            NSLog(@"Login with login Success!");
            NSLog(@"Login with login Response: %@", response);
            
            if(user != nil)
                _gDKeeper.currentQBUser = retUser;
            
            _gDKeeper.currentQBUser.password = user.password;

            [self getUserList];
        } errorBlock:^(QBResponse * _Nonnull response) {
            [Utils hideLoadingView];
            NSLog(@"Login with login Failed!");
            NSLog(@"Login with login Response: %@", response);

            [Utils showToast:[NSString stringWithFormat:@"Login Failed: %@", response]];
        }];
    }
    else{
        [Utils hideLoadingView];
    }
}

- (void) getUserList{
    [Utils showLoadingView];
    QBGeneralResponsePage *responsePage = [QBGeneralResponsePage responsePageWithCurrentPage:0 perPage:100];

    [QBRequest usersForPage:responsePage successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
        if([_gDKeeper.userAry count] > 0)
            [_gDKeeper.userAry removeAllObjects];
        
        [UsersDataSource.instance initUsersWithArray:users];
        
        _gDKeeper.userAry = [users mutableCopy];

        //Remove cur login user info
        for (QBUUser *user in _gDKeeper.userAry) {
            if (user.ID == _gDKeeper.currentQBUser.ID) {
                [_gDKeeper.userAry removeObject:user];
                break;
            }
        }
        NSLog(@"Response: %@", response);
        NSLog(@"Page: %@", page);
        NSLog(@"%@", users);

        [self chat_login:_gDKeeper.currentQBUser];
    } errorBlock:^(QBResponse *response) {
        NSLog(@"error: %@", response.error);
        [Utils hideLoadingView];
    }];
}

#pragma mark- UITextfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{              // called when 'return' key pressed. return NO to ignore.
    if(textField == _m_tfID)
    {
        [_m_tfPwd becomeFirstResponder];
    }
    else if(textField == _m_tfPwd)
    {
        [self onBtnLogin:nil];
    }
    return TRUE;
}

//#pragma mark - NotificationServiceDelegate protocol
//
//- (void)notificationServiceDidStartLoadingDialogFromServer {
//    [SVProgressHUD showWithStatus:NSLocalizedString(@"SA_STR_LOADING_DIALOG", nil) maskType:SVProgressHUDMaskTypeClear];
//}
//
//- (void)notificationServiceDidFinishLoadingDialogFromServer {
//    [SVProgressHUD dismiss];
//}
//
//- (void)notificationServiceDidSucceedFetchingDialog:(QBChatDialog *)chatDialog {
//    DialogsViewController *dialogsController = (DialogsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DialogsViewController"];
//    ChatViewController *chatController = (ChatViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
//    chatController.dialog = chatDialog;
//    
//    self.navigationController.viewControllers = @[dialogsController, chatController];
//}
//
//- (void)notificationServiceDidFailFetchingDialog {
//    [self performSegueWithIdentifier:kGoToDialogsSegueIdentifier sender:nil];
//}
//
//#pragma mark - Push Notifications
//
//- (void)registerForRemoteNotifications{
//    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    else{
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
//    }
//#else
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
//#endif
//}

@end
