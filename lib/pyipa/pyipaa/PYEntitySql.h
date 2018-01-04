//
//  PYEntitySql.h
//  PYEntityManager
//
//  Created by wlpiaoyi on 15/10/12.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYEntityAsist.h"

@protocol PYEntitySql <NSObject>

+(nonnull NSString*) getCreateSql:(nonnull Class<PYEntity>) clazz;
+(nonnull NSString*) getFindSql:(nonnull Class<PYEntity>) clazz;
+(nonnull NSString*) getDeleteSql:(nonnull Class<PYEntity>) clazz;
+(nonnull NSString*) getMergeSql:(nonnull Class<PYEntity>) clazz columns:(nullable NSArray<NSString*>*) columns;
+(nonnull NSString*) getPersistSql:(nonnull Class<PYEntity>) clazz  columns:(nullable NSArray<NSString*>*) columns;
+(nonnull NSString*) getTableStrutSql:(nonnull Class<PYEntity>) clazz;
+(nonnull NSString*) getTableAlertSql:(nonnull Class<PYEntity>) clazz colums:(nonnull NSArray<NSDictionary*>*) colums;
@end

@interface PYEntitySql : NSObject<PYEntitySql>

@end
