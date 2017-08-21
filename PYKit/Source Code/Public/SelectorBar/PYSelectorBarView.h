//
//  PYSelectorBarView.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/8/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

@interface PYSelectorBarView : UIView
PYPNSNN NSArray * buttons;
PYPNSNN UIImageView * selectorLine;
PYPNSNN UIColor * selectorColor;
PYPNA unsigned int selectIndex;
PYPNCNA BOOL (^blockSelecteItem)(int index);
@end
