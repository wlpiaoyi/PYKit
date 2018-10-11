//
//  PYAnnotationView.h
//  PYMap
//
//  Created by wlpiaoyi on 2018/7/26.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.

//

#import "pyutilea.h"
#import <MapKit/MapKit.h>

@interface PYAnnotationView : MKAnnotationView

@end

@interface PYAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;

+(nullable) annotationWithCoordinate:(CLLocationCoordinate2D) coordinate;
+(nullable) annotationWithCoordinate:(CLLocationCoordinate2D) coordinate
                               title:(nonnull NSString *) title
                            subtitle:(nullable NSString *) subtitle;
@end
