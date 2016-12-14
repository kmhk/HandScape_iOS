//
//  Define.h
//  Chat
//
//  Created by Nikolay Petrovich on 4/11/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#ifndef Define_h
#define Define_h

/********** Color **********/

#define RGB_COLOR(r, g, b, a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]);
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/********** Device Info **********/
#define kDevice_Width           ([UIScreen mainScreen].bounds.size.width)
#define kDevice_Height          ([UIScreen mainScreen].bounds.size.height)

#define is_IPad					(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define is_Phone4				(kDevice_Height == 480)


/********** DataKeeper Instance **********/
#define _gDKeeper               ([DataKeeper sharedInstance])

/********** Push/Pop ViewController **********/
#define PUSH_VIEWCONT(a)        [self.navigationController pushViewController:[Utils viewContWithStoryId:a] animated:NO]
#define POP_VIEWCONT            [((UIViewController *)[self.navigationController.viewControllers lastObject]).view setFrame:CGRectMake(0, 0, ((UIViewController *)[self.navigationController.viewControllers lastObject]).view.frame.size.width, ((UIViewController *)[self.navigationController.viewControllers lastObject]).view.frame.size.height)]; [self.navigationController popViewControllerAnimated:YES]

/********** Convert To String **********/
#define STR(a)                  [NSString stringWithFormat:@"%d", a]
#define STR_L(a)                  [NSString stringWithFormat:@"%ld", a]
#define STR_F(a)                [NSString stringWithFormat:@"%.2f", a]
#define STR_BOOL(a)             a ? @"true":@"false"

#endif /* Define_h */
