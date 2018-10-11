//
//  PYTestMapController.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/7/28.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYTestMapController.h"
#import "PYMapView.h"
#import "PYAnnotation.h"

@interface PYTestMapController ()
@property (weak, nonatomic) IBOutlet PYMapView *map;
@end

@implementation PYTestMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.map showUserLocation];
    self.map.regionPervalue = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0.025, 0), MKCoordinateSpanMake(.2, .1));
    [self.map setBlockLongTapChanged:^BOOL(PYMapView * _Nonnull map) {
        threadJoinGlobal(^{
            sleep(2);
            threadJoinMain(^{
                
                MKCoordinateRegion region = self.map.region;
                region.span = MKCoordinateSpanMake(0.007, 0.005);
                NSArray * datas = [self.map.annotaions mutableCopy];
                [self.map removeAnnotations:datas];
                PYAnnotation * annotaion = [PYAnnotation annotationWithCoordinate:region.center title:@"我的测试你再干啥" subtitle:@"哈哈在哪里"];
                [self.map addAnnotation:annotaion];
                annotaion = [PYAnnotation annotationWithCoordinate:CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta/2, region.center.longitude - region.span.longitudeDelta/2)];
                [self.map addAnnotation:annotaion];
                annotaion = [PYAnnotation annotationWithCoordinate:CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta/2, region.center.longitude - region.span.longitudeDelta/2)];
                [self.map addAnnotation:annotaion];
                annotaion = [PYAnnotation annotationWithCoordinate:CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta/2, region.center.longitude + region.span.longitudeDelta/2)];
                [self.map addAnnotation:annotaion];
                annotaion = [PYAnnotation annotationWithCoordinate:CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta/2, region.center.longitude + region.span.longitudeDelta/2)];
                [self.map addAnnotation:annotaion];
//                annotaion = [PYAnnotation annotationWithCoordinate:self.map.userLocation.coordinate title:@"我的测试你再干啥我的测我的测试你再干啥我的测我的测试你再干啥我的测" subtitle:@"哈哈在哪里"];
//                [self.map addAnnotation:annotaion];
                
                NSMutableArray * array = [self.map.annotaions mutableCopy];
                for (id<MKAnnotation> annotion in self.map.annotaions) {
                    if([annotion isKindOfClass:[MKUserLocation class]]){
                        [array removeObject:annotion];
                        break;
                    }
                }
                
                [self.map regioinForAnnitaions:array animated:YES];
            });
        });
        
        return YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
