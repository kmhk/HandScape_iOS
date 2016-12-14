//
//  AppDelegate.m
//  Chat
//
//  Created by Nikolay Petrovich on 4/12/16.
//  Copyright © 2016 handscape.chat. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end
const CGFloat kQBRingThickness = 1.f;
const NSTimeInterval kQBAnswerTimeInterval = 60.f;
const NSTimeInterval kQBRTCDisconnectTimeInterval = 30.f;
const NSTimeInterval kQBDialingTimeInterval = 5.f;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [QBSettings setApplicationID:kApplicationID];
    [QBSettings setAuthKey:kAuthKey];
    [QBSettings setAuthSecret:kAuthSecret];
    [QBSettings setAccountKey:kAccountKey];
    [QBSettings setChatDNSLookupCacheEnabled:YES];
    [QBSettings enableXMPPLogging];
    [QBSettings setAutoReconnectEnabled:YES];
    
    [QBSettings setKeepAliveInterval:30];
    
    
    //SVProgressHUD preferences
    [SVProgressHUD setForegroundColor:[UIColor clearColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setRingThickness:kQBRingThickness];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    
//    [QBSettings setLogLevel:QBLogLevelNothing];
    [QBSettings setLogLevel:QBLogLevelDebug];
    [QBSettings setAutoReconnectEnabled:YES];
    //QuickbloxWebRTC preferences
    
    [QBRTCConfig setAnswerTimeInterval:kQBAnswerTimeInterval];
    [QBRTCConfig setDisconnectTimeInterval:kQBRTCDisconnectTimeInterval];
    [QBRTCConfig setDialingTimeInterval:kQBDialingTimeInterval];
    [QBRTCClient initializeRTC];
    
    [((UINavigationController *)self.window.rootViewController) setNavigationBarHidden:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) showWaitView:(NSString *) str{
    [SVProgressHUD showWithStatus:str];
}

- (void) showWaitView{
    [self showWaitView:@""];
}

- (void) hideWaitView{
    [SVProgressHUD dismiss];
}

- (void) logoutQuickBox{
    [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
        NSLog(@"SignOut Success");
        [((UINavigationController *)self.window.rootViewController) popViewControllerAnimated:YES];
    } errorBlock:^(QBResponse *response) {
        NSLog(@"SignOut Failed");
    }];
}

@end
