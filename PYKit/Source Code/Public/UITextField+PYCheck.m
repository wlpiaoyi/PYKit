//
//  UITextField+Check.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/6/27.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "UITextField+PYCheck.h"
#import "NSNumber+Expand.h"
#import "NSString+Expand.h"
#import "UIResponder+Hook.h"
#import "UIView+Dialog.h"
#import <objc/runtime.h>
#import "PYTextInputCheckParams.h"

@interface UITextField(_pytextinputcheckparams)
kPNRNN PYTextInputCheckParams * _pytextinputcheckparams;
@end
void * _Nonnull PYTextFieldCheckParamPointer = &PYTextFieldCheckParamPointer;

@implementation UITextField(_pytextinputcheckparams)
-(nonnull PYTextInputCheckParams *) _pytextinputcheckparams{
    return objc_getAssociatedObject(self, PYTextFieldCheckParamPointer);
}
@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

BOOL _pyexchangetextfield_shouldChangeCharactersInRange_replacementString(id target, SEL action, UITextField * textField, NSRange range, NSString * string);
BOOL _pyexchangetextFieldShouldEndEditing(id target, SEL action, UITextField *textField);

BOOL _pytextfield_shouldChangeCharactersInRange_replacementString(id target, SEL action, UITextField * textField, NSRange range, NSString * string);
BOOL _pytextField_shouldEndEditing(id target, SEL action, UITextField *textField);

@implementation UITextField(PYCheck)
-(void) pyClearTextFieldCheck{
    PYTextInputCheckParams * params = self._pytextinputcheckparams;
    if(params == nil){
        @synchronized ([UITextField class]) {
            params = self._pytextinputcheckparams;
            if(params == nil){
                params = [PYTextInputCheckParams new];
                objc_setAssociatedObject(self, PYTextFieldCheckParamPointer, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                static dispatch_once_t ui_textfiled_check_once_token;
                dispatch_once(&ui_textfiled_check_once_token, ^{
                    [UITextField hookMethodWithName:@"setDelegate:"];
                });
            }
        }
    }
    [self._pytextinputcheckparams.dictMatch removeAllObjects];
    if(!self.delegate){
        self.delegate = [self._pytextinputcheckparams getDelegateWithTextInput:self];
    }
}
-(void) pyCheckInteger{
    [self pyCheckIntegerForMax:0 min:0];
}
-(void) pyCheckIntegerForMax:(kInt64) max min:(kInt64) min{
    PYTextInputCheckParams * params = self._pytextinputcheckparams;
    params.maxInteger = max;
    params.minInteger = min;
    [self pyCheckMatchWithIdentify:_UITextInputCheckDictKeyInteger inputing:@"^\\-{0,1}\\d{0,}$" inputEnd:@"^\\-{0,1}\\d{1,}$"];
}
-(void) pyCheckFloat{
    [self pyCheckFloatForMax:0 min:0 precision:0];
}
-(void) pyCheckFloatForMax:(CGFloat) max min:(CGFloat) min precision:(int) precision{
    PYTextInputCheckParams * params = self._pytextinputcheckparams;
    params.maxFloat = max;
    params.minFloat = min;
    params.precisionFloat = precision;
    NSString * matchIng = precision == 0 ? @"^\\-{0,1}\\d{0,}\\.{0,1}\\d{0,}$" : [NSString stringWithFormat:@"^\\-{0,1}\\d{0,}\\.{0,1}\\d{0,%d}$",precision];
    NSString * matchEnd = precision == 0 ? @"^\\-{0,1}\\d{1,}((\\.{1}\\d{1,})|(\\d{0}))$" : [NSString stringWithFormat:@"^\\-{0,1}\\d{1,}((\\.{1}\\d{1,%d})|(\\d{0,%d}))$", precision, precision];
    [self pyCheckMatchWithIdentify:_UITextInputCheckDictKeyFloat inputing:matchIng inputEnd:matchEnd];
    
}
-(void) pyCheckMobliePhone{
    NSDictionary * matchIng = @{
                                @(1):@"^(\\+|1){1}$",
                                @(2):@"^((\\+(\\d{1,2})){1})|((13)|(14)|(15)|(18)|(19)|(17))$",
                                @(3):@"^(\\+(\\d{1,2}))|((13)|(14)|(15)|(18)|(19)|(17))\\d{1}$",
                                @(4):@"^(\\+(\\d{1,2})1)|((13)|(14)|(15)|(18)|(19)|(17))\\d{2}$",
                                @(5):@"^(\\+(\\d{2})){0,1}((13)|(14)|(15)|(18)|(19)|(17))\\d{0,9}$"
                                 };
    NSString * matchEnd = @"^(\\+(\\d{2})){0,1}((13)|(14)|(15)|(18)|(19)|(17))\\d{9}$";
    [self pyCheckMatchWithIdentify:_UITextInputCheckDictKeyMobilePhone inputing:matchIng inputEnd:matchEnd];
    
}
-(void) pyCheckEmail{
    NSString * matchIng = @"^([a-zA-Z0-9_\\.\\-])+\\@{0,1}(([a-zA-Z0-9\\-]){0,}\\.{0,1}){0,1}([a-zA-Z0-9]{0,4}){1}$";
    NSString * matchEnd = @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
    [self pyCheckMatchWithIdentify:_UITextInputCheckDictKeyEmail inputing:matchIng inputEnd:matchEnd];
    
}

-(void) pyCheckIDCard{
    NSDictionary * matchIng = @{
                                @(1):@"^\\d{1,6}$",
                                @(7):@"^\\d{6}[1,2]$",
                                @(8):@"^\\d{6}[1,2]\\d{1,3}$",
                                @(11):@"^\\d{6}[1,2]\\d{3}((0[1-9]{0,1})|(1[0-2]{0,1}))$",
                                @(13):@"^\\d{6}[1,2]\\d{3}((0[1-9])|(1[0-2]))[0-3]$",
                                @(14):@"^\\d{6}[1,2]\\d{3}((0[1-9])|(1[0-2]))((0[1-9])|([1,2][0-9])|(3[0,1]))$",
                                @(15):@"^\\d{6}[1,2]\\d{3}((0[1-9])|(1[0-2]))((0[1-9])|([1,2][0-9])|(3[0,1]))\\d{1,3}$",
                                @(18):@"^\\d{6}[1,2]\\d{3}((0[1-9])|(1[0-2]))((0[1-9])|([1,2][0-9])|(3[0,1]))\\d{3}[0-9X]$"
                                };
    NSString * matchEnd = @"^\\d{6}[1,2]\\d{3}((0[1-9])|(1[0-2]))((0[1-9])|([1,2][0-9])|(3[0,1]))\\d{3}[0-9X]$";
    [self pyCheckMatchWithIdentify:_UITextInputCheckDictKeyIDCard inputing:matchIng inputEnd:matchEnd];
    
}

-(void) pyCheckMatchWithIdentify:(NSString *) identify inputing:(nonnull id) inputing inputEnd:(nonnull NSString *) inputEnd{
    self._pytextinputcheckparams.dictMatch[identify] =@{
                                                                                  _UITextInputCheckDictSubKeyIng:inputing,
                                                                                  _UITextInputCheckDictSubKeyEnd:inputEnd
                                                                                  };
}
-(void) setBlockInputEndMatch:(void (^)(NSString * _Nonnull identify, BOOL * _Nonnull checkResult))blockInputEndMatch{
    self._pytextinputcheckparams.blockInputEnd = blockInputEndMatch;
}
-(void (^)(NSString * _Nonnull, BOOL * _Nonnull)) blockInputEndMatch{
    return self._pytextinputcheckparams.blockInputEnd;
}

-(void) exchangeSetDelegate:(id<UITextFieldDelegate>) delegate{
    [self exchangeSetDelegate:delegate];
    if(delegate && ![delegate conformsToProtocol:@protocol(UITextInputCheckDelegateHookTag)]){
        @synchronized ([delegate class]) {
            if(![delegate conformsToProtocol:@protocol(UITextInputCheckDelegateHookTag)]){
                class_addProtocol([delegate class], @protocol(UITextInputCheckDelegateHookTag));
                SEL action1 = @selector(textField:shouldChangeCharactersInRange:replacementString:);
                SEL action2 = @selector(checktextField:shouldChangeCharactersInRange:replacementString:);
                if(![delegate respondsToSelector:action1]){
                    IMP imp = (IMP)_pyexchangetextfield_shouldChangeCharactersInRange_replacementString;
                    class_addMethod([delegate class], action1, imp, "c24@0:4@8{_NSRange=II}12@20");
                }else{
                    IMP imp = (IMP)_pytextfield_shouldChangeCharactersInRange_replacementString;
                    class_addMethod([delegate class], action2, imp, "c24@0:4@8{_NSRange=II}12@20");
                    Method m1 = class_getInstanceMethod([delegate class], action1);
                    Method m2 = class_getInstanceMethod([delegate class], action2);
                    method_exchangeImplementations(m1, m2);
                }
                action1 = @selector(textFieldShouldEndEditing:);
                action2 = @selector(checktextFieldShouldEndEditing:);
                if(![delegate respondsToSelector:action1]){
                    IMP imp = (IMP)_pyexchangetextFieldShouldEndEditing;
                    class_addMethod([delegate class], action1, imp, "c12@0:4@8");
                }else{
                    IMP imp = (IMP)_pytextField_shouldEndEditing;
                    class_addMethod([delegate class], action2, imp, "c12@0:4@8");
                    Method m1 = class_getInstanceMethod([delegate class], action1);
                    Method m2 = class_getInstanceMethod([delegate class], action2);
                    method_exchangeImplementations(m1, m2);
                }
            }
        }
    }
}
@end

BOOL _pyexchangetextfield_shouldChangeCharactersInRange_replacementString(id target, SEL action, UITextField * textField, NSRange range, NSString * string){
    PYTextInputCheckParams * params = textField._pytextinputcheckparams;
    return _pyexchangetextInput_shouldchangecharactersinrange_replacementstring(params, textField, range, string);
}
BOOL _pyexchangetextFieldShouldEndEditing(id target, SEL action, UITextField *textField){
    PYTextInputCheckParams * params = textField._pytextinputcheckparams;
    return _pyexchangetextinput_shouldendediting(params, target, action, textField);
}

BOOL _pytextfield_shouldChangeCharactersInRange_replacementString(id target, SEL action, UITextField * textField, NSRange range, NSString * string){
    BOOL result = _pyexchangetextfield_shouldChangeCharactersInRange_replacementString(target, action, textField, range, string);
    action = @selector(checktextField:shouldChangeCharactersInRange:replacementString:);
    BOOL usrResult;
    _pytextinput_shouldchangecharactersinrange_replacementstring(target, action, textField, range, string, &usrResult);
    return result && usrResult;
}
BOOL _pytextField_shouldEndEditing(id target, SEL action, UITextField *textField){
    _pyexchangetextFieldShouldEndEditing(target, action, textField);
    action = @selector(checktextFieldShouldEndEditing:);
    BOOL result;
    _pytextinput_shouldendediting(target, action, textField, &result);
    return result;
}
#pragma clang diagnostic pop
