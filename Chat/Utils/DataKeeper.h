//
//  DataKeeper.h
//  BBXMoney
//
//  Created by Li on 2/3/16.
//  Copyright © 2016 Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>
@interface DataKeeper : NSObject

@property (nonatomic, retain) NSString *                            strUUID;
@property (nonatomic, retain) NSString *                            strUserTokenID;

@property (nonatomic, retain) QBUUser *                             currentQBUser;
@property (nonatomic, retain) UIImage *                             curUserPic;

@property (nonatomic, retain) NSMutableArray *                      userAry;
@property (nonatomic, retain) NSMutableArray *                      dialogAry;
@property (nonatomic, retain) NSMutableDictionary *                 photoDict;
@property (readwrite) int                                           curSelIndex;
+ (DataKeeper*) sharedInstance;

//- (void) saveUserToken:(NSString *) token;
//- (BOOL) loadUserToken;
@end
