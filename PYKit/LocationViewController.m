//
//  LocationViewController.m
//  PYKit
//
//  Created by wlpiaoyi on 2021/3/25.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "pyutilea.h"

@interface LocationViewController ()

@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation LocationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocationUpdate];
    self.textView = [UITextView new];
    [self.view addSubview:self.textView];
    [self.textView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.py_constant(100);
        make.left.bottom.right.py_constant(0);
    }];
}

- (void)setupLocationUpdate
{
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager  requestWhenInUseAuthorization];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}

# pragma mark -
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation* location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    double latitude = coordinate.latitude;
    double longtitude = coordinate.longitude;
    double altitude = location.altitude;
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYMMdd HH:mm:ss.S"];
    NSString* time = [dateFormatter stringFromDate:location.timestamp];
    NSString* textString = [NSString stringWithFormat:
                            @"time       : %@\n"
                            @"latitude   : %.15f\n"
                            @"longtitude : %.15f\n"
                            @"altitude   : %.10f\n"
                            @"horizontalA: %.5fm\n"
                            @"verticalA  : %.5fm\n",
                            time,
                            latitude,
                            longtitude,
                            altitude,
                            location.horizontalAccuracy,
                            location.verticalAccuracy
                            ];
    NSLog(@"<wpt lat=\"%f\" lon=\"%f\"></wpt>",
          latitude,
          longtitude);
    self.textView.text = textString;
    
}
@end
