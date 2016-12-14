//
//  UserListVC.m
//  Chat
//
//  Created by Nikolay Petrovich on 4/12/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import "UserListVC.h"
#import "CallViewController.h"
#import "ChatManager.h"
#import "CheckUserTableViewCell.h"
#import "IncomingCallViewController.h"
#import "QMSoundManager.h"
#import "SVProgressHUD.h"
#import "UsersDataSource.h"
#import "ServicesManager.h"
#import "Utils.h"
#import "UserTableCell.h"
#import "ChatViewController.h"

#define UserTabelPageSize (100)

@interface UserListVC ()
<UITableViewDataSource, UITableViewDelegate, QBRTCClientDelegate, IncomingCallViewControllerDelegate, QMChatServiceDelegate,
QMAuthServiceDelegate,
QMChatConnectionDelegate>
{
    BOOL isFirstTime;
}

@property (nonatomic, strong) id <NSObject> observerDidBecomeActive;

@end

@implementation UserListVC

- (void) viewDidLoad{
    [super viewDidLoad];
    pageNumber = 0;
    isFirstTime = TRUE;
    [_m_tblUsers setDataSource:self];
    [_m_tblUsers setDelegate:self];
    [_m_ivPicture setImage:[UIImage imageNamed:@"placeholder_regular.png"]];
    _m_ivPicture.layer.cornerRadius = _m_ivPicture.frame.size.width / 2;
    _m_ivPicture.clipsToBounds = YES;
    _m_ivPicture.contentMode = UIViewContentModeScaleAspectFill;
    _m_ivPicture.layer.borderWidth = 1.0;
    _m_ivPicture.layer.borderColor = [UIColor colorWithRed:0 green:97/255.0 blue:147.0/255.0 alpha:1.0].CGColor;
    
    self.users = UsersDataSource.instance.usersWithoutMe;
    [QBRTCClient.instance addDelegate:self];
    
    if(![_gDKeeper.photoDict objectForKey:STR_L(_gDKeeper.currentQBUser.blobID)])
        [self downloadUserPic:_gDKeeper.currentQBUser];
    else{
        _gDKeeper.curUserPic = [_gDKeeper.photoDict objectForKey:STR_L(_gDKeeper.currentQBUser.blobID)];
        [_m_ivPicture setImage:_gDKeeper.curUserPic];
    }
    
    [ServicesManager.instance.chatService addDelegate:self];
    self.observerDidBecomeActive = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                                                     object:nil queue:[NSOperationQueue mainQueue]
                                                                                 usingBlock:^(NSNotification *note) {
                                                                                     if (![[QBChat instance] isConnected]) {
                                                                                         [SVProgressHUD showWithStatus:@"Connecting..." maskType:SVProgressHUDMaskTypeClear];
                                                                                     }
                                                                                 }];
    
    if ([QBChat instance].isConnected) {
        [self getChatDailogs];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(isFirstTime)
    {
        isFirstTime = FALSE;
        return;
    }
    [self getUserList];
}

- (void) getUserList{
    [Utils showLoadingView:@"Updating User Info..."];
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
        
        [_m_tblUsers reloadData];
        NSLog(@"Response: %@", response);
        NSLog(@"Page: %@", page);
        NSLog(@"%@", users);
        [Utils hideLoadingView];
        
    } errorBlock:^(QBResponse *response) {
        NSLog(@"error: %@", response.error);
        [Utils hideLoadingView];
    }];
}

//- (void) getChatDailogs{
//    [Utils showLoadingView:@"Get Dialogs"];
//    QBResponsePage *page = [QBResponsePage responsePageWithLimit:100 skip:0];
//    [QBRequest dialogsForPage:page extendedRequest:nil successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
//        [Utils hideLoadingView];
//        _gDKeeper.dialogAry = [dialogObjects mutableCopy];
//        NSLog(@"Response:%@", dialogObjects);
//    } errorBlock:^(QBResponse *response) {
//        [Utils hideLoadingView];
//        NSLog(@"Get Dialog Error");
//    }];
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void)getChatDailogs
{
    __weak __typeof(self) weakSelf = self;
    if ([ServicesManager instance].lastActivityDate != nil) {
        [[ServicesManager instance].chatService fetchDialogsUpdatedFromDate:[ServicesManager instance].lastActivityDate andPageLimit:kDialogsPageLimit iterationBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, BOOL *stop) {
            //
            __typeof(weakSelf) strongSelf = weakSelf;
            _gDKeeper.dialogAry = [dialogObjects mutableCopy];
//            [strongSelf.tableView reloadData];
        } completionBlock:^(QBResponse *response) {
            //
            if ([ServicesManager instance].isAuthorized && response.success) {
                [ServicesManager instance].lastActivityDate = [NSDate date];
            }
        }];
    }
    else {
        [SVProgressHUD showWithStatus:@"Loading Dialogs..." maskType:SVProgressHUDMaskTypeClear];
        [[ServicesManager instance].chatService allDialogsWithPageLimit:kDialogsPageLimit extendedRequest:nil iterationBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, BOOL *stop) {
//            __typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf.tableView reloadData];
            _gDKeeper.dialogAry = [dialogObjects mutableCopy];
        } completion:^(QBResponse *response) {
            if ([ServicesManager instance].isAuthorized) {
                if (response.success) {
                    [SVProgressHUD showSuccessWithStatus:@"Loading Finished!"];
                    [ServicesManager instance].lastActivityDate = [NSDate date];
                    
                    [self downloadOthersProfilePhoto];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"Can not load dialogs."];
                }
            }
        }];
    }
}

- (NSArray *)dialogs
{
    // Retrieving dialogs sorted by updatedAt date from memory storage.
    return [ServicesManager.instance.chatService.dialogsMemoryStorage dialogsSortByUpdatedAtWithAscending:NO];
}

- (void) downloadOthersProfilePhoto{
    for (int i = 0; i < [_gDKeeper.userAry count]; i++) {
        QBUUser *user = [_gDKeeper.userAry objectAtIndex:i];
        if (![_gDKeeper.photoDict objectForKey:STR_L(user.blobID)]) {
            [NSThread detachNewThreadSelector:@selector(downloadUserPic:) toTarget:self withObject:user];
        }        
    }
}

- (void) downloadUserPic:(QBUUser *) user{
    NSUInteger userProfilePictureID = user.blobID;
    if(user == _gDKeeper.currentQBUser)
        [Utils showLoadingView];
    
    [QBRequest downloadFileWithID:userProfilePictureID successBlock:^(QBResponse * _Nonnull response, NSData * _Nonnull fileData) {
        UIImage *tmpImg = [UIImage imageWithData:fileData];
        if(user.ID == _gDKeeper.currentQBUser.ID)
        {
            _gDKeeper.curUserPic = [UIImage imageWithData:fileData];
            [_m_ivPicture setImage:_gDKeeper.curUserPic];
        }
        
        [_gDKeeper.photoDict setObject:tmpImg  forKey:STR_L(userProfilePictureID)];
        [_m_tblUsers reloadData];
    } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
        [Utils hideLoadingView];
        NSLog(@"%@", status);
    } errorBlock:^(QBResponse * _Nonnull response) {
        [Utils hideLoadingView];
        NSLog(@"Error:%@", response);
    }];
}

- (IBAction)onBtnLogout:(id)sender{
    [_gAppDelegate logoutQuickBox];
}

- (void) onBtnCallType:(id) sender{
    int cellIndex = (int)([sender tag] / 2);
    _gDKeeper.curSelIndex = cellIndex;
    if([sender tag] % 2 == 0)
    {
        NSArray *callerID = @[[_gDKeeper.userAry objectAtIndex:cellIndex]];
        [self callWithConferenceType:QBRTCConferenceTypeAudio CallerIDs:[UsersDataSource.instance idsWithUsers:callerID]];
    }
    else
    {
        if ([QBChat instance].isConnected) {
            [self selectChatDialog:[_gDKeeper.userAry objectAtIndex:cellIndex]];
//            [self loadDialogs];
        }
        
    }
    
}

- (void) selectChatDialog:(QBUUser *) user{
    QBChatDialog *chatDiag = nil;

    if([[self dialogs] count] != 0)
    {
        for (QBChatDialog *dialog in [self dialogs]) {
            if([[dialog.occupantIDs objectAtIndex:0] isEqualToNumber:[NSNumber numberWithLong:user.ID]] || [[dialog.occupantIDs objectAtIndex:1] isEqualToNumber:[NSNumber numberWithLong:user.ID]])
            {
                chatDiag = dialog;
                break;
            }
        }
    }
    
    if(chatDiag == nil){
        [self createChatDialog:user];
    }
    else{
        [self moveToChatDialog:chatDiag];
    }
}

- (void) moveToChatDialog:(QBChatDialog *) chatDialog{
    ChatViewController* chatViewController = [Utils viewContWithStoryId:@"ChatViewController"];
    chatViewController.dialog = chatDialog;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (BOOL) isUsersStateOnline:(QBUUser *) user{
    NSInteger currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSInteger userLastRequestAtTimeInterval   = [[user lastRequestAt] timeIntervalSince1970];
    
    // if user didn't do anything last 1 minute (60 seconds)
    if((currentTimeInterval - userLastRequestAtTimeInterval) > 60){
        // user is offline now
        return FALSE;
    }
    return TRUE;
}

- (void) createChatDialog:(QBUUser *) user{
    [Utils showLoadingView:@"Create ChatDialog"];
//    QBChatDialog *chatDialog = [[QBChatDialog alloc] initWithDialogID:nil type:QBChatDialogTypeGroup];
//    chatDialog.name = [NSString stringWithFormat:@"Chat with %@", user.fullName];
//    chatDialog.occupantIDs = @[@(user.ID)];
//    
//    [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
//        NSLog(@"Create Chat Dialog Success");
//        [Utils hideLoadingView];
//        [self sendCreatDialogNotification:createdDialog];
//    } errorBlock:^(QBResponse *response) {
//        NSLog(@"Create Chat Dialog Failed");
//        [Utils hideLoadingView];
//    }];
    
    [ServicesManager.instance.chatService createGroupChatDialogWithName:@"Chat" photo:nil occupants:@[user] completion:^(QBResponse *response, QBChatDialog *createdDialog) {
        if (response.success) {
            // Notifying users about created dialog.
            [[ServicesManager instance].chatService sendSystemMessageAboutAddingToDialog:createdDialog toUsersIDs:createdDialog.occupantIDs completion:^(NSError *error) {
                [Utils hideLoadingView];
                [self moveToChatDialog:createdDialog];
            }];
        } else {
            [Utils hideLoadingView];
            [Utils showToast:@"Failed to create chat room."];
        }
    }];
}

- (void) sendCreatDialogNotification:(QBChatDialog *) dialog{
    for (NSString *occupantID in dialog.occupantIDs) {
        
        QBChatMessage *inviteMessage = [self createChatNotificationForGroupChatCreation:dialog];
        
        NSTimeInterval timestamp = (unsigned long)[[NSDate date] timeIntervalSince1970];

        [inviteMessage.customParameters setObject:[NSString stringWithFormat:@"%@", @(timestamp)] forKey:@"date_sent"];
        // send notification
        //
        inviteMessage.recipientID = [occupantID integerValue];
        [Utils showLoadingView:@"SendSystemMessage"];

        [[QBChat instance] sendSystemMessage:inviteMessage completion:^(NSError * _Nullable error) {
            [Utils hideLoadingView];
            if (!error) {
                
            }
            NSLog(@"SendSystemMessage Failed!");
        }];
    }
}

- (QBChatMessage *)createChatNotificationForGroupChatCreation:(QBChatDialog *)dialog
{
    // create message:
    QBChatMessage *inviteMessage = [QBChatMessage message];
    
    NSMutableDictionary *customParams = [NSMutableDictionary new];
    customParams[@"xmpp_room_jid"] = dialog.roomJID;
    customParams[@"name"] = dialog.name;
    customParams[@"_id"] = dialog.ID;
    customParams[@"type"] = @(dialog.type);
    customParams[@"occupants_ids"] = [dialog.occupantIDs componentsJoinedByString:@","];
    
    // Add notification_type=1 to extra params when you created a group chat
    //
    customParams[@"notification_type"] = @"1";
    
    inviteMessage.customParameters = customParams;
    
    return inviteMessage;
}

- (void)callWithConferenceType:(QBRTCConferenceType)conferenceType CallerIDs:(NSArray *) callerAry{
    
    if (true) {
        
        NSParameterAssert(!self.currentSession);
        NSParameterAssert(!self.nav);
        
        NSArray *opponentsIDs = callerAry;
        //Create new session
        QBRTCSession *session = [QBRTCClient.instance createNewSessionWithOpponents:opponentsIDs withConferenceType:conferenceType];
        
        if (session) {
            
            self.currentSession = session;
            CallViewController *callViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CallViewController"];
            callViewController.session = self.currentSession;
            
            self.nav = [[UINavigationController alloc] initWithRootViewController:callViewController];
            self.nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:self.nav animated:NO completion:nil];
        }
        else {
            
            [SVProgressHUD showErrorWithStatus:@"You should login to use chat API. Session hasn’t been created. Please try to relogin the chat."];
        }
    }
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 0;
    
    if(tableView == _m_tblUsers){
        numberOfRowsInSection = [_gDKeeper.userAry count];
    }
    
    return numberOfRowsInSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([QBChat instance].isConnected) {
        [self selectChatDialog:[_gDKeeper.userAry objectAtIndex:indexPath.row]];
        //            [self loadDialogs];
    }
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if(tableView == _m_tblUsers)
    {
        static NSString *CellIdentifier = @"UserTableCell";
        UserTableCell *userCell = (UserTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!userCell)
        {
            userCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
     
        QBUUser *user = [_gDKeeper.userAry objectAtIndex:indexPath.row];
        userCell.m_lblName.text = user.fullName;
		userCell.m_lblEmail.text = ((user.email.length > 0)? user.email: @"No email");
        
        if([_gDKeeper.photoDict objectForKey:STR_L(user.blobID)])
            [userCell.m_ivPic setImage:[_gDKeeper.photoDict objectForKey:STR_L(user.blobID)]];
        else
            [userCell.m_ivPic setImage:[UIImage imageNamed:@"placeholder_regular.png"]];
        
        CGRect rt = userCell.m_ivPic.frame;
        userCell.m_ivPic.layer.cornerRadius = userCell.m_ivPic.frame.size.width / 2;
        userCell.m_ivPic.clipsToBounds = YES;
        userCell.m_ivPic.contentMode = UIViewContentModeScaleAspectFill;
        userCell.m_ivPic.layer.borderWidth = 1.0;
        userCell.m_ivPic.layer.borderColor = [UIColor colorWithRed:0 green:97/255.0 blue:147.0/255.0 alpha:1.0].CGColor;
        userCell.m_ivPic.frame = rt;
        
        BOOL isUserOnline = [self isUsersStateOnline:user];
        if(isUserOnline){
            [userCell.m_ivState setImage:[UIImage imageNamed:@"online.png"]];
        }
        else{
            [userCell.m_ivState setImage:[UIImage imageNamed:@"offline.png"]];
        }
        
        [userCell.m_btnCall setTag:indexPath.row * 2];
        [userCell.m_btnMsg setTag:indexPath.row * 2 + 1];
        [userCell.m_btnCall addTarget:self action:@selector(onBtnCallType:) forControlEvents:UIControlEventTouchUpInside];
        [userCell.m_btnMsg addTarget:self action:@selector(onBtnCallType:) forControlEvents:UIControlEventTouchUpInside];
        
        cell = userCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


#pragma mark - QBWebRTCChatDelegate

- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    
    if (self.currentSession) {
        
        [session rejectCall:@{@"reject" : @"busy"}];
        return;
    }
    
    self.currentSession = session;
    
    [QBRTCSoundRouter.instance initialize];
    
    NSParameterAssert(!self.nav);
    
    IncomingCallViewController *incomingViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"IncomingCallViewController"];
    incomingViewController.delegate = self;
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:incomingViewController];
    
    incomingViewController.session = session;
    
    [self presentViewController:self.nav animated:NO completion:nil];
}

- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.currentSession ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.nav.view.userInteractionEnabled = NO;
            [self.nav dismissViewControllerAnimated:NO completion:nil];
            self.currentSession = nil;
            self.nav = nil;
        });
    }
}

- (void)incomingCallViewController:(IncomingCallViewController *)vc didAcceptSession:(QBRTCSession *)session {
    
    CallViewController *callViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"CallViewController"];
    
    callViewController.session = session;
    self.nav.viewControllers = @[callViewController];
}

- (void)incomingCallViewController:(IncomingCallViewController *)vc didRejectSession:(QBRTCSession *)session {
    
    [session rejectCall:nil];
    [self.nav dismissViewControllerAnimated:NO completion:nil];
    self.nav = nil;
}

#pragma mark -
#pragma mark Chat Service Delegate

- (void)chatService:(QMChatService *)chatService didAddChatDialogsToMemoryStorage:(NSArray *)chatDialogs {
    
    _gDKeeper.dialogAry = [chatDialogs mutableCopy];
}

- (void)chatService:(QMChatService *)chatService didAddChatDialogToMemoryStorage:(QBChatDialog *)chatDialog {
    [_gDKeeper.dialogAry addObject:chatDialog];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog *)chatDialog {
    NSMutableArray *tmpAry = [_gDKeeper.dialogAry mutableCopy];
    [_gDKeeper.dialogAry removeAllObjects];
    for (QBChatDialog *dialog in tmpAry) {
        if([dialog.ID isEqualToString:chatDialog.ID])
        {
            [_gDKeeper.dialogAry addObject:chatDialog];
        }
        else
        {
            [_gDKeeper.dialogAry addObject:dialog];
        }
    }
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogsInMemoryStorage:(NSArray *)dialogs {
    NSMutableArray *tmpAry = [_gDKeeper.dialogAry mutableCopy];
    [_gDKeeper.dialogAry removeAllObjects];
    for (QBChatDialog *dialog in tmpAry) {
        BOOL isUpdated = FALSE;
        QBChatDialog *updateTmp = nil;
        for (QBChatDialog *updateDiag in dialogs) {
            if([dialog.ID isEqualToString:updateDiag.ID])
            {
                isUpdated = TRUE;
                updateTmp = updateDiag;
                break;
            }
        }
        if(isUpdated)
        {
            [_gDKeeper.dialogAry addObject:updateTmp];
        }
        else
        {
            [_gDKeeper.dialogAry addObject:dialog];
        }
    }
}

- (void)chatService:(QMChatService *)chatService didReceiveNotificationMessage:(QBChatMessage *)message createDialog:(QBChatDialog *)dialog {
    [self.m_tblUsers reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddMessageToMemoryStorage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
    [self.m_tblUsers reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddMessagesToMemoryStorage:(NSArray *)messages forDialogID:(NSString *)dialogID {
    [self.m_tblUsers reloadData];
}

- (void)chatService:(QMChatService *)chatService didDeleteChatDialogWithIDFromMemoryStorage:(NSString *)chatDialogID {
    [self.m_tblUsers reloadData];
}

#pragma mark - QMChatConnectionDelegate

- (void)chatServiceChatDidConnect:(QMChatService *)chatService
{
    [SVProgressHUD showSuccessWithStatus:@"Connected" maskType:SVProgressHUDMaskTypeClear];
    [self getChatDailogs];
}

- (void)chatServiceChatDidReconnect:(QMChatService *)chatService
{
    [SVProgressHUD showSuccessWithStatus:@"Reconnected" maskType:SVProgressHUDMaskTypeClear];
    [self getChatDailogs];
}

- (void)chatServiceChatDidAccidentallyDisconnect:(QMChatService *)chatService
{
    [SVProgressHUD showErrorWithStatus:@"Disconnected"];
}

- (void)chatService:(QMChatService *)chatService chatDidNotConnectWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ %@", @"Connection Error:", [error description]]];
}

- (void)chatServiceChatDidFailWithStreamError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ %@", @"Connection Failed Erro:", [error description]]];
}
@end
