//
//  PYMapView+UserLocation.m
//  PYMap
//
//  Created by wlpiaoyi on 2018/7/26.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYMapView+UserLocation.h"
#import "PYUserLocationView.h"
#import "pyutilea.h"

static NSString * PYMAP_USER_LOCATION_IDENTIFY = @"PY_USER_LOCATION";

@interface PYMapView()<MKMapViewDelegate, CLLocationManagerDelegate>
kPNRNA MKMapView * mapView;
kPNSNA PYUserLocationView * userLocationView;
kPNSNA CLLocationManager * headingManager;
@end
@implementation PYMapView(UserLocation)

-(void) initUserLocation{
    self.headingManager = [[CLLocationManager alloc] init];
    self.headingManager.delegate = self;
}

#pragma MKMapViewDelegate ======>

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    if (PYMAP_IGNORE_ERRO_MESSAGE) return;
    if(((NSNumber *) [[NSUserDefaults standardUserDefaults] valueForKey:@"PYMAP_IGNORE_ERRO_FLAG"]).boolValue){
        PYMAP_IGNORE_ERRO_MESSAGE = true;
        return;
    }
    NSString * title = error.userInfo[NSLocalizedDescriptionKey];//
    NSString * message = error.userInfo[NSLocalizedRecoverySuggestionErrorKey];//
    title = title.length ? title : @"定位错误提示";
    message = message.length ? message : @"定位出错，可能是您没有打开定位权限!";
    if(title.length && message.length){
        PYMAP_IGNORE_ERRO_MESSAGE = true;
        [[UIView new] dialogShowWithTitle:title message:message block:^(UIView * _Nonnull view, NSUInteger index) {
            [view dialogHidden];
            switch (index) {
                case 0:
                    PYMAP_IGNORE_ERRO_MESSAGE = false;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    [[NSUserDefaults standardUserDefaults] setValue:@(FALSE) forKey:@"PYMAP_IGNORE_ERRO_FLAG"];
                    break;
                case 1:
                    PYMAP_IGNORE_ERRO_MESSAGE = false;
                    break;
                default:
                    PYMAP_IGNORE_ERRO_MESSAGE = true;
                    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"PYMAP_IGNORE_ERRO_FLAG"];
                    break;
            }
        } buttonNames:@[@"去打开定位权限",@"下次提醒",@"不再提醒"]];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    Class clazz = NSClassFromString(@"MKModernUserLocationView");
    for (MKAnnotationView * view in views) {
        if([view isKindOfClass:clazz]){
            view.enabled = NO;
            if(self.userLocationView == nil){
                self.userLocationView = [PYUserLocationView new];
                [self setZoomLevel:0 centerLocation:mapView.userLocation.coordinate animated:YES];
            }
            if(![view.subviews containsObject:self.userLocationView]){
                [view addSubview:self.userLocationView];
                [PYViewAutolayoutCenter persistConstraint:self.userLocationView relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
            }
            if(self.blockUserLocationChanged){
                self.blockUserLocationChanged(self);
            }
            break;
        }
    }
}

#pragma MKMapViewDelegate <======

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    if(self.userLocationView){
        self.userLocationView.magneticHeading = newHeading.magneticHeading;
    }
}

@end
