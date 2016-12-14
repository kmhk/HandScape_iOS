//
//  Preferences.h
//  BBXMoney
//
//  Created by Li on 2/21/16.
//  Copyright © 2016 Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject
+ (id)getStoredValue:(NSString*)forKey;
+ (void)setStoreValue:(id)value forKey:(NSString*)key;
+ (id)getUserDictData:(NSString*)forKey;
+ (void)setUserDictData:(id)value forKey:(NSString*)key;
@end
