//
//  PYEntityAsist.h
//  PYEntityManager
//
//  Created by wlpiaoyi on 15/10/13.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString * _Nonnull SqlMangerTypeKey;
extern const NSString * _Nonnull SqlMangerTypeName;
extern const NSString * _Nonnull SqlMangerTypeColum;

extern const NSString * _Nonnull PYEntityIvarNameKey;
extern const NSString * _Nonnull PYEntityIvarTypeKey;
extern const NSString * _Nonnull PYEntityIvarAnnotationKey;

extern const NSString * _Nonnull PYEntityIvarTypeInt;
extern const NSString * _Nonnull PYEntityIvarTypeFloat;
extern const NSString * _Nonnull PYEntityIvarTypeString ;
extern const NSString * _Nonnull PYEntityIvarTypeDate;
extern const NSString * _Nonnull PYEntityIvarTypeData;

extern const NSString * _Nonnull PYEntityColumTypeInt;
extern const NSString * _Nonnull PYEntityColumTypeFloat;
extern const NSString * _Nonnull PYEntityColumTypeString ;
extern const NSString * _Nonnull PYEntityColumTypeDate;
extern const NSString * _Nonnull PYEntityColumTypeData;



@protocol PYEntity<NSObject>
@property (nonatomic) NSUInteger keyId;
@optional
+(nullable NSArray<NSString*>*) notColums;
@end



@interface PYEntityAsist : NSObject
/**
 根据规则生成实体代码
 */
+(nonnull NSArray<NSString*>*) createEntityClassDataWithInfos:(nonnull NSArray<NSDictionary*>*) infos className:(nonnull NSString*) className  classAnnotation:(nullable NSString*) classAnnotation;
/**
 获取反射数据
 */
+(nonnull NSArray*) getEntityReflectCache:(nonnull Class<PYEntity>) clazz;
/**
 同步实体
 */
+(nonnull id) synEntity:(nullable NSArray<Class<PYEntity>>*) clazzs dataBaseName:(nonnull NSString*) dataBaseName;

@end
