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

#import "STUIViewAddUI.h"
#import "STUIViewAutoLayout.h"
#import "STModelBase.h"
@implementation UIView(ST)

#pragma mark keyvalue
static char keyValueChar='k';
//static char keyValueWeakChar='w';

-(id)key:(NSString *)key
{
    id value=[self.keyValue get:key];
    if(value==nil)
    {
        value=[self.keyValueWeak get:key];
    }
    return value;
}
-(UIView*)key:(NSString *)key valueWeak:(id)value
{
    [self.keyValueWeak set:key value:value];
    return self;
}
-(UIView *)key:(NSString *)key valueIfNil:(id)value
{
    if([self key:key]==nil)
    {
        return [self key:key value:value];
    }
    return self;
}
-(UIView*)key:(NSString *)key value:(id)value
{
    [self.keyValue set:key value:value];
    return self;
}
-(NSMapTable*)keyValueWeak
{
    NSMapTable *kv=[self.keyValue get:@"keyValueWeak"];
    if(kv==nil)
    {
        kv=[NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory];
        [self.keyValue set:@"keyValueWeak" value:kv];
    }
    return kv;
}

-(NSMutableDictionary<NSString*,id>*)keyValue
{
    NSMutableDictionary<NSString*,id> *kv= (NSMutableDictionary<NSString*,id>*)objc_getAssociatedObject(self, &keyValueChar);
    if(kv==nil)
    {
        kv=[NSMutableDictionary<NSString*,id> new];
        objc_setAssociatedObject(self, &keyValueChar, kv,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    if([self isSTView] || [self key:@"isBaseView"])
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
        return stView.Controller;;
        
    }
    return nil;
}
//-(UIWindow*)window
//{
//   return [[UIApplication sharedApplication].delegate window];
//}
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
        dic=[NSDictionary dictionaryWithJson:data];
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
    if([imgOrName isKindOfClass:[NSString class]])
    {
        return STImage(imgOrName);
    }
    else if([imgOrName isKindOfClass:[NSData class]])
    {
        return [UIImage imageWithData:imgOrName];
    }
    else if([imgOrName isKindOfClass:[UIImage class]])
    {
        return imgOrName;
    }
    else if([imgOrName isKindOfClass:[UIImageView class]])
    {
        return ((UIImageView*)imgOrName).image;
    }
    return nil;
}
-(UIFont *)toFont:(NSInteger)px
{
    NSString*name=nil;//IOS默认字体
    if(px>100)
    {
        NSString*value=[@(px) stringValue];
        px=[[value substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger type=[[value substringFromIndex:2] integerValue];//type
        if(type==0)
        {
            return STFontBold(px);
        }
        else if(type==1)
        {
            name=@"SFUIText-Light";
        }
    }
    return [UIView toFont:name size:px];
}
+(UIFont *)toFont:(NSString*)name size:(NSInteger)px
{
    if (name)
    {
        return [UIFont fontWithName:name size:px*Ypt];
    }
    return STFont(px);
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
-(UIView *)backgroundImage:(id)imgOrName
{
    if(!imgOrName)
    {
        self.layer.contents=nil;
    }
    else
    {
        UIImage *img=[self toImage:imgOrName];
        if(self.frame.size.width>0 && self.frame.size.height>0)
        {
            img=[img reSize:self.frame.size];
        }
       // [[self addImageView:nil img:imgOrName] width:1 height:1];
        self.layer.contents=(id)img.CGImage;
    }
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
    self.clipsToBounds=YES;
    self.layer.cornerRadius=self.frame.size.width/2;
    return self;
}
-(UIView*)layerCornerRadius:(CGFloat)px
{
    self.clipsToBounds=YES;
    self.layer.cornerRadius=px*Xpt;
    return self;
}
-(UIView*)layerBorderWidth:(NSInteger)px
{
    return [self layerBorderWidth:px color:nil];
}
-(UIView*)layerBorderWidth:(NSInteger)px color:(id)colorOrHex
{
    self.layer.borderWidth=px*Xpt;
    if(colorOrHex)
    {
        [self layerBorderColor:colorOrHex];
    }
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
-(UIView*)userInteractionEnabled:(BOOL)yesNO
{
    self.userInteractionEnabled=yesNO;
    return self;
}
//!框架自动释放资源（不需要人工调用）
-(void)dispose
{
    @try
    {
        [self removeAllSubViews];
        //清理键值对。
        NSMutableDictionary *dic=self.keyValue;
        if(dic!=nil)
        {
            NSMapTable *kv=[self.keyValue get:@"keyValueWeak"];
            if(kv!=nil)
            {
                [kv removeAllObjects];
                kv=nil;
            }
            [dic removeAllObjects];
            dic=nil;
        }
        [self removeClick];
        [self removeLongPress];
        [self removeDrag];
        //清理事件
        for (UIGestureRecognizer *ges in self.gestureRecognizers) {
            [self removeGestureRecognizer:ges];
        }
       
        //移除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self];//在视图控制器消除时，移除键盘事件的通知
    }
    @catch(NSException*err){}
    
}
//fuck dealloc 方法存在时，会影响导航的后退事件Crash，以下两种情况：1:当前UI有自定义导航按钮时；2:Push两层再回退。
//-(void)dealloc
//{
////    if(self.gestureRecognizers.count>0)
////    {
////        if(self.gestureRecognizers!=nil)
////        {
////            for (NSInteger i=self.gestureRecognizers.count-1; i>=0; i--)
////            {
////                [self removeGestureRecognizer:self.gestureRecognizers[i]];
////            }
////        }
////    }
//    //[self.keyValueWeak removeAllObjects];
//  //  [self.keyValue removeAllObjects];
//
//    NSLog(@"UIView relase -> %@ name:%@", [self class],self.name);
//}
@end
