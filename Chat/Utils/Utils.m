//
//  Utils.m
//  BBXMoney
//
//  Created by Li on 2/3/16.
//  Copyright © 2016 Li. All rights reserved.
//

#import "Utils.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
#import "AppDelegate.h"
#import "Define.h"
#import "SMHAlertController.h"
#import "iToast.h"

@implementation Utils

+ (BOOL) isConnectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    // synchronous model
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags\n");
        return 0;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    //return (isReachable && !needsConnection) ? YES : NO;
    //BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    
    return (isReachable && !needsConnection);
}

+ (void) showLoadingView:(NSString *) str{
    [_gAppDelegate showWaitView:str];
}

+ (void) showLoadingView{
    [_gAppDelegate showWaitView:@"Please wait..."];
}

+ (void) hideLoadingView{
    [_gAppDelegate hideWaitView];
}

+ (id) viewContWithStoryId:(NSString *) viewContID{
    UIStoryboard *storyboard;
    NSString *storyNibName = @"Main";
//    if (is_Phone4) {
//        storyNibName = [storyNibName stringByAppendingString:@"_Phone4"];
//    }
    storyboard = [UIStoryboard storyboardWithName:storyNibName bundle:nil];
    id viewCont = [[UIViewController alloc] init];
    viewCont = [storyboard instantiateViewControllerWithIdentifier:viewContID];
    return viewCont;
}

+ (float) convertXValue:(float) val{
    return val / 320.0 * kDevice_Width;
}

+ (float) convertYValue:(float) val{
    if(is_Phone4)
        return val;
    return val / 568.0 * kDevice_Height;
}

+ (NSString *) deviceID{
    if([_gDKeeper.strUUID isEqualToString:@""])
    {
        if(TARGET_IPHONE_SIMULATOR)
            _gDKeeper.strUUID = @"SIMULATOR_UUID";
        else
            _gDKeeper.strUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSLog(@"output is : %@", _gDKeeper.strUUID);
    }
    return _gDKeeper.strUUID;
}

+(BOOL) isNumericString:(NSString *)s
{
    NSUInteger len = [s length];
    NSUInteger i;
    BOOL status = NO;
    
    for(i=0; i < len; i++)
    {
        unichar singlechar = [s characterAtIndex: i];
        if ( (singlechar == ' ') && (!status) )
        {
            continue;
        }
        if ( ( singlechar == '+' ||
              singlechar == '-' ) && (!status) ) { status=YES; continue; }
        if ( ( singlechar >= '0' ) &&
            ( singlechar <= '9' ) )
        {
            status = YES;
        } else {
            return NO;
        }
    }
    return (i == len) && status;
}

+ (void) showToast:(NSString *) str{
    iToastSettings *theSettings = [iToastSettings getSharedSettings];
    theSettings.duration = 4000;
    theSettings.gravity = iToastGravityBottom;
    [[iToast makeText:str] show];
}

+ (NSString *) getValueFromDictionary:(NSDictionary *) dict Key:(NSString*) key{
    if(![dict isKindOfClass:[NSDictionary class]])
        return @"";
    id obj = [dict objectForKey:key];
    if([obj isKindOfClass:[NSNull class]])
        return @"";
    return obj;
}

+ (NSString *) stringCut:(NSString *) orgStr Length:(int) len{
    if([orgStr isKindOfClass:[NSString class]])
    {
        if([orgStr length] <= len)
            return orgStr;
        else
            return [orgStr substringToIndex:len];
        }
    else
        return @"";
}

+ (NSURL *) urlFromString:(NSString *) string{
    NSURL *imgURL = [NSURL URLWithString:string];
    
    if(imgURL == nil){
        NSString* encodedText = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        imgURL = [NSURL URLWithString:encodedText];
    }
    return imgURL;
}

+ (NSString *) getCurrentTimeString{
    NSDate* currentDate = [NSDate date];
    return [currentDate.description substringToIndex:10];
}

+ (void) showAlertView:(NSString *) strTitle Message:(NSString *) strMessage{
    SMHAlertController *alertController = [SMHAlertController alertControllerWithTitle:strTitle message:strMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [alertController show];
}

+ (BOOL)checkEmailValidate:(NSString *)emailStr
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

+ (void) storeValue:(id) value Key:(NSString *) prefKey{
    [Preferences setStoreValue:value forKey:prefKey];
}

+ (id) loadValue:(NSString *) prefKey{
    return [Preferences getStoredValue:prefKey];
}

+ (UIImage *)fixOrientation:(UIImage *)chkImg {
    
    if (chkImg.imageOrientation == UIImageOrientationUp)
        return chkImg;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    
    switch (chkImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, chkImg.size.width, chkImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, chkImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, chkImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (chkImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, chkImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, chkImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, chkImg.size.width, chkImg.size.height,
                                             CGImageGetBitsPerComponent(chkImg.CGImage), 0,
                                             CGImageGetColorSpace(chkImg.CGImage),
                                             CGImageGetBitmapInfo(chkImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (chkImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,chkImg.size.height,chkImg.size.width), chkImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,chkImg.size.width,chkImg.size.height), chkImg.CGImage);
            break;
    }
    
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
