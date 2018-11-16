//
//  PYTextInputCheckParams.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/7/14.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYTextInputCheckParams.h"
#import <objc/runtime.h>
#import "NSNumber+Expand.h"
#import "NSString+Expand.h"
#import <AudioToolbox/AudioToolbox.h>

NSString * _UITextInputCheckDictKeyInteger = @"Integer";
NSString * _UITextInputCheckDictKeyFloat = @"Float";
NSString * _UITextInputCheckDictKeyMobilePhone  = @"MobilePhone";
NSString * _UITextInputCheckDictKeyHomePhone = @"HomePhone";
NSString * _UITextInputCheckDictKeyEmail = @"Email";
NSString * _UITextInputCheckDictKeyIDCard= @"IDCard";
NSString * _UITextInputCheckDictSubKeyIng = @"Ing";
NSString * _UITextInputCheckDictSubKeyEnd = @"End";

@implementation _UITextFieldCheckDelegateImp @end
@implementation _UITextViewCheckDelegateImp @end
@protocol PYChekckTextFieldDelegate <NSObject>
@optional
- (BOOL)checktextField:(id<UITextInput>)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)checktextFieldShouldEndEditing:(id<UITextInput>)textField;
@end

@implementation PYTextInputCheckParams{
@private id _delegate;
}
-(instancetype) init{
    if(self = [super init]){
        self.dictMatch = [NSMutableDictionary new];
        self.minInteger = self.maxInteger = self.minFloat = self.maxFloat = self.precisionFloat = 0;
    }
    return self;
}
-(nullable id) getDelegateWithTextInput:(nonnull id<UITextInput>) textInput{
    if(_delegate == nil){
        @synchronized (self) {
            if(_delegate == nil){
                if([textInput class] == [UITextField class]){
                    _delegate = [_UITextFieldCheckDelegateImp new];
                }else if([textInput class] == [UITextView class]){
                    _delegate = [_UITextViewCheckDelegateImp new];
                }else{
                    NSLog(@"erro get delegate : the class type is not right type");
                }
            }
        }
    }
    return _delegate;
}
@end

bool _pytextinputcheck_isenabletype(id<UITextInput> textInput){
    if([textInput class] == [UITextField class]){
        return true;
    }else if([textInput class] == [UITextView class]){
        return true;
    }else{
        NSLog(@"erro get delegate : the class type is not right type");
        return false;
    }
}
NSString * _pytexttnputcheck_gettext( id<UITextInput> textInput){
    if([textInput class] == [UITextField class]){
        return ((UITextField *)textInput).text;
    }else if([textInput class] == [UITextView class]){
        return ((UITextView *)textInput).text;
    }else{
        NSLog(@"erro get delegate : the class type is not right type");
        return nil;
    }
}
void  _pytexttnputcheck_settext( id<UITextInput> textInput, NSString * _Nullable text){
    if([textInput class] == [UITextField class]){
        ((UITextField *)textInput).text = text;
    }else if([textInput class] == [UITextView class]){
        ((UITextView *)textInput).text = text;
    }else{
        NSLog(@"erro get delegate : the class type is not right type");
    }
}

bool _pyexchangetextInput_shouldchangecharactersinrange_replacementstring(PYTextInputCheckParams * _Nonnull params, id<UITextInput> _Nonnull textInput, NSRange range, NSString * _Nullable string){
    if(!params || params.dictMatch.count == 0) return true;
    if(_pytextinputcheck_isenabletype(textInput) == false) return false;
    if(string.length == 0) return true;
    NSString * textOriginal = _pytexttnputcheck_gettext(textInput);
    NSString * textChange = [textOriginal stringByReplacingCharactersInRange:range withString:string];
    if(textChange.length == 0) return true;
    
    bool result = false;
    for (NSString * key in params.dictMatch) {
        id ing = params.dictMatch[key][_UITextInputCheckDictSubKeyIng];
        if([ing isKindOfClass:[NSString class]]){
            
        }else if([ing isKindOfClass:[NSDictionary class]]){
            for (NSInteger i = textChange.length; i > 0; i--) {
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
        BOOL flag = [NSString matchArg:textChange regex:ing];
        if(!flag) continue;
        if([key isEqual:_UITextInputCheckDictKeyInteger]){
            if(params.maxInteger != 0 || params.minInteger != 0){
                flag = textChange.longLongValue <= params.maxInteger;
                flag = flag && (textChange.longLongValue >= params.minInteger || string.longLongValue < params.minInteger);
            }
        }else if([key isEqual:_UITextInputCheckDictKeyFloat]){
            if(params.maxFloat != 0 || params.minFloat != 0){
                flag = textChange.doubleValue <= params.maxFloat;
                flag = flag && (textChange.doubleValue >= params.minFloat || string.doubleValue < params.minFloat);
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

bool _pyexchangetextinput_shouldendediting(PYTextInputCheckParams * _Nonnull params, id target, SEL action, id<UITextInput> textInput){
    if(!params || params.dictMatch.count == 0) return true;
    if(_pytextinputcheck_isenabletype(textInput) == false) return false;
    NSString * text = _pytexttnputcheck_gettext(textInput);
    if(text.length == 0) return true;
    
    BOOL result = false;
    for (NSString * key in params.dictMatch) {
        id ing = params.dictMatch[key][_UITextInputCheckDictSubKeyEnd];
        BOOL flag = [NSString matchArg:text regex:ing];
        if(!flag){
            continue;
        }else if([key isEqual:_UITextInputCheckDictKeyInteger]){
            if(params.maxInteger != 0 || params.minInteger != 0){
                flag = text.longLongValue <= params.maxInteger && text.longLongValue >= params.minInteger;
            }
            text = @(text.longLongValue).stringValue;
        }else if([key isEqual:_UITextInputCheckDictKeyFloat]){
            if(params.maxFloat != 0 || params.minFloat != 0){
                flag = text.doubleValue <= params.maxFloat && text.doubleValue >= params.minFloat;
            }
            text = params.precisionFloat == 0 ? @(text.doubleValue).stringValue : [@(text.doubleValue) stringValueWithPrecision:params.precisionFloat];
        }else if([key isEqual:_UITextInputCheckDictKeyIDCard]){
            flag = [text matchIdentifyNumber];
        }
        result = result | flag;
        if(params.blockInputEnd){
            params.blockInputEnd(key, &result);
        }
        if(result) break;
    }
    if(!result){
        AudioServicesPlaySystemSound(1305);
    }
    return true;
}
void _pytextinput_shouldchangecharactersinrange_replacementstring(id target, SEL action, id<UITextInput> textinput, NSRange range, NSString * string, BOOL * result){
    *result = [((id<PYChekckTextFieldDelegate>)target) checktextField:textinput shouldChangeCharactersInRange:range replacementString:string];
}
void _pytextinput_shouldendediting(id target, SEL action, id<UITextInput> textinput, BOOL * result){
    *result = [((id<PYChekckTextFieldDelegate>)target) checktextFieldShouldEndEditing:textinput];
}
