//
//  PYMapView.m
//  PYMap
//
//  Created by wlpiaoyi on 2018/7/24.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYMapView.h"
#import "PYUserLocationView.h"
#import "PYMapView+UserLocation.h"
#import "PYMapView+Annotaions.h"
#import "PYMapView+Region.h"
#import "PYAnnotation.h"

//@interface PYMapView(pymap_temp)
//-(void) initUserLocation;
//-(void) addLongPressGestureRecognizer;
//- (nullable MKAnnotationView *) annotaionsMapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
//@end

BOOL PYMAP_IGNORE_ERRO_MESSAGE = NO;
NSString * PYMAP_ANNOTATION_IDENTIFY = @"ANNOTATION_IDENTIFY";

CGFloat PY_MAP_LEVEL_RADIAN = 0.005;
NSUInteger PY_MAP_LEVEL_INCREMENT = 4;

@interface PYMapView()<MKMapViewDelegate>

kPNRNA MKMapView * mapView;

kPNSNA PYUserLocationView * userLocationView;
kPNSNA PYUserLocationView * locationView;
kPNSNA CLLocationManager * headingManager;

@end

@implementation PYMapView

+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        [PYInterflowParams loadInterflowParamsData];
    });
}

kINITPARAMSForType(PYMapView){
    _regionPervalue = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0, 0), MKCoordinateSpanMake(0, 0));
    _mapView = [MKMapView new];
    [self addSubview:self.mapView];
    [self.mapView setAutotLayotDict:@{@"top":@(0), @"left":@(0), @"bottom":@(0), @"right":@(0)}];
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = false;
    
    UIButton * buttonUserLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonUserLocation addTarget:self action:@selector(showUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [buttonUserLocation setImage:[UIImage imageNamed:@"PYKit.bundle/images/user_location_reset.png"] forState:UIControlStateNormal];
    [self addSubview:buttonUserLocation];
    [buttonUserLocation setAutotLayotDict:@{@"w":@(30), @"h": @(30), @"top":@(10), @"right":@(10), @"topActive":@(YES), @"rightActive":@(YES)}];
    [buttonUserLocation setCornerRadiusAndBorder:15 borderWidth:.5 borderColor:[UIColor grayColor]];
    buttonUserLocation.backgroundColor = [UIColor whiteColor];
    [self addLongPressGestureRecognizer];
    if (@available(iOS 11.0, *)) {
        [self.mapView registerClass:[PYAnnotationView class] forAnnotationViewWithReuseIdentifier:PYMAP_ANNOTATION_IDENTIFY];
    }
    
}
-(MKUserLocation *) userLocation{
    return self.mapView.userLocation;
}

-(NSArray<id<MKAnnotation>> *) annotaions{
    return  self.mapView.annotations;
}

-(void) setAnnotaions:(NSArray<id<MKAnnotation>> *)annotaions{
    [self removeAnnotations:self.annotaions];
    [self addAnnotations:annotaions];
}

-(NSArray<id<MKAnnotation>> *) selectedAnnotations{
    return self.mapView.selectedAnnotations;
}

-(void) setSelectedAnnotations:(NSArray<id<MKAnnotation>> *)selectedAnnotations{
    self.mapView.selectedAnnotations = selectedAnnotations;
}

-(void) showUserLocation{
    if(self.headingManager == nil){
        [self initUserLocation];
        self.mapView.showsUserLocation = true;
        [self.headingManager startUpdatingHeading];
    }else if((self.mapView.userLocation.coordinate.latitude < 180 && self.mapView.userLocation.coordinate.longitude < 180)
             && (self.mapView.userLocation.coordinate.latitude > -180 && self.mapView.userLocation.coordinate.longitude > -180)){
        MKCoordinateRegion region = self.mapView.region;
        region.center = self.mapView.userLocation.coordinate;
        [self setRegion:region animated:YES];
    }
}

- (void)addAnnotation:(id <MKAnnotation>)annotation{
    [self.mapView addAnnotation:annotation];
}
- (void)addAnnotations:(NSArray<id<MKAnnotation>> *)annotations{
    [self.mapView addAnnotations:annotations];
}

- (void)removeAnnotation:(id <MKAnnotation>)annotation{
    [self.mapView removeAnnotation:annotation];
}
- (void)removeAnnotations:(NSArray<id<MKAnnotation>> *)annotations{
    [self.mapView removeAnnotations:annotations];
}
-(MKCoordinateRegion) getRegioinWithAnnitaions:(nullable NSArray<id<MKAnnotation>> *) annotaitons {
    
    void (^blockAnnation)(id<MKAnnotation> annotaiton, CGPoint offset, CLLocationCoordinate2D * minp, CLLocationCoordinate2D * maxp) = ^(id<MKAnnotation> annotaiton, CGPoint offset, CLLocationCoordinate2D * minp, CLLocationCoordinate2D * maxp){
        CLLocationCoordinate2D offsetCoordinate = kCLLocationCoordinate2DInvalid;
        offsetCoordinate.latitude = offset.y / self.mapView.bounds.size.height * self.mapView.region.span.latitudeDelta;
        offsetCoordinate.longitude = offset.x/ self.mapView.bounds.size.width * self.mapView.region.span.latitudeDelta;
        (*maxp).longitude = MAX((annotaiton.coordinate.longitude + offsetCoordinate.longitude), (*maxp).longitude);
        (*minp).longitude = MIN((annotaiton.coordinate.longitude + offsetCoordinate.longitude) , (*minp).longitude);
        (*maxp).latitude = MAX((annotaiton.coordinate.latitude - offsetCoordinate.latitude), (*maxp).latitude);
        (*minp).latitude = MIN((annotaiton.coordinate.latitude - offsetCoordinate.latitude), (*minp).latitude);
    };
    
    MKCoordinateRegion (^blockRegion)(NSArray<id<MKAnnotation>> * annotaitons) = ^MKCoordinateRegion(NSArray<id<MKAnnotation>> *annotaitons) {
        CLLocationCoordinate2D coordinateMin = CLLocationCoordinate2DMake(180, 180);
        CLLocationCoordinate2D coordinateMax = CLLocationCoordinate2DMake(-180, -180);
        for (id<MKAnnotation> annotaiton in annotaitons) {
            blockAnnation(annotaiton, CGPointZero, &coordinateMin, &coordinateMax);
        }
        
        MKCoordinateSpan span = MKCoordinateSpanMake((coordinateMax.latitude - coordinateMin.latitude), (coordinateMax.longitude - coordinateMin.longitude));
        CLLocationCoordinate2D center = kCLLocationCoordinate2DInvalid;
        center.latitude = coordinateMin.latitude + span.latitudeDelta/2;
        center.longitude = coordinateMin.longitude + span.longitudeDelta/2;
        span.latitudeDelta *= 1 + self.regionPervalue.span.longitudeDelta;
        span.longitudeDelta *= 1 + self.regionPervalue.span.latitudeDelta;
        center.latitude += span.latitudeDelta * self.regionPervalue.center.latitude;
        center.longitude += span.longitudeDelta * self.regionPervalue.center.longitude;
        
        return MKCoordinateRegionMake(center, span);
    };
    
    return blockRegion(annotaitons);
    
}
-(void) regioinForAnnitaions:(nullable NSArray<id<MKAnnotation>> *) annotaitons animated:(BOOL)animated{
    void (^blockAnnation)(id<MKAnnotation> annotaiton, CGPoint offset, CLLocationCoordinate2D * minp, CLLocationCoordinate2D * maxp) = ^(id<MKAnnotation> annotaiton, CGPoint offset, CLLocationCoordinate2D * minp, CLLocationCoordinate2D * maxp){
        CLLocationCoordinate2D offsetCoordinate = kCLLocationCoordinate2DInvalid;
        offsetCoordinate.latitude = offset.y / self.mapView.bounds.size.height * self.mapView.region.span.latitudeDelta;
        offsetCoordinate.longitude = offset.x/ self.mapView.bounds.size.width * self.mapView.region.span.latitudeDelta;
        (*maxp).longitude = MAX((annotaiton.coordinate.longitude + offsetCoordinate.longitude), (*maxp).longitude);
        (*minp).longitude = MIN((annotaiton.coordinate.longitude + offsetCoordinate.longitude) , (*minp).longitude);
        (*maxp).latitude = MAX((annotaiton.coordinate.latitude - offsetCoordinate.latitude), (*maxp).latitude);
        (*minp).latitude = MIN((annotaiton.coordinate.latitude - offsetCoordinate.latitude), (*minp).latitude);
    };

    BOOL (^blockRegion)(NSArray<id<MKAnnotation>> * annotaitons, BOOL check) = ^BOOL(NSArray<id<MKAnnotation>> *annotaitons, BOOL check) {
        BOOL result = YES;
        CLLocationCoordinate2D coordinateMin = CLLocationCoordinate2DMake(180, 180);
        CLLocationCoordinate2D coordinateMax = CLLocationCoordinate2DMake(-180, -180);
        for (id<MKAnnotation> annotaiton in annotaitons) {
            MKAnnotationView * annotationView = check ? [self annotaionsMapView:self.mapView viewForAnnotation:annotaiton] : nil;
            if(annotationView){
                CGPoint offset = annotationView.centerOffset;
                CGSize size = annotationView.frameSize;
                CGPoint p1 = CGPointMake(-size.width/2 + offset.x, -size.height/2 + offset.y);
                CGPoint p2 = CGPointMake(size.width/2 + offset.x, -size.height/2 + offset.y);
                CGPoint p3 = CGPointMake(size.width/2 + offset.x, size.height/2 + offset.y);
                CGPoint p4 = CGPointMake(-size.width/2 + offset.x, size.height/2 + offset.y);
                blockAnnation(annotaiton, p1, &coordinateMin, &coordinateMax);
                blockAnnation(annotaiton, p2, &coordinateMin, &coordinateMax);
                blockAnnation(annotaiton, p3, &coordinateMin, &coordinateMax);
                blockAnnation(annotaiton, p4, &coordinateMin, &coordinateMax);
            }else{
                result = NO;
                blockAnnation(annotaiton, CGPointZero, &coordinateMin, &coordinateMax);
            }
        
        }
        
        MKCoordinateSpan span = MKCoordinateSpanMake((coordinateMax.latitude - coordinateMin.latitude), (coordinateMax.longitude - coordinateMin.longitude));
        CLLocationCoordinate2D center = kCLLocationCoordinate2DInvalid;
        center.latitude = coordinateMin.latitude + span.latitudeDelta/2;
        center.longitude = coordinateMin.longitude + span.longitudeDelta/2;
        span.latitudeDelta *= 1 + self.regionPervalue.span.longitudeDelta;
        span.longitudeDelta *= 1 + self.regionPervalue.span.latitudeDelta;
        center.latitude += span.latitudeDelta * self.regionPervalue.center.latitude;
        center.longitude += span.longitudeDelta * self.regionPervalue.center.longitude;
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        [self setRegion:region animated:animated];
        
        return result;
    };
    
    blockRegion(annotaitons, NO);
    
}

-(void) onlyChangeCenterRegion:(MKCoordinateRegion) region{
    _region = region;
    CLLocationDegrees delta = MAX(region.span.latitudeDelta, region.span.longitudeDelta);
    
    NSUInteger level = 0;
    CLLocationDegrees deltaTemp = PY_MAP_LEVEL_RADIAN;
    while (delta > deltaTemp) {
        deltaTemp *= PY_MAP_LEVEL_INCREMENT;
        level++;
    }
    _zoomLevel = level ? : 1;
}

-(void) setRegion:(MKCoordinateRegion) region{
    [self setRegion:region animated:NO];
}

-(void) setRegion:(MKCoordinateRegion)region animated:(BOOL)animated{
    [self.mapView setRegion:region animated:animated];
    threadJoinGlobal(^{
        [NSThread sleepForTimeInterval:animated ? .3 : 0];
        threadJoinMain(^{
            [self onlyChangeCenterRegion:self.mapView.region];
        });
    });
}

-(void) setZoomLevel:(NSUInteger)zoomLevel{
    [self setZoomLevel:zoomLevel animated:NO];
}

-(void) setZoomLevel:(NSUInteger) zoomLevel animated:(BOOL) animated{
    [self setZoomLevel:zoomLevel centerLocation:self.mapView.region.center animated:animated];
    threadJoinGlobal(^{
        [NSThread sleepForTimeInterval:animated ? .3 : 0];
        threadJoinMain(^{
            [self onlyChangeCenterRegion:self.mapView.region];
        });
    });
}

-(void) setZoomLevel:(NSUInteger) zoomLevel centerLocation:(CLLocationCoordinate2D) centerLocation  animated:(BOOL) animated{
    _zoomLevel = zoomLevel;
    CLLocationDegrees tempDegrees = PY_MAP_LEVEL_RADIAN;
    NSUInteger level = zoomLevel;
    while (level != 0) {
        tempDegrees *= PY_MAP_LEVEL_INCREMENT;
        level--;
    }
    
    MKCoordinateRegion region = self.mapView.region;
    region.center = centerLocation;
    CLLocationDegrees v = region.span.latitudeDelta / region.span.longitudeDelta;
    if(region.span.latitudeDelta < region.span.longitudeDelta){
        region.span.latitudeDelta = tempDegrees;
        region.span.longitudeDelta = tempDegrees * v;
    }else{
        CLLocationDegrees v = region.span.longitudeDelta / region.span.latitudeDelta;
        region.span.longitudeDelta = tempDegrees;
        region.span.latitudeDelta = tempDegrees / v;
    }
    [self setRegion:region animated:animated];
}

#pragma MKMapViewDelegate ======>

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKAnnotationView * annotationView = nil;
    if(![annotation isKindOfClass:[MKUserLocation class]]){
        annotationView = [self annotaionsMapView:mapView viewForAnnotation:annotation];
    }
    
    return annotationView;
}
#pragma MKMapViewDelegate <======



@end
