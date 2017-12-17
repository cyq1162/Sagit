//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "STController.h"
#import "STView.h"
#import "STCategory.h"
#import <objc/runtime.h>

@interface STController()
@end

@implementation STController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_data=[NSMutableDictionary new];
    //获取当前的类名
    NSString* className= NSStringFromClass([self class]);
    NSString* viewClassName=[className replace:@"Controller" with:@"View"];
    Class viewClass=NSClassFromString(viewClassName);
    if(viewClass!=nil)//view
    {
        self.view=self.stView=[[viewClass alloc] initWithController:self];
        [self.stView initView];
    }
    else
    {
        self.view=[[STView alloc] initWithController:self];//将view换成STView
        [self initUI];
    }
}
//空方法（保留给子类复盖）
-(void)initUI{}
-(STMessageBox *)box
{
    if(_box==nil)
    {
        _box=[STMessageBox new];
    }
    return _box;
}
-(STHttp *)http
{
    if(_http==nil)
    {
        _http=[[STHttp alloc]init:self.box];//不用单例，延时加载
    }
    return _http;
}
-(BOOL)isMatch:(NSString*)tipMsg v:(NSString*)value
{
    return [self isMatch:tipMsg v:value regex:nil];
}
-(BOOL)isMatch:(NSString*)tipMsg uiName:(NSString*)name
{
    return [self isMatch:tipMsg uiName:name regex:nil];
}
-(BOOL)isMatch:(NSString*)tipMsg uiName:(NSString*)name regex:(NSString*)pattern
{
    return [self isMatch:tipMsg v:[self stValue:name] regex:pattern];
}
-(BOOL)isMatch:(NSString*)tipMsg v:(NSString*)value regex:(NSString*)pattern
{
    if([NSString isNilOrEmpty:tipMsg]){return NO;}
        
    NSArray<NSString*> *items=[tipMsg split:@","];
    NSString *tip=items.firstObject;
    if([NSString isNilOrEmpty:value])
    {
        [self.box prompt:[tip append:@"不能为空!"]];
        return NO;
    }
    else if(pattern!=nil && ![pattern isEqualToString:@""])
    {
        NSPredicate *match = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        if(match)
        {
            if(![match evaluateWithObject:value])
            {
                if(items.count==1)
                {
                    [self.box prompt:[tip append:@"格式错误!"]];
                }
                else
                {
                    [self.box prompt:[tipMsg replace:[tip append:@","] with:tip]];
                }
                return NO;
            }
        }
        match=nil;
    }
    return YES;
}
-(BOOL)isMatch:(NSString*)tipMsg isMatch:(BOOL)result
{
    if(!result)
    {
        [self.box prompt:tipMsg];
    }
    return result;
}
//-(NSString *)data:(NSString *)key{
//    return _data[key];
//}
//-(void)setData:(NSString *)key v:(NSString *)value{
//    [_data setObject:value forKey:key];
//}
-(void)stValue:(NSString*)name value:(NSString *)value
{
    UIView *ui=self.UIList[name];
    if(ui!=nil)
    {
        [ui stValue:value];
    }
}
//get set ui view....
-(NSString*)stValue:(NSString*)name
{
    UIView *ui=self.UIList[name];
    if(ui!=nil)
    {
        return ui.stValue;
    }
    return nil;
}
-(void)loadData:(NSDictionary*)data{[self.stView loadData:data];}
-(NSMutableDictionary*)formData{return [self.stView formData:nil];}
-(NSMutableDictionary*)formData:(id)superView{return [self.stView formData:superView];}



-(void)open:(UITapGestureRecognizer*)recognizer{
    NSString* name=recognizer.accessibilityValue;
    if(name==nil)
    {
        name=recognizer.view.name;
    }
    if(name!=nil)
    {
        
        if(![name hasSuffix:@"Controller"])
        {
            name=[name append:@"Controller"];
        }
        Class class=NSClassFromString(name);
        if(class!=nil)
        {
            STController *controller=[class new];
            if(self.navigationController!=nil)
            {
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
    }
    

}

-(void)asRoot:(RootViewControllerType)rootViewControllerType{
    
    UIViewController *controller=self;
    if(rootViewControllerType==RootViewNavigationType)
    {
        controller = [[UINavigationController alloc]initWithRootViewController:self];
    }
    [self setRoot:controller];
}
//+(void)setRoot:(UIViewController *)rootController{
//
//    [UIApplication sharedApplication].keyWindow.rootViewController = rootController;
////    AppDelegate *delegate= (AppDelegate*)[UIApplication sharedApplication].delegate;
////    delegate.window.rootViewController=rootController;
//
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.maxLength>0 && range.location >=textField.maxLength) {
        return NO;
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.maxLength>0 && range.location >=textView.maxLength) {
        return NO;
    }
    return YES;
}
-(void)dealloc
{
    _http=nil;
    _box=nil;
}


@end
