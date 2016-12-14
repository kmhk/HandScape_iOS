//
//  AppDelegate.h
//  Chat
//
//  Created by Nikolay Petrovich on 4/12/16.
//  Copyright © 2016 handscape.chat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) showWaitView:(NSString *) str;
- (void) showWaitView;
- (void) hideWaitView;
- (void) logoutQuickBox;
@end
#define _gAppDelegate (AppDelegate *)[UIApplication sharedApplication].delegate

