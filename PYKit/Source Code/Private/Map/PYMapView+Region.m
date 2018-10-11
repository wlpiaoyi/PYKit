//
//  PYMapView+Region.m
//  PYMap
//
//  Created by wlpiaoyi on 2018/7/26.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYMapView+Region.h"
#import "PYAnnotation.h"

@interface PYMapView()<MKMapViewDelegate, UIGestureRecognizerDelegate>

kPNRNA MKMapView * mapView;

-(void) onlyChangeCenterRegion:(MKCoordinateRegion) region;

@end

@implementation PYMapView(Region)


-(void) addLongPressGestureRecognizer{
    UILongPressGestureRecognizer *longpressGesutre=[[UILongPressGestureRecognizer alloc]initWithTarget:nil action:nil];
    longpressGesutre.minimumPressDuration=.5;
    [self.mapView addGestureRecognizer:longpressGesutre];
    longpressGesutre.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(!self.blockLongTapChanged || self.blockLongTapChanged(self)){
        CGPoint point = [gestureRecognizer locationInView:self.mapView];
        MKCoordinateRegion region = self.mapView.region;
        CLLocationCoordinate2D center = region.center;
        CLLocationCoordinate2D offset = CLLocationCoordinate2DMake((point.y / self.mapView.frameHeight - .5) * region.span.latitudeDelta, (point.x / self.mapView.frameWidth - .5) * region.span.longitudeDelta);
        center.latitude -= offset.latitude;
        center.longitude += offset.longitude;
        region.center = center;
        [self setRegion:region animated:YES];
    }
    return YES;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    if(self.blockRegionWillChange) self.blockRegionWillChange(self);
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self onlyChangeCenterRegion:mapView.region];
    if(self.blockRegionDidChange) self.blockRegionDidChange(self);
}

@end
