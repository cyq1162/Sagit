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
static char clickEventChar='e';
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
#pragma mark 扩展系统事件
-(UIView*)click:(NSString *)event
{
    return [self click:event target:nil];
}
-(UIView*)click:(NSString *)event target:(UIViewController*)target
{
    if(![NSString isNilOrEmpty:event])
    {
//        if(self.STController==nil)
//        {
//            //延时加载绑定事件（考虑在子控件的情况）
//            NSMutableDictionary *clicks= [self.baseView key:@"clicks"];
//            if(clicks==nil)
//            {
//                clicks=[NSMutableDictionary new];
//                [self.baseView key:@"clicks" value:clicks];
//            }
//            event=[[event append:@"-"] append:[@(clicks.count) stringValue]];
//            [clicks set:event value:self];//先存档，在加载STView再检测存档重新绑定
//            return self;
//        }
        if(target==nil)
        {
            target=self.STController;
        }
        SEL sel=[self getSel:event controller:target];
        if(sel!=nil)
        {
            UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
            if(self.name==nil)
            {
                [self name:event];
            }
            else if(![self.name isEqualToString:event])
            {
                [self key:@"click" value:event];
                //click.accessibilityValue=event;//借一个属性用用。
            }
            [self addGestureRecognizer:click];
        }
    }
    return self;
}
-(UIView*)addClick:(onClick)block
{
    if(block!=nil)
    {
        self.userInteractionEnabled=YES;
        objc_setAssociatedObject(self, &clickEventChar, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickEvent:)];
        [self addGestureRecognizer:click];
    }
    return self;
}
-(void)onClickEvent:(UITapGestureRecognizer *)gesture {
    onClick clickEvent = (onClick)objc_getAssociatedObject(self, &clickEventChar);
    if (clickEvent) {
        clickEvent(gesture.view);
    }
}
-(SEL*)getSel:(NSString*)event controller:(UIViewController*)controller
{
    if(controller==nil)
    {
        controller=self.STController;
    }
    //STController *controller=self.STController;
    if(controller==nil)
    {
        return nil;
    }
    SEL sel=nil;
    BOOL isEvent=NO;
    if(event!=nil)
    {
        sel=NSSelectorFromString(event);
        isEvent=[controller respondsToSelector:sel];
        if(!isEvent && ![event endWith:@"Click"] && ![event endWith:@":"] && ![event endWith:@"Controller"])
        {
            sel=NSSelectorFromString([event append:@":"]);
            isEvent=[controller respondsToSelector:sel];
            if(!isEvent)
            {
                sel=NSSelectorFromString([event append:@"Click"]);
                isEvent=[controller respondsToSelector:sel];
                if(!isEvent)
                {
                    sel=NSSelectorFromString([event append:@"Click:"]);
                    isEvent=[controller respondsToSelector:sel];
                    if(!isEvent)
                    {
                        Class class= NSClassFromString([event append:@"Controller"]);
                        if(class!=nil)
                        {
                            sel=NSSelectorFromString(@"open:");
                            isEvent=YES;
                        }
                        
                    }
                }
            }
        }
    }
    if(isEvent)
    {
        self.userInteractionEnabled=YES;
        return sel;
    }
    return nil;
}
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
#pragma mark 扩展系统属性
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
