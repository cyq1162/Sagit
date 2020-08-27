//
//  STUIViewValue.m
//  STITLink
//
//  Created by 陈裕强 on 2020/8/27.
//  Copyright © 2020 随天科技. All rights reserved.
//

#import "STUIViewValue.h"

@implementation UIView (STUIViewValue)
-(UIView*)stValue:(NSString*)value
{
    if([self isMemberOfClass:[UITextField class]])
    {
        [((UITextField*)self) text:value];
    }
    else if([self isMemberOfClass:[UITextView class]])
    {
        [((UITextView*)self) text:value];
    }
    else if([self isMemberOfClass:[UILabel class]])
    {
        UILabel*label=(UILabel*)self;
        NSInteger width=label.stWidth;
        [label text:value];
        [label sizeToFit];
        if(label.stWidth<width)
        {
            [label width:width];//还原宽度
        }
    }
    else if([self isMemberOfClass:[UIButton class]])
    {
        [((UIButton*)self) title:value];
    }
    else if([self isMemberOfClass:[UIImageView class]])
    {
        [((UIImageView*)self) url:value];
    }
    else if([self isMemberOfClass:[UISlider class]])
    {
        ((UISlider*)self).value=[value floatValue];
    }
    else if([self isMemberOfClass:[UISwitch class]])
    {
        [((UISwitch*)self) setOn:[value boolValue]];
    }
    else if([self isMemberOfClass:[UIProgressView class]])
    {
        ((UIProgressView*)self).progress=[value floatValue];
    }
    else if([self isMemberOfClass:[UIStepper class]])
    {
        ((UIStepper*)self).value=[value doubleValue];
    }
    return self;
}
-(NSString*)stValue
{
    if([self isMemberOfClass:[UITextField class]])
    {
        return ((UITextField*)self).text;
    }
    else if([self isMemberOfClass:[UITextView class]])
    {
        return ((UITextView*)self).text;
    }
    else if([self isMemberOfClass:[UILabel class]])
    {
        return ((UILabel*)self).text;
    }
    else if([self isMemberOfClass:[UIButton class]])
    {
        return ((UIButton*)self).currentTitle;
    }
    else if([self isMemberOfClass:[UISegmentedControl class]])
    {
        return [@(((UISegmentedControl*)self).selectedSegmentIndex)stringValue];
    }
    else if([self isMemberOfClass:[UISlider class]])
    {
        return [@(((UISlider*)self).value)stringValue];
    }
    else if([self isMemberOfClass:[UISwitch class]])
    {
        return ((UISwitch*)self).isOn?@"1":@"0";
    }
    else if([self isMemberOfClass:[UIProgressView class]])
    {
        return [@(((UIProgressView*)self).progress) stringValue];
    }
    else if([self isMemberOfClass:[UIStepper class]])
    {
        return [@(((UIStepper*)self).value) stringValue];
    }
    else if([self isMemberOfClass:[UIImageView class]])
    {
        UIImageView *view=self.asImageView;
        NSString *vc= view.VerifyCode;
        if(vc==nil)
        {
            return view.url;
        }
    }
    return  nil;
}
-(NSString *)selectText
{
    return [self key:@"selectText"];
}
-(UIView *)selectText:(NSString *)text
{
    [self key:@"selectText" value:text];
    return self;
}
-(NSString *)selectValue
{
    return [self key:@"selectValue"];
}
-(UIView *)selectValue:(NSString *)value
{
    [self key:@"selectValue" value:value];
    return self;
}
#pragma mark 共用接口
//子类重写
-(void)reloadData{}
-(void)reloadData:(NSString*)para{}
-(void)setToAll:(id)data
{
    [self setToAll:data toChild:NO];
}
-(void)setToAll:(id)data toChild:(BOOL)toChild
{
    NSDictionary *dic;
    if([data isKindOfClass:[NSDictionary class]])
    {
        dic=data;
    }
    else if([data isKindOfClass:[NSString class]])
    {
        dic=[NSDictionary initWithJsonOrEntity:data];
    }
    else if([data isKindOfClass:[STModelBase class]])
    {
        dic=[data toDictionary];
    }
    if(dic==nil){return;}
    for (NSString*key in dic) {
        
        UIView *ui=[self.UIList get:key];
        if(ui!=nil)
        {
            id value=dic[key];
            
            if(value!=nil && [value isKindOfClass:[NSNumber class]])
            {
                NSString *text=dic[[key append:@"Text"]];//约定XXXText为XXX的格式化值
                if(text)
                {
                    [ui selectValue:value];//把值设置给selectValue，避免没选择就直接提交的情况。
                    value=text;
                }
                else
                {
                    value=[((NSNumber*)value) stringValue];
                }
            }
            [ui stValue:value];
        }
    }
    if(toChild)
    {
        //触发子控件事件
        for (NSString *key in self.UIList)
        {
            UIView *view=[self.UIList get:key];
            if([view isKindOfClass:[STView class]])
            {
                [view setToAll:dic toChild:toChild];
            }
        }
    }
}
-(NSMutableDictionary *)formData
{
    return [self formData:nil];
}
//!获取当前窗体的表单数据[如果是下拉，则取SelectValue]
-(NSMutableDictionary *)formData:(id)superView
{
    NSMutableDictionary *formData=[NSMutableDictionary new];
    for (NSString*key in self.UIList) {
        UIView *ui=[self.UIList get:key];
        if([ui isFormUI] && (superView==nil || ui.superview==superView))
        {
            NSString *value=ui.selectValue;
            if(value==nil)
            {
                value=ui.stValue;
            }
            [formData set:key value:value];
        }
    }
    return formData;
}

#pragma mark 数据校验
-(UIView *)require:(BOOL)yesNo
{
    return [self require:yesNo regex:nil tipName:nil];
}
-(UIView *)require:(BOOL)yesNo regex:(NSString *)regex
{
    return [self require:yesNo regex:regex tipName:nil];
}
-(UIView *)require:(BOOL)yesNo regex:(NSString *)regex tipName:(NSString *)tipName
{
    [self key:@"require" value:@(yesNo)];
    [self key:@"regex" value:regex];
    [self key:@"tipName" value:tipName];
    return self;
}
-(UIView *)requireGroup:(NSString *)name
{
    [self key:@"requireGroup" value:name];
    return self;
}

#pragma mark 触发数据校验
-(UIView *)requireBeforeClick:(BOOL)yesNo
{
    [self key:@"requireBeforeClick" value:@(yesNo)];
    return self;
}
-(UIView *)requireTipLabel:(id)nameOrLabel
{
    [self key:@"requireTipLabel" value:nameOrLabel];
    return self;
}
-(BOOL)exeRequire
{
    STController *stc=self.stController;
    if(stc==nil)
    {
        [Sagit.MsgBox prompt:@"this view's controller is not STController."];
        return NO;
    }
    NSString *groupName=[self key:@"requireGroup"];
    for (NSString*key in self.UIList.keys) {
        UIView *ui=[self.UIList get:key];
        if([ui isFormUI])
        {
            NSNumber *require=[ui key:@"require"];
            if(require!=nil)
            {
                BOOL isGo=YES;
                if(groupName!=nil)
                {
                    isGo=NO;
                    NSString *uiGroup=[ui key:@"requireGroup"];
                    if(uiGroup!=nil)
                    {
                        NSArray *names=[groupName split:@","];
                        for (int i=0; i<names.count; i++) {
                            if([names[i] isEqual: uiGroup])
                            {
                                isGo=YES;
                                break;
                            }
                        }
                    }
                }
                if(isGo)
                {
                    NSString*regex= [ui key:@"regex"];
                    NSString*tipName= [ui key:@"tipName"];
                    if(tipName==nil)
                    {
                        if([ui isKindOfClass:[UITextField class]])
                        {
                            tipName=ui.asTextField.placeholder;
                        }
                        else if([ui isKindOfClass:[UITextView class]])
                        {
                            tipName=ui.asTextView.placeholder;
                        }
                        if([NSString isNilOrEmpty:tipName])
                        {
                            tipName=ui.name;
                        }
                    }
                    NSString *value=ui.selectValue;
                    if(value==nil)
                    {
                        value=ui.stValue;
                    }
                    if(![stc isMatch:tipName value:value regex:regex require:require])
                    {
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}
@end
