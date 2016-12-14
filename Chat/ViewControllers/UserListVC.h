//
//  UserListVC.h
//  Chat
//
//  Created by Nikolay Petrovich on 4/12/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface UserListVC : BaseViewController
{
    int pageNumber;
}

@property (weak, nonatomic) IBOutlet UIImageView *              m_ivPicture;
@property (weak, nonatomic) IBOutlet UITableView *              m_tblUsers;

@property (strong, nonatomic) UINavigationController *nav;
@property (weak, nonatomic) QBRTCSession *currentSession;

@property (strong, nonatomic) QBChatDialog *createdDialog;

- (IBAction)onBtnLogout:(id)sender;
@end
