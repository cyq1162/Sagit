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
#import "STDictionary.h"
#import "STColor.h"

#import "STUITextField.h"
#import "STUITextView.h"
#import "STUILabel.h"
#import "STUIImageView.h"

@implementation UIView(ST)

#pragma mark keyvalue
static char keyValueChar='k';
//static char keyValueWeakChar='w';
-(id)key:(NSString *)key
{
    //检测需要弱引用的拦截
//    if([key endWith:@"Controleller"] || [key endWith:@"Target"])
//    {
////        if(self.stController!=nil)
////        {
////            id value=[self.stController.keyValue get:key];
////            return value;
////        }
//        return [self.keyValueWeak get:key];
//    }
    return [self.keyValue get:key];
}
-(UIView*)key:(NSString *)key value:(id)value
{
    //检测需要弱引用的拦截
//    if([key endWith:@"Controleller"] || [key endWith:@"Target"])
//    {
////        if(self.stController!=nil)
////        {
////            [self.stController.keyValue set:key value:value];
////            return self;
////        }
//        [self.keyValueWeak set:key value:value];
//        return self;
//    }
    [self.keyValue set:key value:value];
    return self;
}
//-(NSMapTable<NSString*,id>*)keyValueWeak
//{
//
//    NSMapTable<NSString*,id> *kv= (NSMapTable<NSString*,id>*)objc_getAssociatedObject(self, &keyValueWeakChar);
//    if(kv==nil)
//    {
//        kv=[NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory];
//        objc_setAssociatedObject(self, &keyValueWeakChar, kv,OBJC_ASSOCIATION_RETAIN);
//    }
//    return kv;
//}

-(NSMutableDictionary<NSString*,id>*)keyValue
{

    NSMutableDictionary<NSString*,id> *kv= (NSMutableDictionary<NSString*,id>*)objc_getAssociatedObject(self, &keyValueChar);
    if(kv==nil)
    {
        kv=[NSMutableDictionary<NSString*,id> new];
        objc_setAssociatedObject(self, &keyValueChar, kv,OBJC_ASSOCIATION_RETAIN);
    }
    return kv;
}
// Name
- (NSString*)name{
    return [self key:@"name"];
}
- (UIView*)name:(NSString *)name
{
    return [self key:@"name" value:name];
}

-(BOOL)isSTView
{
    return[self isKindOfClass:[STView class]];
}

//-(BOOL)isOnSTView
//{
//    return self.superview!=nil && [self.superview isSTView];
//}

-(UIView*)baseView
{
    //为什么用这个之后就出事了呢？搞了半天才发现，原来布局是sagit开头，sagit是指向self.baseView，这样在子控件的时候，
    //都全跑根目录去布局，自然就出事了，所以baseView需要以每个子控件的根为根。
//    if(self.STController!=nil)
//    {
//        UIView * abc=self.STController.stView;
//        return self.STController.stView;
//
//    }
    if([self isSTView])
    {
        return self;
    }
    
    UIView *superView=[self superview];
    if(superView!=nil)
    {
        //Controller.view，在不同的环境，会被挂载到不同的视图下，导致superView不一定是UIWindow
        //这会导致在正常情况下，是在UIWindows下的baseView处理的数据，到了异步请求时，再从baseView拿数据，却因superView变了而拿不到数据。
        //所以，如果是STView下会正常，但没继承STView的时候...
        if([superView isKindOfClass:[UIWindow class]])
        {
            return self;
        }
        return [superView baseView];
    }
    
    superView=[self key:@"baseView"];//对于TableCell这一类的，在创建时先指定其指向的baseView)
    if(superView!=nil)
    {
        return superView;
        
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
        return [self key:@"stView"];//对于TableCell这一类的，在创建时先指定其指向的stView
    }
}
-(STController*)stController
{
    STView *stView=[self stView];
    
    if(stView!=nil)
    {
        STController *controller=stView.Controller;
//        STWeakObj(controller)
//        return controllerWeak;
        return controller;
        
    }
    return nil;
}
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
        [((UILabel*)self) text:value];
    }
    else if([self isMemberOfClass:[UIButton class]])
    {
        ((UIButton*)self).titleLabel.text=value;
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
        return [((UIImageView*)self) url];
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
-(UIView*)alpha:(CGFloat)value
{
    self.alpha=value;
    return self;
}
-(UIView*)layerCornerRadiusToHalf
{
    self.layer.cornerRadius=self.frame.size.width/2;
    return self;
}
-(UIView*)layerCornerRadius:(CGFloat)px
{
    self.layer.cornerRadius=px*Xpt;
    return self;
}
-(UIView*)layerBorderWidth:(NSInteger)px
{
    self.layer.borderWidth=px*Xpt;
    return self;
}
-(UIView*)layerBorderColor:(id)colorOrHex{
    self.layer.borderColor=[[self toColor:colorOrHex] CGColor];
    return self;
}
-(UIView*)corner:(BOOL)yesNo
{
    [self clipsToBounds:yesNo];
    if(yesNo)
    {
        [self layerCornerRadiusToHalf];
    }
    else
    {
        self.layer.cornerRadius=0;
    }
    return self;
}
-(UIView*)contentMode:(UIViewContentMode)contentMode
{
    self.contentMode=contentMode;
    return self;
}
#pragma mark 扩展导航栏事件
-(BOOL)needNavBar
{
    if([self key:@"needNavBar"]!=nil)
    {
        return [[self key:@"needNavBar"] isEqualToString:@"1"];
    }
    if(self.stController!=nil && self.stController.navigationController!=nil)
    {
        return !self.stController.navigationController.navigationBar.hidden;
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
    if(setNavBar && self.stController!=nil && self.stController.navigationController!=nil)
    {
        self.stController.navigationController.navigationBar.hidden=!yesNo;
    }
    return self;
}

-(BOOL)needTabBar
{
    if([self key:@"needTabBar"]!=nil)
    {
        return [[self key:@"needTabBar"] isEqualToString:@"1"];
    }
    if(self.stController!=nil && self.stController.tabBarController!=nil)
    {
        return !self.stController.tabBarController.tabBar.hidden;
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
    if(setTabBar && self.stController!=nil && self.stController.tabBarController!=nil)
    {
        self.stController.tabBarController.tabBar.hidden=!yesNo;
    }
    return self;
}
-(void)dealloc
{
    if(self.gestureRecognizers.count>0)
    {
        if(self.gestureRecognizers!=nil)
        {
            for (NSInteger i=self.gestureRecognizers.count-1; i>=0; i--)
            {
                [self removeGestureRecognizer:self.gestureRecognizers[i]];
            }
        }
    }
    //[self.keyValueWeak removeAllObjects];
    [self.keyValue removeAllObjects];
    NSLog(@"%@ ->UIView relase", [self class]);
}
@end
