//
//  PY3DView.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/11/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PY3DParams.h"
@interface PY3DView : UIView{
@protected
    UIView * _viewContainer;
}
kPNA PY3DSize size;
-(void) syn3DTranslate;
-(void) angleWithDegreex:(CGFloat) degreex degreey:(CGFloat) degreey degreez:(CGFloat) degreez;
@end
