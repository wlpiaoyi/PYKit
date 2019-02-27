//
//  PYAnnotationView.m
//  PYMap
//
//  Created by wlpiaoyi on 2018/7/26.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYAnnotation.h"

UIColor * PY_COLOR_ANNOTAION_MESSAGE_LINE;

@implementation PYAnnotationView{
@private
    UILabel * labelMessage;
    UIView * viewMessage;
    NSLayoutConstraint * lcVMH;
    
}

+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        PY_COLOR_ANNOTAION_MESSAGE_LINE = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PYKit.bundle/images/annotation_line.png"]];
    });
}
kINITPARAMSForType(PYAnnotationView){
    
    labelMessage = [UILabel new];
    labelMessage.textColor = [UIColor whiteColor];
    labelMessage.backgroundColor = [UIColor clearColor];
    labelMessage.textAlignment = NSTextAlignmentCenter;
    labelMessage.font = [UIFont systemFontOfSize:14];
    labelMessage.numberOfLines = 0;
    labelMessage.adjustsFontSizeToFitWidth = YES;
    labelMessage.minimumScaleFactor = .5;
    
    viewMessage = [UIView new];
    [viewMessage setCornerRadiusAndBorder:2 borderWidth:1 borderColor:PY_COLOR_ANNOTAION_MESSAGE_LINE];
    
    UIImageView * imageMessageBody = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYKit.bundle/images/annotation_body.png"]];
    [viewMessage addSubview:imageMessageBody];
    [imageMessageBody setAutotLayotDict:@{@"top":@(0), @"left":@(0), @"right":@(0), @"bottom":@(0)}];
    
    [viewMessage addSubview:labelMessage];
    [labelMessage setAutotLayotDict:@{@"top":@(2), @"left":@(4), @"right":@(4), @"bottom":@(2)}];
    [self addSubview:viewMessage];
    NSDictionary<NSString *, NSDictionary<NSString *, NSLayoutConstraint *> *> * dict =  [viewMessage setAutotLayotDict:@{@"top":@(0), @"left":@(0), @"right":@(0), @"h":@(viewMessage.frameHeight)}];
    lcVMH = dict[@"size"][@"selfHeight"];
    
    UIImageView * imageArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYKit.bundle/images/annotation_arrow.png"]];
    [self addSubview:imageArrow];
    [imageArrow setAutotLayotDict:@{@"top":@(-1), @"x":@(0), @"w":@(38), @"h":@(12), @"topPoint":viewMessage}];
    
}

-(instancetype) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]){
        
        [self initParamsPYAnnotationView];
        
        self.annotation = annotation;
        
    }
    
    return self;
    
}

-(void) setAnnotation:(id<MKAnnotation>)annotation{
    [super setAnnotation:annotation];
    if(!labelMessage) return;
    if([annotation respondsToSelector:@selector(title)])labelMessage.text = annotation.title.length ? annotation.title : @"未知";
    CGSize size = [PYUtile getBoundSizeWithTxt:labelMessage.text font:labelMessage.font size:CGSizeMake(80, 999)];
    CGFloat maxHeight = [PYUtile getFontHeightWithSize:labelMessage.font.pointSize fontName:labelMessage.font.fontName] * 4;
    if(size.width < 38) size.width = 38;
    else if(size.height > maxHeight) size.height = maxHeight;
    labelMessage.frameSize = size;
    labelMessage.frameWidth = labelMessage.frameWidth + 1;
    
    
    viewMessage.bounds = labelMessage.bounds;
    viewMessage.frameWidth += 8;
    viewMessage.frameHeight += 4;
    
    lcVMH.constant = viewMessage.frameHeight;
    
    self.bounds = viewMessage.bounds;
    self.frameHeight += 8;
    CGPoint centerOffset = CGPointZero;
    centerOffset.y -= self.frameHeight / 2;
    self.centerOffset = centerOffset;
    
}


@end

@implementation PYAnnotation
+(nullable) annotationWithCoordinate:(CLLocationCoordinate2D) coordinate{
    PYAnnotation * annotation = [[PYAnnotation alloc] init];
    annotation->_coordinate = coordinate;
    return annotation;
}
+(nullable) annotationWithCoordinate:(CLLocationCoordinate2D) coordinate
                               title:(nonnull NSString *) title
                            subtitle:(nullable NSString *) subtitle {
    PYAnnotation * annotation = [[PYAnnotation alloc] init];
    annotation->_coordinate = coordinate;
    annotation->_title = title;
    annotation->_subtitle = subtitle;
    return annotation;
}
@end
