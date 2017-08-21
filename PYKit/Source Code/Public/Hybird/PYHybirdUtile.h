//
//  PYHybirdUtile.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/9/7.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYHybirdUtile : NSObject
/**
 将实体转换层Js对象
 */
+(nonnull NSString *) parseInstanceToJsObject:(nonnull NSObject *) instance name:(nullable NSString *) name;
/**
执行来自JS对象的方法
 */
+(nonnull NSDictionary *) invokeInstanceFromJs:(nonnull NSDictionary *) jsDict interfaceDict:(nonnull NSDictionary *) interfaceDict;
@end
