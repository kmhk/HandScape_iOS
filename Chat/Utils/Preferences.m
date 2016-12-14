//
//  Preferences.m
//  BBXMoney
//
//  Created by Li on 2/21/16.
//  Copyright © 2016 Li. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences
+(id)getStoredValue:(NSString *)forKey
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:forKey];
}

+(void)setStoreValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (id)getUserDictData:(NSString*)forKey{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data = [def objectForKey:forKey];
    NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
}

+ (void)setUserDictData:(id)value forKey:(NSString*)key{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:key];
    [def synchronize];
}

@end
