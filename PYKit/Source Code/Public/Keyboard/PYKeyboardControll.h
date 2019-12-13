//
//  PYKeyboardControll.h
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PYKeyboardOptionTag
@optional
-(BOOL) canTouchHidden;
-(BOOL) canChangeFocus;
@end

@protocol PYKeyboardOptionDisable
@end
//定义枚举类型
typedef enum _PYKeyboardControllEnum {
    PYKeyboardControllTag  = 0,
    PYKeyboardControllAll,
} PYKeyboardControllEnum;

@interface PYKeyboardControll : NSObject

+(void) setControllType:(PYKeyboardControllEnum) controllType;
+(BOOL) showKeyboaardOption:(nonnull UIViewController *) vc;

@end

NS_ASSUME_NONNULL_END
