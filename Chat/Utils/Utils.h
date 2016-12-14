//
//  Utils.h
//  BBXMoney
//
//  Created by Li on 2/3/16.
//  Copyright © 2016 Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DataKeeper.h"
#import "Define.h"
#import "Constants.h"
#import "Preferences.h"

@interface Utils : NSObject

+ (BOOL) isConnectedToNetwork;
+ (BOOL) isNumericString:(NSString *)s;

+ (void) showLoadingView:(NSString *) str;
+ (void) showLoadingView;
+ (void) hideLoadingView;

+ (void) showAlertView:(NSString *) strTitle Message:(NSString *) strMessage;

+ (id) viewContWithStoryId:(NSString *) viewContID;
+ (float) convertXValue:(float) val;
+ (float) convertYValue:(float) val;

+ (void) showToast:(NSString *) str;

+ (void) storeValue:(id) value Key:(NSString *) prefKey;
+ (id) loadValue:(NSString *) prefKey;

+ (NSString *) deviceID;
+ (NSString *) getCurrentTimeString;
+ (NSString *) stringCut:(NSString *) orgStr Length:(int) len;
+ (NSString *) getValueFromDictionary:(NSDictionary *) dict Key:(NSString*) key;
+ (NSURL *) urlFromString:(NSString *) string;

+ (BOOL)checkEmailValidate:(NSString *)emailStr;

+ (UIImage *)fixOrientation:(UIImage *)chkImg;
@end
