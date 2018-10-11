//
//  PYMapView+Annotaions.h
//  PYMap
//
//  Created by wlpiaoyi on 2018/7/26.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYMapView.h"

@interface PYMapView(Annotaions)

- (nullable MKAnnotationView *) annotaionsMapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;

@end
