//
//  SettingVC.m
//  Chat
//
//  Created by Nikolay Petrovich on 4/12/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import "SettingVC.h"
#import "Utils.h"
@implementation SettingVC

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (IBAction)onBtnLogout:(id)sender{
    [_gAppDelegate logoutQuickBox];
}

@end
