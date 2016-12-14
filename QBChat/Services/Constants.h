//
//  Constants.h
//  sample-chat
//
//  Created by Anton Sokolchenko on 5/29/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#ifndef sample_chat_Constants_h
#define sample_chat_Constants_h


/**
 *  UsersService
 */
static NSString *const kTestUsersTableKey = @"test_users";
static NSString *const kUserFullNameKey = @"fullname";
static NSString *const kUserLoginKey = @"login";
static NSString *const kUserPasswordKey = @"password";

static const NSUInteger kApplicationID = 38784;
static NSString *const kAuthKey        = @"w3DfsFbq8bbXyDE";
static NSString *const kAuthSecret     = @"A24qjarBu6aQeaX";
static NSString *const kAccountKey     = @"YyyHJuqeqaHs9EsG6D3M";
/**
 *  UsersDataSource
 */
static NSString *const kUserTableViewCellIdentifier = @"UserTableViewCellIdentifier";
static const NSUInteger kUsersLimit = 100;

/**
 *  ServicesManager
 */
static NSString *const kChatCacheNameKey = @"sample-cache";
static NSString *const kContactListCacheNameKey = @"sample-cache-contacts";
static NSString *const kLastActivityDateKey = @"last_activity_date";

/**
 *  LoginTableViewController
 */
static NSString *const kGoToDialogsSegueIdentifier = @"goToDialogs";

/**
 *  DialogsViewController
 */
static const NSUInteger kDialogsPageLimit = 100;

static NSString *const kGoToEditDialogSegueIdentifier = @"goToEditDialog";

/**
 *  DialogInfoTableViewController
 */
static NSString *const kGoToAddOccupantsSegueIdentifier = @"goToAddOccupants";

/**
 *  EditDialogTableViewController
 */
static NSString *const kGoToChatSegueIdentifier = @"goToChat";

/**
 * Dialog keys
 */
static NSString *const kPushNotificationDialogIdentifierKey = @"dialog_id";
static NSString *const kPushNotificationDialogMessageKey = @"message";

#endif
