//
//  PYMapView+Annotaions.m
//  PYMap
//
//  Created by wlpiaoyi on 2018/7/26.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYMapView+Annotaions.h"
#import "PYUserLocationView.h"
#import "PYAnnotation.h"
@interface PYMapView()<MKMapViewDelegate>

kPNRNA MKMapView * mapView;

@end

@implementation PYMapView(Annotaions)


#pragma MKMapViewDelegate ======>

- (nullable MKAnnotationView *) annotaionsMapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    NSString * identify = self.blockDequeueReusable ? self.blockDequeueReusable(annotation) : nil;
    MKAnnotationView * annotationView = nil;
    if(identify.length || (!identify.length && (identify = PYMAP_ANNOTATION_IDENTIFY))){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identify];
    }
    if(!annotationView){
        annotationView = self.blocAnnotationView ? self.blocAnnotationView(annotation, identify) : nil;
    }
    if(!annotationView){
        annotationView = [[PYAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identify];
    }else{
        annotationView.annotation = annotation;
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if([view.annotation isKindOfClass:[MKUserLocation class]]){
        [self.mapView deselectAnnotation:view.annotation animated:NO];
        return;
    }
    if(self.blockSelected)self.blockSelected(self, view);
    [view setShadowColor:[UIColor redColor].CGColor shadowRadius:4];
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    if([view.annotation isKindOfClass:[MKUserLocation class]]){
        return;
    }
    [view setShadowColor:[UIColor clearColor].CGColor shadowRadius:0];
    if(self.blockDeselected)self.blockDeselected(self, view);
    
}

#pragma MKMapViewDelegate <======

@end
