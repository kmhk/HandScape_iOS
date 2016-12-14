//
//  ViewController.m
//  Chat
//
//  Created by Nikolay Petrovich on 4/11/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import "SplashVC.h"
#import "Utils.h"
@interface SplashVC ()

@end

@implementation SplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self performSelector:@selector(movetToNextViewCont) withObject:nil afterDelay:2.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) movetToNextViewCont{
    PUSH_VIEWCONT(@"WelcomeVC");
}
@end
