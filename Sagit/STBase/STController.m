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

-(instancetype)init
{
    self=[super init];
    //初始化全局设置，必须要在UI初始之前。
    [self onInit];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
}
-(void)loadUI{
    //获取当前的类名
    NSString* className= NSStringFromClass([self class]);
    NSString* viewClassName=[className replace:@"Controller" with:@"View"];
    Class viewClass=NSClassFromString(viewClassName);
    if(viewClass!=nil)//view
    {
        self.view=self.stView=[[viewClass alloc] initWithController:self];
        [self.stView loadUI];
    }
    else
    {
        self.view=self.stView=[[STView alloc] initWithController:self];//将view换成STView
        [self initUI];
    }
    
}
//空方法（保留给子类复盖）
-(void)loadData
{
    [self initData];
    [self.stView initData];
    
}
//在UI加载之前处理的
-(void)onInit{}
//加载UI时处理的
-(void)initUI{}
//加载UI后处理的
-(void)initData
{
    
}
-(NSMutableDictionary*)UIList
{
    return self.stView.UIList;
}
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



-(void)open:(UIView*)view{
    if(view==nil){return;}
    NSString* name=[view key:@"clickSel"];
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
                NSString*title=[view key:@"leftNavTitle"];
                NSString*imgName=[view key:@"leftNavImage"];
                [self stPush:controller title:title imgName:imgName];
            }
            else
            {
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
    }
}

//项目需要重写时，此方法留给具体项目重写。
- (void)stPush:(UIViewController *)viewController
{
    [self stPush:viewController title:nil imgName:nil];
}
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


#pragma mark - 数据源方法
// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView.source.count;
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell=[UITableViewCell reuseCell:tableView index:indexPath];
    if(tableView.addCell)
    {
        if(tableView.source.count>indexPath.row)
        {
            cell.source=tableView.source[indexPath.row];
        }
        //默认设置
        [cell width:1 height:88];//IOS的默认高度
        //cell.
       // UITableViewCellStyleDefault
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右边有小箭头
        cell.selectionStyle=UITableViewCellSeparatorStyleNone;//选中无状态
        tableView.addCell(cell,indexPath);
    }
    
    return cell;
}
//tableview 加载完成可以调用的方法--因为tableview的cell高度不定，所以在加载完成以后重新计算高度
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
    {
        //end of loading
        if(tableView.autoHeight)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView height:(tableView.contentSize.height-1)*Ypx];//去掉最后一条线的高度
            });
        }
    }
}
#pragma mark - 代理方法
/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"STTableCell"];
    if(cell!=nil)
    {
        return cell.frame.size.height;
    }
    return 88*Ypt;
}
//这个方法存在时：estimatedHeightForRowAtIndexPath=>cellForRowAtIndexPath=>heightForRowAtIndexPath
//这方法不存在时：heightForRowAtIndexPath=》cellForRowAtIndexPath 这样会死循环
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88*Ypt;
}
// 添加每组的组头
//- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableView.tableHeaderView.frame.size.height;
}
// 返回每组的组尾
//- (UIView *)tableView:(nonnull UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return tableView.tableFooterView.frame.size.height;
}
// 选中某行cell时会调用
//- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    // NSLog(@"选中didSelectRowAtIndexPath row = %ld", indexPath.row);
//}
////
////// 取消选中某行cell会调用 (当我选中第0行的时候，如果现在要改为选中第1行 - 》会先取消选中第0行，然后调用选中第1行的操作)
//- (void)tableView:(nonnull UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//
//    // NSLog(@"取消选中 didDeselectRowAtIndexPath row = %ld ", indexPath.row);
//}
@end
