//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
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
-(UIView *)statusBar
{
    if (@available(iOS 13.0, *)) {
        UIWindow *win=self.keyWindow;
        UIView *statusView=[win key:@"customeStatus"];
        if(!statusView)
        {
            statusView=[[[UIView alloc] initWithFrame:STEmptyRect] width:STScreenWidthPx height:STStatusHeightPx];
            [win key:@"customeStatus" value:statusView];
            [win addSubview:statusView];
        }
        if(!Sagit.MsgBox.isDialoging)
        {
            [win bringSubviewToFront:statusView];
        }
        return statusView;
        
    }
    else{
        UIWindow *win=[UIApplication.sharedApplication valueForKey:@"statusBarWindow"];
        if(win && win.subviews.count>0)
        {
            //UIView *view=[win valueForKey:@"statusBar"];
            return win.subviews[0];
        }
        
        return nil;
    }
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
    //优先级1
    UIView *superView=[self key:@"baseView"];//对于TableCell这一类的，在创建时先指定其指向的baseView)
    if(superView!=nil)
    {
        return superView;
    }
    //优先级2
    if(Sagit.MsgBox.isDialoging)
    {
        return Sagit.MsgBox.dialogController.view;
    }
    //优先级3
    if([self isSTView] || [self key:@"isBaseView"])
    {
        return self;
    }
    //优先级4
    superView=[self superview];
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
-(UIWindow*)keyWindow
{
    return [UIWindow mainWindow];
}

#pragma mark 扩展系统属性

-(UIView*)hidden:(BOOL)yesNo
{
    [self setHidden:yesNo];
    return self;
}
-(UIView*)backgroundColor:(id)colorOrHex{
    self.backgroundColor=[UIColor toColor:colorOrHex];
    return self;
}
-(UIImage*)backgroundImage
{
    return [self key:@"backgroundImage"];
}
-(UIView *)backgroundImage:(id)imgOrName
{
    if(!imgOrName)
    {
        self.layer.contents=nil;
        [self key:@"backgroundImage" value:nil];
    }
    else
    {
        UIImage *img=[UIImage toImage:imgOrName];
        if(self.frame.size.width>0 && self.frame.size.height>0)
        {
            img=[img reSize:self.frame.size];
        }
        [self key:@"backgroundImage" value:img];
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
-(UIView*)layerCornerRadius:(CGFloat)px byRoundingCorners:(UIRectCorner)byRoundingCorners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:byRoundingCorners cornerRadii:STSizeMake(px, px)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    return self;;
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
    self.layer.borderColor=[[UIColor toColor:colorOrHex] CGColor];
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
-(UIView *)clone
{
    NSData * archiveData = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
}
-(UITextField *)bottomLine:(id)colorOrHex
{
    return [self bottomLine:colorOrHex  height:2];
}
-(UITextField *)bottomLine:(id)colorOrHex height:(NSInteger)px
{
    return [[[self addLine:nil color:colorOrHex] width:1 height:px] relate:Bottom v:-px-8];
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
        if(self.name!=nil)
        {
            [self.UIList remove:self.name];
        }
        [self removeClick];
        [self removeDbClick];
        [self removeLongPress];
        [self removeDrag];
        [self removeSlide];
        [self removeScreenLeftEdgeSlide];
        [self removeScreenRightEdgeSlide];
        [self removeTimer];
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
