//
//  UIPlaceHolderTextView.h
//  Accountable
//
//  Created by kevin bluhm on 12/25/15.
//  Copyright © 2015 Piaoshizhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
