//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//
#import "STDefineUI.h"
#import "STUIView.h"
#import <objc/runtime.h>


@implementation UIView(ST)

static char keyValueChar='k';

// Name
- (NSString*)name{
    return [self key:@"name"];
}
- (UIView*)name:(NSString *)name
{
    return [self key:@"name" value:name];
}


-(id)key:(NSString *)key
{
    return self.keyValue[key];
}
-(UIView*)key:(NSString *)key value:(id)value
{
    if(![self.keyValue isKindOfClass:[NSMutableDictionary class]])
    {
        NSMutableDictionary<NSString*,id> *kv=[NSMutableDictionary<NSString*,id> new];
        for (NSString *key in self.keyValue.allKeys) {
            [kv set:key value:self.keyValue[key]];
        }
        [self keyValue:nil];
        [self keyValue:kv];
    }
    [self.keyValue set:key value:value];
    return self;
}
-(NSMutableDictionary<NSString*,id>*)keyValue
{
    
    NSMutableDictionary<NSString*,id> *kv= (NSMutableDictionary<NSString*,id>*)objc_getAssociatedObject(self, &keyValueChar);
    if(kv==nil)
    {
        kv=[NSMutableDictionary<NSString*,id> new];
        [self setKeyValue:kv];
    }
    return kv;
}
-(UIView*)keyValue:(NSMutableDictionary<NSString*,id>*)keyValue
{
    [self setKeyValue:keyValue];
    return self;
}
-(UIView*)setKeyValue:(NSMutableDictionary<NSString*,id>*)keyValue
{
    objc_setAssociatedObject(self, &keyValueChar, keyValue,OBJC_ASSOCIATION_RETAIN);
    return self;
}


-(BOOL)isSTView
{
    return[self isKindOfClass:[STView class]];
}
-(BOOL)isOnSTView
{
    return self.superview!=nil && [self.superview isSTView];
}
-(UIView*)baseView
{
    UIView *view=[self superview];
    if(view!=nil)
    {
        return [view baseView];
    }
    return self;
}
-(STView*)stView
{
    if([self isSTView])
    {
        return (STView*)self;
    }
    else
    {
        UIView *view=[self superview];
        if(view!=nil)
        {
            return [view stView];
        }
        return nil;
    }
}
-(STController*)STController
{
    STView *stView=[self stView];
    if(stView!=nil){return stView.Controller;}
    return nil;
}
-(UIView*)stValue:(NSString*)value
{
    if([self isMemberOfClass:[UITextField class]])
    {
        ((UITextField*)self).text=value;
    }
    else if([self isMemberOfClass:[UITextView class]])
    {
        ((UITextView*)self).text=value;
    }
    else if([self isMemberOfClass:[UILabel class]])
    {
        ((UILabel*)self).text=value;
    }
    else if([self isMemberOfClass:[UIButton class]])
    {
        ((UIButton*)self).titleLabel.text=value;
    }
    //    else if([self isMemberOfClass:[UISegmentedControl class]])
    //    {
    //        ((UISegmentedControl*)self).selectedSegmentIndex=[value intValue];
    //    }
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
    return  nil;
}
#pragma mark 共用接口
//子类重写
-(void)reloadData{}
-(void)reloadData:(NSString*)para{}

#pragma mark 扩展系统属性

-(UIColor*)toColor:(id)hexOrColor
{
    return [UIView toColor:hexOrColor];
}
+(UIColor*)toColor:(id)hexOrColor
{
    if([hexOrColor isKindOfClass:([NSString class])])
    {
        return STColor(hexOrColor);
    }
    return (UIColor*)hexOrColor;
}
-(UIImage*)toImage:(id)imgOrName
{
    return [UIView toImage:imgOrName];
}
+(UIImage*)toImage:(id)imgOrName
{
    if([imgOrName isKindOfClass:[NSData class]])
    {
        return [UIImage imageWithData:imgOrName];
    }
    else if([imgOrName isKindOfClass:[UIImage class]])
    {
        return imgOrName;
    }
    return STImage(imgOrName);
}

-(UIView*)frame:(CGRect)frame
{
    frame.origin.x=roundf(frame.origin.x);
    frame.origin.y=roundf(frame.origin.y);
    frame.size.width=roundf(frame.size.width);
    frame.size.height=roundf(frame.size.height);
    self.frame=frame;
    return self;
}
-(UIView*)hidden:(BOOL)yesNo
{
    [self setHidden:yesNo];
    return self;
}
-(UIView*)backgroundColor:(id)colorOrHex{
    self.backgroundColor=[self toColor:colorOrHex];
    return self;
}
-(UIView*)clipsToBounds:(BOOL)value
{
    self.clipsToBounds=value;
    return self;
}
-(UIView*)tag:(NSInteger)tag
{
    self.tag=tag;
    return self;
}
-(UIView*)alpha:(NSInteger)value
{
    self.alpha=value;
    return self;
}
-(UIButton*)layerCornerRadiusToHalf
{
    self.layer.cornerRadius=self.frame.size.width/2;
    return self;
}

#pragma mark 扩展导航栏事件
-(BOOL)needNavBar
{
    if(self.keyValue[@"needNavBar"]!=nil)
    {
        return [self.keyValue[@"needNavBar"] isEqualToString:@"1"];
    }
    if(self.STController!=nil && self.STController.navigationController!=nil)
    {
        return !self.STController.navigationController.navigationBar.hidden;
    }
    return NO;
}
-(UIView*)needNavBar:(BOOL)yesNo
{
    return [self needNavBar:yesNo setNavBar:NO];
}
-(UIView*)needNavBar:(BOOL)yesNo setNavBar:(BOOL)setNavBar
{
    [self.keyValue set:@"needNavBar" value:yesNo?@"1":@"0"];
    if(setNavBar && self.STController!=nil && self.STController.navigationController!=nil)
    {
        self.STController.navigationController.navigationBar.hidden=!yesNo;
    }
    return self;
}

-(BOOL)needTabBar
{
    if(self.keyValue[@"needTabBar"]!=nil)
    {
        return [self.keyValue[@"needTabBar"] isEqualToString:@"1"];
    }
    if(self.STController!=nil && self.STController.tabBarController!=nil)
    {
        return !self.STController.tabBarController.tabBar.hidden;
    }
    return NO;
}
-(UIView*)needTabBar:(BOOL)yesNo
{
    return [self needTabBar:yesNo setTabBar:NO];
}
-(UIView*)needTabBar:(BOOL)yesNo setTabBar:(BOOL)setTabBar
{
    [self.keyValue set:@"needTabBar" value:yesNo?@"1":@"0"];
    if(setTabBar && self.STController!=nil && self.STController.tabBarController!=nil)
    {
        self.STController.tabBarController.tabBar.hidden=!yesNo;
    }
    return self;
}
@end
