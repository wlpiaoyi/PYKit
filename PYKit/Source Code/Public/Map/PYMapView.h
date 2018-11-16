//
//  PYMapView.h
//  PYMap
//
//  Created by wlpiaoyi on 2018/7/24.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"
#import <MapKit/MapKit.h>

extern BOOL PYMAP_IGNORE_ERRO_MESSAGE;
extern NSString * PYMAP_ANNOTATION_IDENTIFY;

@interface PYMapView : UIView
kPNA MKCoordinateRegion regionPervalue;
/**
 当前定位位置信息
 */
kPNRNA MKUserLocation * userLocation;
/**
 当前位置和区域范围
 */
kPNA MKCoordinateRegion region;
/**
 显示范围级别
 */
kPNA NSUInteger zoomLevel;

/**
 所有的标注
 */
kPNSNA NSArray<id<MKAnnotation>> * annotaions;
/**
 选中的标注
 */
kPNSNA NSArray<id<MKAnnotation>> * selectedAnnotations;

/**
 初始化标注试图
 */
kPNCNA MKAnnotationView * (^blocAnnotationView)(id<MKAnnotation> _Nonnull annotation,  NSString * identifier);
/**
 获取标注试图的id,用以支持重复使用
 */
kPNCNA NSString * (^blockDequeueReusable)(id<MKAnnotation> _Nonnull annotation);
/**
 选中、未选中注解
 */
///=======================>
kPNCNA void (^blockSelected)(PYMapView * _Nonnull map, MKAnnotationView * _Nonnull view);
kPNCNA void (^blockDeselected)(PYMapView * _Nonnull map, MKAnnotationView * _Nonnull view);
///<=======================
/**
 缩放回调
 */
kPNCNA void (^blockRegionWillChange)(PYMapView * _Nonnull map);
kPNCNA void (^blockRegionDidChange)(PYMapView * _Nonnull map);
///<=======================
/**
 长按回调
 */
kPNCNA BOOL (^blockLongTapWillChange)(PYMapView * _Nonnull map, MKCoordinateRegion region);
/**
 定位回调
 */
kPNCNA void (^blockUserLocationChanged)(PYMapView * _Nonnull map);

/**
 定位到当前地点
 */
-(void) showUserLocation;

/**
 标注数据控制
 */
///=======================>
-(void) addAnnotation:(id <MKAnnotation>)annotation;
-(void) addAnnotations:(NSArray<id<MKAnnotation>> *)annotations;
-(void) removeAnnotation:(id <MKAnnotation>)annotation;
-(void) removeAnnotations:(NSArray<id<MKAnnotation>> *)annotations;
///<=======================

/**
 通过标注数据缩放位移地图
 */
-(void) regioinForAnnitaions:(nullable NSArray<id<MKAnnotation>> *) annotaitons animated:(BOOL)animated;
-(MKCoordinateRegion) getRegioinWithAnnitaions:(nullable NSArray<id<MKAnnotation>> *) annotaitons;

-(void) setRegion:(MKCoordinateRegion) region animated:(BOOL)animated;
-(void) setZoomLevel:(NSUInteger) zoomLevel animated:(BOOL) animated;
-(void) setZoomLevel:(NSUInteger) zoomLevel centerLocation:(CLLocationCoordinate2D) centerLocation  animated:(BOOL) animated;

@end
