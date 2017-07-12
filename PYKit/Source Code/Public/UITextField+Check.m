//
//  UITextField+Check.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/6/27.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "UITextField+Check.h"
#import "NSNumber+Expand.h"
#import "NSString+Expand.h"
//#import "UIView+Hook.h"
#import "UIResponder+Hook.h"
#import "UIView+Dialog.h"
#import <objc/runtime.h>
#import <AudioToolbox/AudioToolbox.h>
@class _UITextFieldCheckHookBaseDelegateImp;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

void * UITextFieldCheckParamPointer = &UITextFieldCheckParamPointer;
NSString * UITextFieldCheckDictKeyInteger = @"Integer";
NSString * UITextFieldCheckDictKeyFloat = @"Float";
NSString * UITextFieldCheckDictKeyMobilePhone  = @"MobilePhone";
NSString * UITextFieldCheckDictKeyHomePhone = @"HomePhone";
NSString * UITextFieldCheckDictKeyEmail = @"Email";
NSString * UITextFieldCheckDictKeyIDCard= @"IDCard";
NSString * UITextFieldCheckDictSubKeyIng = @"Ing";
NSString * UITextFieldCheckDictSubKeyEnd = @"End";
//_UITextFieldCheckHookBaseDelegateImp * _UITextFieldCheckHookBaseDelegateImp_;

@protocol UITextFieldCheckDelegateHookTag <NSObject> @end
@interface _UITextFieldCheckDelegateImp : NSObject<UITextFieldDelegate>@end

BOOL _pyexchangetextfield_shouldChangeCharactersInRange_replacementString(id target, SEL action, UITextField * textField, NSRange range, NSString * string);
BOOL _pyexchangetextFieldShouldEndEditing(id target, SEL action, UITextField *textField);

BOOL _pytextfield_shouldChangeCharactersInRange_replacementString(id target, SEL action, UITextField * textField, NSRange range, NSString * string);
BOOL _pytextField_shouldEndEditing(id target, SEL action, UITextField *textField);

//@interface _UITextFieldCheckHookBaseDelegateImp : NSObject<UIViewHookDelegate>
//@end

@interface UITextFieldCheckParams : NSObject
PYPNSNN NSMutableDictionary * dictMatch;
PYPNSNA _UITextFieldCheckDelegateImp * delegate;
PYPNA PYInt64 maxInteger;
PYPNA PYInt64 minInteger;
PYPNA CGFloat maxFloat;
PYPNA CGFloat minFloat;
PYPNA int precisionFloat;
PYPNCNA void (^ blockInputEnd) (NSString * _Nonnull identify, BOOL * _Nonnull checkResult);
@end

@implementation UITextField(Check)
//-(BOOL) _textFielCheckResignFirstResponder{
//    BOOL result = [self _textFielCheckResignFirstResponder];
//    if(!result){
//        if([self _getPYTextFieldCheckParams]){
//            [self _setPYTextFieldCheckParams:nil];
//            [self resignFirstResponder];
//        }
//    }
//    return result;
//}
-(void) clearTextFieldCheck{
    [[self _getPYTextFieldCheckParams].dictMatch removeAllObjects];
    if(!self.delegate){
        self.delegate = [self _getPYTextFieldCheckParams].delegate;
    }
//    //==>
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
////        _UITextFieldCheckHookBaseDelegateImp_ = [_UITextFieldCheckHookBaseDelegateImp new];
//        //        [UITextField addDelegateView:_UITextFieldCheckHookBaseDelegateImp_];
//        Method m1 = class_getInstanceMethod([UITextField class], @selector(resignFirstResponder));
//        Method m2 = class_getInstanceMethod([UITextField class], @selector(_textFielCheckResignFirstResponder));
//        method_exchangeImplementations(m1, m2);
//    });
//    ///<==
}
-(void) checkInteger{
    [self checkIntegerForMax:0 min:0];
}
-(void) checkIntegerForMax:(PYInt64) max min:(PYInt64) min{
    UITextFieldCheckParams * params = [self _getPYTextFieldCheckParams];
    params.maxInteger = max;
    params.minInteger = min;
    [self checkMatchWithIdentify:UITextFieldCheckDictKeyInteger inputing:@"^\\-{0,1}\\d{0,}$" inputEnd:@"^\\-{0,1}\\d{1,}$"];
}
-(void) checkFloat{
    [self checkFloatForMax:0 min:0 precision:0];
}
-(void) checkFloatForMax:(CGFloat) max min:(CGFloat) min precision:(int) precision{
    UITextFieldCheckParams * params = [self _getPYTextFieldCheckParams];
    params.maxFloat = max;
    params.minFloat = min;
    params.precisionFloat = precision;
    NSString * matchIng = precision == 0 ? @"^\\-{0,1}\\d{0,}\\.{0,1}\\d{0,}$" : [NSString stringWithFormat:@"^\\-{0,1}\\d{0,}\\.{0,1}\\d{0,%d}$",precision];
    NSString * matchEnd = precision == 0 ? @"^\\-{0,1}\\d{1,}((\\.{1}\\d{1,})|(\\d{0}))$" : [NSString stringWithFormat:@"^\\-{0,1}\\d{1,}((\\.{1}\\d{1,%d})|(\\d{0,%d}))$", precision, precision];
    [self checkMatchWithIdentify:UITextFieldCheckDictKeyFloat inputing:matchIng inputEnd:matchEnd];
    
}
-(void) checkMobliePhone{
    NSDictionary * matchIng = @{
                                @(1):@"^(\\+|1){1}$",
                                @(2):@"^((\\+(\\d{1,2})){1})|((13)|(14)|(15)|(18)|(19)|(17))$",
                                @(3):@"^(\\+(\\d{1,2}))|((13)|(14)|(15)|(18)|(19)|(17))\\d{1}$",
                                @(4):@"^(\\+(\\d{1,2})1)|((13)|(14)|(15)|(18)|(19)|(17))\\d{2}$",
                                @(5):@"^(\\+(\\d{2})){0,1}((13)|(14)|(15)|(18)|(19)|(17))\\d{0,9}$"
                                 };
    NSString * matchEnd = @"^(\\+(\\d{2})){0,1}((13)|(14)|(15)|(18)|(19)|(17))\\d{9}$";
    [self checkMatchWithIdentify:UITextFieldCheckDictKeyMobilePhone inputing:matchIng inputEnd:matchEnd];
    
}
-(void) checkEmail{
    NSString * matchIng = @"^([a-zA-Z0-9_\\.\\-])+\\@{0,1}(([a-zA-Z0-9\\-]){0,}\\.{0,1}){0,1}([a-zA-Z0-9]{0,4}){1}$";
    NSString * matchEnd = @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
    [self checkMatchWithIdentify:UITextFieldCheckDictKeyEmail inputing:matchIng inputEnd:matchEnd];
    
}

-(void) checkIDCard{
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
    [self checkMatchWithIdentify:UITextFieldCheckDictKeyIDCard inputing:matchIng inputEnd:matchEnd];
    
}

-(void) checkMatchWithIdentify:(NSString *) identify inputing:(nonnull id) inputing inputEnd:(nonnull NSString *) inputEnd{
    [self _getPYTextFieldCheckParams].dictMatch[identify] =@{
                                                                                  UITextFieldCheckDictSubKeyIng:inputing,
                                                                                  UITextFieldCheckDictSubKeyEnd:inputEnd
                                                                                  };
}
-(void) setBlockInputEndMatch:(void (^)(NSString * _Nonnull identify, BOOL * _Nonnull checkResult))blockInputEndMatch{
    [self _getPYTextFieldCheckParams].blockInputEnd = blockInputEndMatch;
}
-(void (^)(NSString * _Nonnull, BOOL * _Nonnull)) blockInputEndMatch{
    return [self _getPYTextFieldCheckParams].blockInputEnd;
}

-(void) exchangeSetDelegate:(id<UITextFieldDelegate>) delegate{
    [self exchangeSetDelegate:delegate];
    if(delegate && ![delegate conformsToProtocol:@protocol(UITextFieldCheckDelegateHookTag)]){
        @synchronized ([delegate class]) {
            if(![delegate conformsToProtocol:@protocol(UITextFieldCheckDelegateHookTag)]){
                class_addProtocol([delegate class], @protocol(UITextFieldCheckDelegateHookTag));
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

-(UITextFieldCheckParams *) _getPYTextFieldCheckParams{
    UITextFieldCheckParams * params = objc_getAssociatedObject(self, UITextFieldCheckParamPointer);
    if(params == nil){
        @synchronized ([UITextField class]) {
            params = objc_getAssociatedObject(self, UITextFieldCheckParamPointer);
            if(params == nil){
                params = [UITextFieldCheckParams new];
                [self _setPYTextFieldCheckParams:params];
                static dispatch_once_t ui_textfiled_check_once_token;
                dispatch_once(&ui_textfiled_check_once_token, ^{
                    [UITextField hookMethodWithName:@"setDelegate:"];
                });
            }
        }
    }
    return params;
}
-(void) _setPYTextFieldCheckParams:(UITextFieldCheckParams *) params{
    objc_setAssociatedObject(self, UITextFieldCheckParamPointer, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end


@implementation UITextFieldCheckParams
-(instancetype) init{
    if(self = [super init]){
        self.dictMatch = [NSMutableDictionary new];
        self.delegate = [_UITextFieldCheckDelegateImp new];
        self.minInteger = self.maxInteger = self.minFloat = self.maxFloat = self.precisionFloat = 0;
    }
    return self;
}
@end

BOOL _pyexchangetextfield_shouldChangeCharactersInRange_replacementString(id target, SEL action, UITextField * textField, NSRange range, NSString * string){
    if(string.length == 0) return YES;
    
    NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextFieldCheckParams * params = [textField _getPYTextFieldCheckParams];
    if(!params || params.dictMatch.count == 0 || text.length == 0) return YES;
    
    BOOL result = NO;
    for (NSString * key in params.dictMatch) {
        id ing = params.dictMatch[key][UITextFieldCheckDictSubKeyIng];
        if([ing isKindOfClass:[NSString class]]){
            
        }else if([ing isKindOfClass:[NSDictionary class]]){
            for (NSInteger i = text.length; i > 0; i--) {
                id value = ing[@(i)];
                if(value){
                    ing = value;
                    break;
                }
            }
        }else{
            NSLog(@"match [%@] is erro type!", ing);
            continue;
        }
        if(ing == nil){
            NSLog(@"match not found ing match value!");
            continue;
        }
        BOOL flag = [NSString matchArg:text regex:ing];
        if(!flag) continue;
        
        if([key isEqual:UITextFieldCheckDictKeyInteger]){
            if(params.maxInteger != 0 || params.minInteger != 0){
                flag = text.longLongValue <= params.maxInteger && text.longLongValue >= params.minInteger;
            }
        }else if([key isEqual:UITextFieldCheckDictKeyFloat]){
            if(params.maxFloat != 0 || params.minFloat != 0){
                flag = text.doubleValue <= params.maxFloat && text.doubleValue >= params.minFloat;
            }
        }
        result = result | flag;
        if(result) break;
    }
    if(!result){
        AudioServicesPlaySystemSound(1305);
    }
    return result;
}
BOOL _pyexchangetextFieldShouldEndEditing(id target, SEL action, UITextField *textField){
    
    NSString * text = textField.text;
    if(text.length == 0) return YES;
    
    UITextFieldCheckParams * params = [textField _getPYTextFieldCheckParams];
    if(!params || params.dictMatch.count == 0) return YES;
    
    BOOL result = NO;
    for (NSString * key in params.dictMatch) {
        id ing = params.dictMatch[key][UITextFieldCheckDictSubKeyEnd];
        BOOL flag = [NSString matchArg:text regex:ing];
        if(!flag){
            continue;
        }else if([key isEqual:UITextFieldCheckDictKeyInteger]){
            if(params.maxInteger != 0 || params.minInteger != 0){
                flag = text.longLongValue <= params.maxInteger && text.longLongValue >= params.minInteger;
            }
            textField.text = @(text.longLongValue).stringValue;
        }else if([key isEqual:UITextFieldCheckDictKeyFloat]){
            if(params.maxFloat != 0 || params.minFloat != 0){
                flag = text.doubleValue <= params.maxFloat && text.doubleValue >= params.minFloat;
            }
            textField.text = params.precisionFloat == 0 ? @(text.doubleValue).stringValue : [@(text.doubleValue) stringValueWithPrecision:params.precisionFloat];
        }else if([key isEqual:UITextFieldCheckDictKeyIDCard]){
            flag = [text matchIdentifyNumber];
        }
        result = result | flag;
        if([textField _getPYTextFieldCheckParams].blockInputEnd){
            [textField _getPYTextFieldCheckParams].blockInputEnd(key, &result);
        }
        if(result) break;
    }
    if(!result){
        AudioServicesPlaySystemSound(1305);
        textField.text = @"";
    }
    return YES;
}

BOOL _pytextfield_shouldChangeCharactersInRange_replacementString(id target, SEL action, UITextField * textField, NSRange range, NSString * string){
    BOOL result = _pyexchangetextfield_shouldChangeCharactersInRange_replacementString(target, action, textField, range, string);
    SEL action2 = @selector(checktextField:shouldChangeCharactersInRange:replacementString:);
    NSMethodSignature * sig  = [[target class] instanceMethodSignatureForSelector:action2];
    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
    [invocatin setTarget:target];
    [invocatin setSelector:action2];
    [invocatin setArgument:&textField atIndex:2];
    [invocatin setArgument:&range atIndex:3];
    [invocatin setArgument:&string atIndex:4];
    [invocatin retainArguments];
    [invocatin invoke];
    return result;
}
BOOL _pytextField_shouldEndEditing(id target, SEL action, UITextField *textField){
    _pyexchangetextFieldShouldEndEditing(target, action, textField);
    SEL action2 = @selector(checktextFieldShouldEndEditing:);
    NSMethodSignature * sig  = [[target class] instanceMethodSignatureForSelector:action2];
    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
    [invocatin setTarget:target];
    [invocatin setSelector:action2];
    [invocatin setArgument:&textField atIndex:2];
    [invocatin retainArguments];
    [invocatin invoke];
    BOOL result;
    [invocatin getReturnValue:&result];
    return result;
}
@implementation _UITextFieldCheckDelegateImp @end

//@implementation _UITextFieldCheckHookBaseDelegateImp
//
//-(void) beforeExcuteRemoveFromSuperview:(nonnull BOOL *) isExcute target:(nonnull UIView *) target{
//    if(![target isKindOfClass:[UITextField class]]) return;
//    UITextField * textField = (UITextField *)target;
//    if([textField _getPYTextFieldCheckParams]){
//        [textField _setPYTextFieldCheckParams:nil];
//        if(![textField resignFirstResponder]){
//            UIView * view = [UIView new];
//            [view dialogShowWithTitle:@"alert" message:@"KeyBoard Hidden Faild!" block:^(UIView * _Nonnull view, NSUInteger index) {
//                [view dialogHidden];
//            } buttonNames:@[@"确定"]];
//        }
//    }
//}
//
//@end
#pragma clang diagnostic pop
