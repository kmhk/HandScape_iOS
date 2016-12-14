//
//  WelcomeVC.m
//  Chat
//
//  Created by Nikolay Petrovich on 4/11/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import "WelcomeVC.h"

@interface WelcomeVC ()

@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _m_btnToLogin.layer.cornerRadius = 4.0;
    _m_btnToLogin.clipsToBounds = YES;
	[_m_btnToLogin setBackgroundColor:[UIColor clearColor]];
	_m_btnToLogin.layer.borderWidth = 1.0;
	_m_btnToLogin.layer.borderColor = [UIColor colorWithRed:0 green:97/255.0 blue:147/255.0 alpha:1.0].CGColor;
	[_m_btnToLogin setTitleColor:[UIColor colorWithRed:0 green:97/255.0 blue:147/255.0 alpha:1.0] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
