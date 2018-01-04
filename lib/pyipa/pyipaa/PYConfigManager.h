//
//  PYConfigManager.h
//  PYEntityManager
//
//  Created by wlpiaoyi on 15/10/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 
 可以存储NSDictionary ,NSArray ,NSString ,NSNumber ,NSData ,NSDate class ,(实体对象)
 */
@interface PYConfigManager : NSObject
+(BOOL) setConfigValue:(id) value Key:(NSString*) key;
+(id) getConfigValue:(NSString*) key;
+(void) removeConfigValue:(NSString*) key;
+(void) removeALL;
@end
