//
//  PYTextInputCheckParams.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/7/14.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

extern NSString * _Nonnull _UITextInputCheckDictKeyInteger;
extern NSString * _Nonnull _UITextInputCheckDictKeyFloat;
extern NSString * _Nonnull _UITextInputCheckDictKeyMobilePhone;
extern NSString * _Nonnull _UITextInputCheckDictKeyHomePhone;
extern NSString * _Nonnull _UITextInputCheckDictKeyEmail;
extern NSString * _Nonnull _UITextInputCheckDictKeyIDCard;
extern NSString * _Nonnull _UITextInputCheckDictSubKeyIng;
extern NSString * _Nonnull _UITextInputCheckDictSubKeyEnd;

@protocol UITextInputCheckDelegateHookTag <NSObject> @end
@interface _UITextFieldCheckDelegateImp : NSObject<UITextFieldDelegate>@end
@interface _UITextViewCheckDelegateImp : NSObject<UITextViewDelegate>@end

@interface PYTextInputCheckParams : NSObject
kPNSNN NSMutableDictionary * dictMatch;
kPNA kInt64 maxInteger;
kPNA kInt64 minInteger;
kPNA CGFloat maxFloat;
kPNA CGFloat minFloat;
kPNA int precisionFloat;
kPNCNA void (^ blockInputEnd) (NSString * _Nonnull identify, BOOL * _Nonnull checkResult);
-(nullable id) getDelegateWithTextInput:(nonnull id<UITextInput>) textInput;
@end

bool _pytextinputcheck_isenabletype(id<UITextInput> _Nonnull textInput);
NSString * _Nullable _pytexttnputcheck_gettext( id<UITextInput> _Nonnull textInput);
void  _pytexttnputcheck_settext( id<UITextInput> _Nonnull textInput, NSString * _Nullable text);

bool _pyexchangetextInput_shouldchangecharactersinrange_replacementstring(PYTextInputCheckParams * _Nonnull params, id<UITextInput> _Nonnull textInput, NSRange range, NSString * _Nullable string);
bool _pyexchangetextinput_shouldendediting(PYTextInputCheckParams * _Nonnull params, id _Nullable target, SEL _Nullable action, id<UITextInput> _Nullable textInput);
void _pytextinput_shouldchangecharactersinrange_replacementstring(id _Nonnull target, SEL _Nonnull action, id<UITextInput> _Nonnull textinput, NSRange range, NSString * _Nonnull string, BOOL * _Nonnull result);
void _pytextinput_shouldendediting(id _Nonnull target, SEL _Nonnull action, id<UITextInput> _Nonnull textinput, BOOL * _Nonnull result);

