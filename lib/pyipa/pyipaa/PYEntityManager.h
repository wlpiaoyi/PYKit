//
//  PYEntityManager.h
//  PYEntityManager
//
//  Created by wlpiaoyi on 15/10/12.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYEntityAsist.h"
@protocol PYDataBaseManager<NSObject>
@property (nonatomic, strong, readonly,nonnull) NSString *dbName;
@property (nonatomic,readonly) BOOL hasTransation;
/**
 执行查询操作
 */
-(int) executeQuery:(nonnull NSString*) sql params:(nullable NSArray<id>*) params resultPoniter:(NSMutableArray<NSDictionary*> * _Nullable * _Nullable) resultPointer;
/**
 执行更新操作
 */
-(long) executeUpdate:(nonnull NSString*) sql params:(nullable NSArray<NSString*>*) params;
//==>数据库开关，默认自动执行
-(BOOL) open;
-(BOOL) close;
///<==
//==> 事务管理
-(BOOL) beginTransation;
-(int) commitTarnsation;
- (BOOL)rollbackTarnsation;
///<==
@end

@protocol PYEntityManager<NSObject>
/**
 新增
 */
-(nullable id<PYEntity>) persist:(nonnull id<PYEntity>) entity;
/**
 修改
 */
-(nullable id<PYEntity>) merge:(nonnull id<PYEntity>) entity;
/**
 删除
 */
-(BOOL) remove:(nonnull id<PYEntity>) entity;
//==>查询数据

/**
 查询单个实体
 */
-(nullable id<PYEntity>) find:(NSInteger) keyId entityClass:(nonnull Class<PYEntity>) entityClass;
/**
 查询多个实体
 */
-(nonnull NSArray<id<PYEntity>>*) queryForEntitys:(nullable NSString*) sql params:(nullable NSArray<id>*) params entityClass:(nonnull Class<PYEntity>) entityClass;
/**
 查询多个数据
 */
-(nonnull NSArray<NSDictionary*>*) queryForDictionarys:(nullable NSString*) sql params:(nullable NSArray<id>*) params;
///<==
@end

@interface PYDataBaseManager : NSObject<PYDataBaseManager>
+(nonnull instancetype) enityWithDataBaseName:(nonnull NSString*) dataBaseName;
@end

@interface PYEntityManager : PYDataBaseManager<PYEntityManager>
@end
