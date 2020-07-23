//
//  PYKeybordOptionView.m
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYKeyboardOptionView.h"

static NSMutableDictionary<NSNumber*, NSNumber *> * PY_KEYBOARD_DICT;
static UIFont * PY_KEYBOARD_FONT;
static void * PY_INPUT_POINTER;

@interface UITextField(__PY_KEYBORD)
- (BOOL)exchangeBecomeFirstResponder;
@end

@interface UITextView(__PY_KEYBORD)
- (BOOL)exchangeBecomeFirstResponder;
@end

@interface PYKeyboardOptionView(InitKeyboard)
-(void) initKeyboard;
@end
@interface PYKeyboardOptionView(InitView)
-(void) initView;
@end

@implementation PYKeyboardOptionView{
@private
    UIView * viewShadown;
    UIView * viewContentLeft;
    UIView * viewContentRight;
    UIButton * buttonHidden;
    UIButton * buttonNext;
    UIButton * buttonPre;
    NSTimer * timerKeyboardShow;
    UILabel * labelPlacetext;
    NSLayoutConstraint * lcOptionW;
    CGFloat lcOptionWValue;
    void * forKeyboardViewPointer;
}

+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken,^{
        PY_KEYBOARD_FONT = [UIFont systemFontOfSize:14 weight:2];
        [UITextField hookInstanceMethodName:@"becomeFirstResponder"];
        [UITextView hookInstanceMethodName:@"becomeFirstResponder"];
    });
}

+(void) setHiddenForTargetView:(nonnull UIResponder *) targetView{
    void * tPointer = (__bridge void *)(targetView);
    if(tPointer == nil) return;
    NSNumber * objectTargetViewo = @((long)tPointer);
    for (NSNumber * objectTargetView in PY_KEYBOARD_DICT) {
        NSNumber * objectKeyboard = PY_KEYBOARD_DICT[objectTargetView];
        void * kPointer = (void *)objectKeyboard.longValue;
        PYKeyboardOptionView * xPYKeyboardOptionView = nil;
        xPYKeyboardOptionView = (__bridge PYKeyboardOptionView *)(kPointer);
        xPYKeyboardOptionView.hidden = objectTargetViewo.longValue != objectTargetView.longValue;
    }
}
-(void) setHidden:(BOOL)hidden{
    [super setHidden:hidden];
}
+(nonnull instancetype) getWithTargetView:(nonnull UIResponder *) targetView{
    if(PY_KEYBOARD_DICT == nil){
        return nil;
    }
    void * tpointer = (__bridge void *)(targetView);
    NSNumber * objectTargetView = @((long)tpointer);
    NSNumber * objectKeyboard = PY_KEYBOARD_DICT[objectTargetView];
    if(!objectTargetView) return nil;
    void * kPointer = (void *)objectKeyboard.longValue;
    PYKeyboardOptionView * xPYKeyboardOptionView = nil;
    xPYKeyboardOptionView = (__bridge PYKeyboardOptionView *)(kPointer);
    return xPYKeyboardOptionView;
}

+(nonnull instancetype) sharedWithTargetView:(nonnull UIResponder *) targetView{
    if(PY_KEYBOARD_DICT == nil){
        PY_KEYBOARD_DICT = [NSMutableDictionary new];
    }
    void * tpointer = (__bridge void *)(targetView);
    NSNumber * objectTargetView = @((long)tpointer);
    NSNumber * objectKeyboard = PY_KEYBOARD_DICT[objectTargetView];
    PYKeyboardOptionView * xPYKeyboardOptionView = nil;
    if(objectKeyboard == nil){
        xPYKeyboardOptionView = [PYKeyboardOptionView new];
        xPYKeyboardOptionView->forKeyboardViewPointer = tpointer;
        void * kPointer = (__bridge void *)(xPYKeyboardOptionView);
        objectKeyboard = @((long) kPointer);
        PY_KEYBOARD_DICT[objectTargetView] = objectKeyboard;
    }
    
    void * kPointer = (void *)objectKeyboard.longValue;
    xPYKeyboardOptionView = (__bridge PYKeyboardOptionView *)(kPointer);
    
    return xPYKeyboardOptionView;
}

kINITPARAMSForType(PYKeyboardOptionView){
    
    self.canChangeFocus = YES;
    kNOTIF_ADD(self, @"PY_KEYBORD_SET_PLACEHLODER", notifySetPlaceholder:);
    [self initView];
    [self initKeyboard];

}
-(void) notifySetPlaceholder:(NSNotification *) notify{
    NSString * obj = notify.object;
    self.placeholder = obj;
}
-(void) setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    labelPlacetext.text = placeholder ?  : @"";
}

- (void)onclickHidden:(id)sender {
    [PYKeyboardNotification hiddenKeyboard];
    if(self.delegate && [self.delegate respondsToSelector:@selector(keybordHidden)]){
        [self.delegate keybordHidden];
    }
}
- (void)onclickNext:(id)sender {
    if(!forKeyboardViewPointer) return;
    
    NSMutableArray<UIKeyInput> * inputs = [NSMutableArray<UIKeyInput>  new];
    UIView * forKeyboardView = [self getForKeyboardView];
    UIView<UIKeyInput> * inputView = [PYKeyboardOptionView getCurFirstResponder:forKeyboardView inputs:inputs];
    [inputs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIView * view1 = obj1;
        UIView * view2 = obj2;
        CGPoint p1 = [view1 getAbsoluteOrigin:forKeyboardView];
        CGPoint p2 = [view2 getAbsoluteOrigin:forKeyboardView];
        if(p1.y < p2.y) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    NSUInteger index = (inputView && [inputs containsObject:inputView]) ? [inputs indexOfObject:inputView] : -1;
    if(index != -1){
        if(index < inputs.count - 1){
            index ++;
        }else{
            index = 0;
        }
        
        inputView = [inputs objectAtIndex:index];
        if(@available(iOS 10.0, *)){
            kAssign(self);
            timerKeyboardShow = [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:NO block:^(NSTimer * _Nonnull timer) {
                kStrong(self);
                [UIView animateWithDuration:.25 animations:^{
                    [self keyboradShowDoingWithInputView:inputView keyboradFrame:self.keyBoardFrame];
                }];
            }];
        }
        [inputView becomeFirstResponder];
    }
    if(self.delegate){
        [self.delegate next];
    }
}
- (void)onclickPre:(id)sender {
    if(!forKeyboardViewPointer) return;
    NSMutableArray<UIKeyInput> * inputs = [NSMutableArray<UIKeyInput>  new];
    UIView * forKeyboardView = [self getForKeyboardView];
    UIView<UIKeyInput> * inputView = [PYKeyboardOptionView getCurFirstResponder:forKeyboardView inputs:inputs];
    [inputs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIView * view1 = obj1;
        UIView * view2 = obj2;
        CGPoint p1 = [view1 getAbsoluteOrigin:forKeyboardView];
        CGPoint p2 = [view2 getAbsoluteOrigin:forKeyboardView];
        if(p1.y < p2.y) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    NSUInteger index = (inputView && [inputs containsObject:inputView]) ? [inputs indexOfObject:inputView] : -1;
    if(index != -1){
        if(index > 0){
            index --;
        }else{
            index = inputs.count - 1;
        }
        inputView = [inputs objectAtIndex:index];
        if(@available(iOS 10.0, *)){
            kAssign(self);
            timerKeyboardShow = [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:NO block:^(NSTimer * _Nonnull timer) {
                kStrong(self);
                [UIView animateWithDuration:.25 animations:^{
                    [self keyboradShowDoingWithInputView:inputView keyboradFrame:self.keyBoardFrame];
                }];
            }];
        }
        [inputView becomeFirstResponder];
    }
    if(self.delegate){
        [self.delegate previous];
    }
}

+(UIView<UIKeyInput> *) getCurFirstResponder:(UIView *) superView inputs:(NSMutableArray<id<UITextInput>> *) inputs{
    UIView<UIKeyInput> * inputView = nil;
    for (UIView * subView in superView.subviews) {
        if([subView conformsToProtocol:@protocol(UITextInput)]){
            if(subView.hidden || !subView.userInteractionEnabled || subView.frame.size.width <= 0 || subView.frame.size.height <= 0){
                continue;
            }
            if(inputs) [inputs addObject:((id<UITextInput>)subView)];
            if([subView isFirstResponder]){
                inputView = (UIView<UIKeyInput> *)subView;
            }
        }else{
            UIView<UIKeyInput> * temp = [self getCurFirstResponder:subView inputs:inputs];
            if(temp) inputView = temp;
        }
    }
    return inputView;
}
-(nonnull UIView *) getForKeyboardView{
    UIResponder * forKeyboardViewo = (__bridge UIView *)(forKeyboardViewPointer);
    UIView * forKeyboardView = nil;
    if([forKeyboardViewo isKindOfClass:[UIViewController class]]){
        forKeyboardView = ((UIViewController *)forKeyboardViewo).view;
    }else{
        forKeyboardView = (UIView *)forKeyboardViewo;
    }
    return forKeyboardView;
}
-(void) keyboradShowDoingWithInputView:(nullable UIView<UIKeyInput> *) inputView keyboradFrame:(CGRect) keyboradFrame{
    if(self.hidden) return;
    [timerKeyboardShow invalidate];
    timerKeyboardShow = nil;
    self.keyBoardFrame = keyboradFrame;
    [self.superview bringSubviewToFront:self];
    self.frameY = self.superview.frameHeight - keyboradFrame.size.height - self.frameHeight;
    NSMutableArray<UIKeyInput> * inputs = [NSMutableArray<UIKeyInput>  new];
    UIView * forKeyboardView = [self getForKeyboardView];
    if(!inputView) inputView = [PYKeyboardOptionView getCurFirstResponder:forKeyboardView inputs:inputs];
    else [PYKeyboardOptionView getCurFirstResponder:forKeyboardView inputs:inputs];
    if(!inputView) return;
    UIView * topView = [PYUtile getTopView:forKeyboardView];
    if(inputs.count > 1){
        [buttonPre setEnabled:YES];
        [buttonNext setEnabled:YES];
    }else{
        [buttonPre setEnabled:NO];
        [buttonNext setEnabled:NO];;
    }
    if(self.canChangeFocus){
        CGPoint p = [inputView getAbsoluteOrigin:topView];
        CGFloat value = (boundsHeight() - p.y - inputView.frameHeight) - keyboradFrame.size.height - self.frameHeight;
        CGRect bounds = forKeyboardView.bounds;
        if(value > 0){
            if(bounds.origin.y != 0){
                bounds.origin.y = 0;
                forKeyboardView.bounds = bounds;
            }
            return;
        }
        bounds.origin.y = -value;
        forKeyboardView.bounds = bounds;
    }
}

-(void) dealloc {
    [PY_KEYBOARD_DICT removeObjectForKey:@((long)forKeyboardViewPointer)];
    [PYKeyboardNotification removeKeyboardNotificationWithResponder:self];
    forKeyboardViewPointer = nil;
    kNOTIF_REMV(self, @"PY_KEYBORD_SET_PLACEHLODER");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation PYKeyboardOptionView(InitView)
-(void) initView{
    self.frameSize = CGSizeMake(boundsWidth(), 30);
    UIColor * bgColor;
    if (@available(iOS 13.0, *)) {
        bgColor = [UIColor systemBackgroundColor];
    } else {
        bgColor = [UIColor whiteColor];
    }
    
    UIView * tempView = [UIView new];
    tempView.backgroundColor = bgColor;
    [self addSubview:tempView];
    viewShadown = [UIView new];
    viewShadown.backgroundColor = [UIColor clearColor];
    [viewShadown setShadowColor:[UIColor grayColor].CGColor shadowRadius:4];
    [self addSubview:viewShadown];
    [viewShadown setAutotLayotDict:@{@"top":@(0),@"left":@(0),@"bottom":@(0),@"right":@(0)}];
    
    viewContentLeft = [UIView new];
    viewContentLeft.backgroundColor = bgColor;
    [viewShadown addSubview:viewContentLeft];
    [viewContentLeft setAutotLayotDict:@{@"top":@(0),@"w":@(66 + self.frameHeight),@"bottom":@(0),@"right":@(-self.frameHeight/2)}];
    [viewContentLeft setCornerRadiusAndBorder:self.frameHeight/2 borderWidth:0 borderColor:[UIColor clearColor]];
    
    UIButton * b = [self.class __PY_CREATE_BUTTON];
    [b setTitle:@"Done " forState:UIControlStateNormal];
    [b addTarget:self action:@selector(onclickHidden:) forControlEvents:UIControlEventTouchUpInside];
    [viewContentLeft addSubview:b];
    [b setAutotLayotDict:@{@"top":@(0),@"left":@(self.frameHeight/2),@"bottom":@(0),@"right":@(self.frameHeight/2)}];
    buttonHidden = b;
    
    viewContentRight = [UIView new];
    viewContentRight.backgroundColor = bgColor;
    [viewShadown addSubview:viewContentRight];
    lcOptionWValue = 66 + self.frameHeight;
    lcOptionW = [viewContentRight setAutotLayotDict:@{@"top":@(0),@"w":@(lcOptionWValue),@"bottom":@(0),@"left":@(-self.frameHeight/2)}][@"size"][@"selfWith"];
    [viewContentRight setCornerRadiusAndBorder:self.frameHeight/2 borderWidth:0 borderColor:[UIColor clearColor]];
    b = [self.class __PY_CREATE_BUTTON];
    
    [b setTitle:@" ⬆︎" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(onclickPre:) forControlEvents:UIControlEventTouchUpInside];
    [viewContentRight addSubview:b];
    buttonPre = b;
    
    b = [self.class __PY_CREATE_BUTTON];
    [b setTitle:@" ⬇︎" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(onclickNext:) forControlEvents:UIControlEventTouchUpInside];
    [viewContentRight addSubview:b];
    buttonNext = b;
    [PYViewAutolayoutCenter persistConstraintHorizontal:@[buttonPre, buttonNext] relationmargins:UIEdgeInsetsMake(0, self.frameHeight/2, 0, self.frameHeight/2) relationToItems:PYEdgeInsetsItemNull() offset:0];
    
    [tempView setShadowColor:[UIColor grayColor].CGColor shadowRadius:1];
    [tempView setAutotLayotDict:@{@"top":@(0),@"left":@(-self.frameHeight/2),@"leftPoint":viewContentRight, @"bottom":@(0),@"right":@(-self.frameHeight/2),@"rightPoint":viewContentLeft}];
    self.backgroundColor = bgColor;
    labelPlacetext = [UILabel new];
    labelPlacetext.textColor = [UIColor lightGrayColor];
    labelPlacetext.backgroundColor = [UIColor clearColor];
    labelPlacetext.textAlignment = NSTextAlignmentCenter;
    labelPlacetext.font = [UIFont systemFontOfSize:12];
    labelPlacetext.numberOfLines = 2;
    [tempView addSubview:labelPlacetext];
    [labelPlacetext setAutotLayotDict:@{@"top":@(0),@"left":@(self.frameHeight/2),@"bottom":@(0),@"right":@(self.frameHeight/2)}];
    self.placeholder = nil;
}
+(UIButton *) __PY_CREATE_BUTTON{
    UIButton * b =  [UIButton buttonWithType:UIButtonTypeCustom];
    [b.titleLabel setFont:PY_KEYBOARD_FONT];
    [b setTitleColor:[UIColor colorWithRGBHex:0x167ffbff] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [b setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [b setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [b setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
    return b;
}
@end

@implementation PYKeyboardOptionView(InitKeyboard)

-(void) initKeyboard{
    [PYKeyboardNotification setKeyboardNotificationShowWithResponder:self begin:^(UIResponder * _Nonnull responder) {
        PYKeyboardOptionView * keyboardView = (PYKeyboardOptionView *)responder;
        if(keyboardView.hidden) return;
        keyboardView.frameY =  boundsHeight();
    } doing:^(UIResponder * _Nonnull responder, CGRect keyBoardFrame) {
        PYKeyboardOptionView * keyboardView = (PYKeyboardOptionView *)responder;
        keyboardView.frameWidth = keyBoardFrame.size.width;
        keyboardView->_hasShowKeyboard = true;
        if(keyboardView.hidden) return;
        [keyboardView keyboradShowDoingWithInputView:nil keyboradFrame:keyBoardFrame];
    } end:^(UIResponder * _Nonnull responder) {}];
    
    [PYKeyboardNotification setKeyboardNotificationHiddenWithResponder:self begin:^(UIResponder * _Nonnull responder) {
        PY_INPUT_POINTER = nil;
    } doing:^(UIResponder * _Nonnull responder, CGRect keyBoardFrame) {
        PYKeyboardOptionView * keyboardView = (PYKeyboardOptionView *)responder;
        if(keyboardView.hidden) return;
        UIResponder * forKeyboardViewo = (__bridge UIView *)(keyboardView->forKeyboardViewPointer);
        UIView * targetView = nil;
        if([forKeyboardViewo isKindOfClass:[UIViewController class]]){
            targetView = ((UIViewController *)forKeyboardViewo).view;
        }else{
            targetView = (UIView *)forKeyboardViewo;
        }
        [keyboardView->timerKeyboardShow invalidate];
        keyboardView->timerKeyboardShow = nil;
        if(!keyboardView.hasShowKeyboard) return;
        keyboardView.frameY =  boundsHeight();
        CGRect bounds = targetView.bounds;
        bounds.origin.y = 0;
        targetView.bounds = bounds;
        keyboardView->_hasShowKeyboard = false;
    } end:^(UIResponder * _Nonnull responder) {
        PYKeyboardOptionView * keyboardView = (PYKeyboardOptionView *)responder;
        if(keyboardView.hidden) return;
        keyboardView.frameY = MAX( boundsHeight(),  boundsWidth());
    }];
}
@end

@implementation UITextField(__PY_KEYBORD)
- (BOOL)exchangeBecomeFirstResponder{
    BOOL flag = [self exchangeBecomeFirstResponder];
    if(flag){
        kNOTIF_POST(@"PY_KEYBORD_SET_PLACEHLODER", self.placeholder);
    }
    if(flag) PY_INPUT_POINTER = (__bridge void *)(self);
    return flag;
}
@end

@implementation UITextView(__PY_KEYBORD)
- (BOOL)exchangeBecomeFirstResponder{
    BOOL flag = [self exchangeBecomeFirstResponder];
    if(flag){
        kNOTIF_POST(@"PY_KEYBORD_SET_PLACEHLODER", nil);
    }
    if(flag) PY_INPUT_POINTER = (__bridge void *)(self);
    return flag;
}
@end
