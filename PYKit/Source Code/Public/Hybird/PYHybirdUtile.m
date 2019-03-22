//
//  PYHybirdUtile.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/9/7.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYHybirdUtile.h"
#import "PYInvoke.h"


@implementation PYHybirdUtile
/**
 将实体转换层Js对象
 */
+(nonnull NSString *) parseInstanceToJsObject:(nonnull NSObject *) instance name:(nullable NSString *) name{
    
    NSArray<NSDictionary*>* datas = [PYInvoke getInstanceMethodInfosWithClass:[instance class]];
    NSMutableString * jsInterface = [NSMutableString new];
    
    [jsInterface appendFormat:@"var %@ = {\n",name];
    for (NSDictionary * data in datas) {
        NSString * method =  data[@"name"];
        if ([method containsString:@"."]) {
            continue;
        }
        method =  [method stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        [jsInterface appendFormat:@"%@ : function(",method];
        NSNumber * argumentNum =  data[@"argumentNum"];
        NSMutableString * paramsStr = [NSMutableString new];
        for (int index = 0; index < argumentNum.intValue; index++) {
            [paramsStr appendFormat:@"v%d",index];
            if (index != argumentNum.intValue - 1) {
                [paramsStr appendString:@","];
            }
        }
        if (paramsStr.length) {
            [jsInterface appendString:paramsStr];
        }
        [jsInterface appendString:@"){\n"];
        [jsInterface appendString:@"try{\n"];
        [jsInterface appendFormat:@"return window.hybird.call(\"%@\",\"%@\",[%@]);\n",name, method,paramsStr];
        [jsInterface appendString:@"}catch(error){alert(\"Error name: \" + error.name + \"\\n\" + \"Error message: \" + error.message);}\n"];
        [jsInterface appendString:@"},\n"];
    }
    
    [jsInterface appendString:@"endFunctioin:0\n};"];
    
    return jsInterface;
}

/**
 执行来自JS对象的方法
 */
+(nonnull NSDictionary *) invokeInstanceFromJs:(nonnull NSDictionary *) jsDict  interfaceDict:(nonnull NSDictionary *) interfaceDict{
    
    NSNumber * interfaceNumber =  interfaceDict[@"interfacePointer"];
    NSObject * interface;
    if (interfaceNumber) {
        void * interfacePointer = (void *)interfaceNumber.integerValue;
        interface = (__bridge NSObject *)(interfacePointer);
    }
    
    NSString * methodName = jsDict[@"methodName"];
    
    methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
    SEL methodSel = sel_getUid(methodName.UTF8String);
    
    NSMutableDictionary * resultDict = [NSMutableDictionary new];
    if (!interface) {
        [resultDict setObject:@{@"name":@"interface error", @"message":[NSString stringWithFormat:@"the %@ is null", NSStringFromClass(interface.class)]} forKey:@"error"];
    }else if(![interface respondsToSelector:methodSel]){
        [resultDict setObject:@{@"name":@"method error", @"message":[NSString stringWithFormat:@"the %@(%@) is null", NSStringFromClass(interface.class), methodName]} forKey:@"error"];
    }else{
        NSInvocation *invocaton = [PYInvoke startInvoke:interface action:methodSel];
        for (int index = 2; index < invocaton.methodSignature.numberOfArguments; index ++) {
            const char * encode = [invocaton.methodSignature getArgumentTypeAtIndex:index];
            
            id argument = jsDict[@"params"][index - 2];
            
            if(strcasecmp(encode, @encode(id)) == 0){
                void * v = (__bridge void *)(argument);
                [PYInvoke setInvoke:&v index:index invocation:invocaton];
            }else if(strcasecmp(encode, @encode(char *)) == 0){
                if ([argument isKindOfClass:[NSNumber class]]) {
                    argument = ((NSNumber*) argument).stringValue;
                }
                const char * v = ((NSString *) argument).UTF8String;
                [PYInvoke setInvoke:&v index:index invocation:invocaton];
            }else if(strcasecmp(encode, @encode(char)) == 0){
                if ([argument isKindOfClass:[NSNumber class]]) {
                    argument = ((NSNumber*) argument).stringValue;
                }
                char v = [argument charValue];
                [PYInvoke setInvoke:&v index:index invocation:invocaton];
            }else{
                if ([argument isKindOfClass:[NSString class]]) {
                    argument = @(((NSString*) argument).doubleValue);
                }
                if(strcasecmp(encode, @encode(int)) == 0){
                    int v = [argument intValue];
                    [PYInvoke setInvoke:&v index:index invocation:invocaton];
                }else if(strcasecmp(encode, @encode(long)) == 0){
                    long v = [argument longValue];
                    [PYInvoke setInvoke:&v index:index invocation:invocaton];
                }else if(strcasecmp(encode, @encode(long long)) == 0){
                    long long v = [argument longLongValue];
                    [PYInvoke setInvoke:&v index:index invocation:invocaton];
                }else if(strcasecmp(encode, @encode(bool)) == 0){
                    bool v = [argument boolValue];
                    [PYInvoke setInvoke:&v index:index invocation:invocaton];
                }else if(strcasecmp(encode, @encode(float)) == 0){
                    float v = [argument floatValue];
                    [PYInvoke setInvoke:&v index:index invocation:invocaton];
                }else if(strcasecmp(encode, @encode(double)) == 0){
                    double v = [argument doubleValue];
                    [PYInvoke setInvoke:&v index:index invocation:invocaton];
                }else if(strcasecmp(encode, @encode(short)) == 0){
                    short v = [argument shortValue];
                    [PYInvoke setInvoke:&v index:index invocation:invocaton];
                }else{
                    NSAssert(false, @"PYWebView set value type does not support!", self);
                }
            }
        }
        const char * encode = [invocaton.methodSignature methodReturnType];
        
        NSObject * value = nil;
        if(strcasecmp(encode, @encode(int)) == 0){;
            int v;
            [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
            value = @(v);
        }else if(strcasecmp(encode, @encode(long)) == 0){
            long v;
            [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
            value = @(v);
        }else if(strcasecmp(encode, @encode(long long)) == 0){
            long long v;
            [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
            value = @(v);
        }else if(strcasecmp(encode, @encode(bool)) == 0){
            bool v;
            [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
        }else if(strcasecmp(encode, @encode(float)) == 0){
            float v;
            [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
            value = @(v);
        }else if(strcasecmp(encode, @encode(double)) == 0){
            double v;
            [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
            value = @(v);
        }else if(strcasecmp(encode, @encode(short)) == 0){
            short v;
            [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
            value = @(v);
        }else if(strcasecmp(encode, @encode(char)) == 0){
            char v;
            [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
            value = @(v);
        }else if(strcasecmp(encode, @encode(char *)) == 0){
            char * v;
            [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
            value = [NSString stringWithUTF8String:v];
        }else if(strcasecmp(encode, @encode(id)) == 0){
            void * pointer = NULL;
            [PYInvoke excuInvoke:&pointer returnType:nil invocation:invocaton];

            value = CFBridgingRelease(CFBridgingRetain((__bridge id _Nullable)(pointer)));
        }else if(strcasecmp(encode, @encode(void)) == 0){
            [PYInvoke excuInvoke:nil returnType:nil invocation:invocaton];
        }else{
            NSAssert(false, @"PYWebView return value type does not support!", self);
        }
        if (value) {
            resultDict[@"value"] = value;
        }
    }
    return resultDict;
}

@end
