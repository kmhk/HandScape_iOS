//
//  DataKeeper.m
//  BBXMoney
//
//  Created by Li on 2/3/16.
//  Copyright © 2016 Li. All rights reserved.
//

#import "DataKeeper.h"
#import "Preferences.h"
#import "Define.h"
#import "Constants.h"
DataKeeper *dataKeepInst = nil;
NSDictionary *strDefaultResDict;
@implementation DataKeeper

+ (DataKeeper*) sharedInstance{
    if(dataKeepInst == nil)
        dataKeepInst = [[DataKeeper alloc] init];
    
    return dataKeepInst;
}

- (id) init{
    self = [super init];
    if(self){
        //Init Values
        self.strUUID = @"";
        self.strUserTokenID = @"";
        self.currentQBUser = nil;
        self.curUserPic = nil;
        self.userAry = [[NSMutableArray alloc] init];
        self.dialogAry = [[NSMutableArray alloc] init];
        self.photoDict = [[NSMutableDictionary alloc] init];
        self.curSelIndex = -1;
    }
    return self;
}

//- (void) saveUserToken:(NSString *) token{
//    [Preferences setStoreValue:token forKey:PREF_KEY_USER_TOKEN_ID];
//}
//
//- (BOOL) loadUserToken{
//    self.strUserTokenID = [Preferences getStoredValue:PREF_KEY_USER_TOKEN_ID];
//    if((self.strUserTokenID == nil) || [self.strUserTokenID isEqualToString:@""])
//    {
//        self.strUserTokenID = @"";
//        return FALSE;
//    }
//    return TRUE;
//}
@end
