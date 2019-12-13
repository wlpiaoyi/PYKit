//
//  PYKeybordOptionView.h
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PYKeybordOptionDelegate<NSObject>
@required
-(void) keybordHidden;
@optional
-(void) next;
-(void) previous;
@end

@interface PYKeyboardOptionView : UIView

kPNA BOOL canChangeFocus;
kPNSNA id tapGestureRecognizer;
kPNANA id<PYKeybordOptionDelegate> delegate;

kPNAR BOOL hasShowKeyboard;
kPNA CGRect keyBoardFrame;
kPNSNA NSString * placeholder;
+(nonnull instancetype) sharedWithTargetView:(nonnull UIResponder *) targetView;
+(nonnull instancetype) getWithTargetView:(nonnull UIResponder *) targetView;
+(nullable UIView<UIKeyInput> *) getCurFirstResponder:(nonnull UIView *) superView inputs:(nonnull NSMutableArray*) inputs;
+(void) setHiddenForTargetView:(nonnull UIResponder *) targetView;
@end

NS_ASSUME_NONNULL_END
