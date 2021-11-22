//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
#import <UIKit/UIKit.h>
#import "STController.h"
#import "STView.h"
#import "STCategory.h"
#import <objc/runtime.h>
#import "STDefineFunc.h"
#import "STDefineUI.h"
#import "STSagit.h"
#import "STLayoutTracer.h"
@implementation STController

#pragma mark ios 13.6 不能用扩展属性 处理的。
// 兼容 ios 13.6 弹新窗兼容 (13.6不能用扩展属性)
- (UIModalPresentationStyle)modalPresentationStyle{
    return UIModalPresentationFullScreen;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    NSNumber *value=[self key:@"supportedInterfaceOrientations"];
    if(value==nil)
    {
        return Sagit.Define.DefaultOrientationMask;
    }
    return (UIInterfaceOrientationMask)value.intValue;
}
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    NSNumber *value=[self key:@"statusBarStyle"];//看局部优先。
    UIStatusBarStyle style=UIStatusBarStyleDefault;
    if(value!=nil)
    {
        style= (UIStatusBarStyle)value.intValue;
    }
    else
    {
        value=[self.keyWindow key:@"statusBarStyle"];//全局
        if(value!=nil)
        {
            style= (UIStatusBarStyle)value.intValue;
        }
    }
    
    if (@available(iOS 13.0, *)) {
        return style;
    }
    else if(style==UIStatusBarStyleDarkContent)
    {
        return UIStatusBarStyleDefault;
    }
    
    return style;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return ![self needStatusBar];
}

#pragma mark 屏幕旋转
-(void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)orientation
{
    [self key:@"supportedInterfaceOrientations" value:@(orientation)];
    [self key:@"supportedInterfaceOrientationsBackup" value:@(orientation)];
}

//!用于设置默认的显示方向。
-(void)setInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    //独立设置，旋转太快，避免冲突。
    NSNumber *backTo=[self key:@"supportedInterfaceOrientationsBackup"];
    if(backTo==nil)
    {
        backTo=@(self.supportedInterfaceOrientations);
        [self key:@"supportedInterfaceOrientationsBackup" value:backTo];
    }
    [self key:@"supportedInterfaceOrientations" value:@(1<<orientation)];
    [Sagit delayExecute:3 onMainThread:YES block:^{
        [self setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)backTo.intValue];//还原。
    }];
}


-(instancetype)init
{
    self=[super init];
    //初始化全局设置，必须要在UI初始之前。
    [self onInit];

    return self;
}
-(void)initView{
    //获取当前的类名
    NSString* className= NSStringFromClass([self class]);
    NSString* viewClassName=[className replace:@"Controller" with:@"View"];
    Class viewClass=NSClassFromString(viewClassName);
    if(viewClass!=nil)//view
    {
        self.view=self.stView=[[viewClass alloc] initWithController:self];
        //[self.stView loadUI];
    }
    else
    {   //这一步，在ViewController中的loadView做了处理，默认self.view就是STView
        self.view=self.stView=[[STView alloc] initWithController:self];//将view换成STView
        //self.stView=self.view;
    }
}
//局部状态栏隐藏(t)
//- (BOOL)prefersStatusBarHidden{
//   return ![self needStatusBar];
//}
- (void)viewDidLoad
{

    //检测上一个Controller
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"viewWillDisappear...%@", [self class]);
    if(!self.needStatusBar)
    {
        [self needStatusBar:YES forThisView:NO];
        [self needNavBar:NO forThisView:NO];
    }
    [self beforeViewDisappear];
    if(self.preferredInterfaceOrientationForPresentation!=Sagit.Define.DefaultOrientation)
    {
        //记录用于还原的屏幕方向。
        [self key:@"backToOrientation" value:@(self.preferredInterfaceOrientationForPresentation)];
        [self rotateOrientation:Sagit.Define.DefaultOrientation];
    }
    [super viewWillDisappear:animated];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    
    //NSLog(@"viewWillAppear...%@", [self class]);
    if(!self.needStatusBar)
    {
        [self needStatusBar:NO forThisView:NO];
    }
    else
    {
        [self setStatusBarStyle:self.preferredStatusBarStyle forThisView:NO];
    }
    if(self.needNavBar)
    {
        [self needNavBar:YES forThisView:NO];
    }
    [self beforeViewAppear];

    NSNumber *backTo=[self key:@"backToOrientation"];
    if(backTo!=nil)
    {
       [self rotateOrientation:(UIInterfaceOrientation)backTo.intValue];
    }
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    if(self.nextController)
    {
        [self reSetBarState:YES];
    }
    if(self.navigationController)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled=self.needNavBar;
    }
    [super viewDidAppear:animated];
    [self afterViewAppear];
}
#pragma mark 屏幕旋转事件
//!注册监听事件。
-(void)regDeviceNotification
{
    if([self key:@"regDeviceNotification"]==nil)
    {
        [self key:@"regDeviceNotification" value:@"1"];
        //手机旋转通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                               selector:@selector(onRotateNotification:)
                                                                   name:UIDeviceOrientationDidChangeNotification
                                                                 object:nil];
    }
}
-(void)onRotateNotification:(NSNotification *)notify
{
    UIDeviceOrientation deviceOri=[UIDevice currentDevice].orientation;
    if(deviceOri==UIDeviceOrientationUnknown || deviceOri==UIDeviceOrientationFaceUp || deviceOri==UIDeviceOrientationFaceDown)
    {return;}
    
    if((deviceOri==UIDeviceOrientationLandscapeLeft || deviceOri==UIDeviceOrientationLandscapeRight) && self.needStatusBar)//ios 13 隐藏了状态栏。
    {
        [self needStatusBar:YES forThisView:NO];
       // [self.view.statusBar alpha:0];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        //[UIApplication sharedApplication].statusBarHidden = NO;
        //[[UIApplication sharedApplication] setStatusBarOrientation: self.preferredInterfaceOrientationForPresentation];
        if (@available(ios 13.0, *)) {
            
        }
    }
    
    BOOL isEventRotate=[self isEventRotate];
    
    if(self.onDeviceRotate!=nil)
    {
        if(self.onDeviceRotate(notify,isEventRotate))
        {
            if(!isEventRotate)
            {
                UIInterfaceOrientationMask mask=self.supportedInterfaceOrientations;
                //设备方向是否支持。
                if((mask&(1<<deviceOri))==0){return;}
            }
            [self.view refleshLayoutAfterRotate];
        }
    }
    else if(isEventRotate)
    {
        [self.view refleshLayoutAfterRotate];
    }
  
}
//!用户监听设备旋转事件
-(void)setOnDeviceRotate:(OnRotate)onDeviceRotate
{
    if(_onDeviceRotate==nil && onDeviceRotate!=nil)
    {
        [self regDeviceNotification];
        _onDeviceRotate=onDeviceRotate;
    }
    else
    {
        _onDeviceRotate=nil;
    }
}

//!是否（点击）事件触发旋转
-(BOOL)isEventRotate
{
    NSNumber *value=[self key:@"isEventRotate"];
    if(value==nil)
    {
        return NO;
    }
    [self key:@"isEventRotate" value:nil];//拿一次就清空。
    return value.boolValue;
}
-(STController*)rotateOrientation:(UIInterfaceOrientation)direction
{
    [self regDeviceNotification];
    if(direction!=UIInterfaceOrientationUnknown && direction!=self.preferredInterfaceOrientationForPresentation)
    {
        if ([[UIDevice currentDevice]   respondsToSelector:@selector(setOrientation:)]) {
            [self key:@"isEventRotate" value:@(YES)];
            
            //设置允许旋转的方向
            [self setInterfaceOrientation:direction];
            //旋转设备、旋转布局。
            [[UIDevice currentDevice] setValue:@(UIDeviceOrientationUnknown) forKey:@"orientation"];
            [[UIDevice currentDevice] setValue:@(direction) forKey:@"orientation"];
        }
    }
    return self;
}


//内部私有方法
-(void)loadUI{

    [self initView];
    [self initUI];
}
//内部私有方法
-(void)loadData
{
    [self initData];
}
#pragma mark 通用的三个事件方法：onInit、initUI、initData(还有一个位于基类的：reloadData)

//在UI加载之前处理的
-(void)onInit{}
//加载UI时处理的
-(void)initUI
{
    [self.stView initUI];
}
//加载UI后处理的
-(void)initData
{
    [self.stView initData];
}
-(void)beforeViewAppear{}
-(void)afterViewAppear{}
-(void)beforeViewDisappear{}

-(NSMapTable*)UIList
{
    return self.stView.UIList;
}
-(STMsgBox *)msgBox
{
    if(_msgBox==nil)
    {
        _msgBox=[STMsgBox new];
    }
    return _msgBox;
}
-(STHttp *)http
{
    if(_http==nil)
    {
        _http=[[STHttp alloc]init:self.msgBox];//不用单例，延时加载
    }
    return _http;
}

-(BOOL)isMatch:(NSString*)tipMsg name:(NSString*)name
{
    return [self isMatch:tipMsg name:name regex:nil require:YES];
}
-(BOOL)isMatch:(NSString*)tipMsg name:(NSString*)name regex:(NSString*)pattern
{
    return [self isMatch:tipMsg value:name regex:pattern require:YES];
}
-(BOOL)isMatch:(NSString*)tipMsg name:(NSString*)name regex:(NSString*)pattern require:(BOOL)yesNo
{
    return [self isMatch:tipMsg value:[self stValue:name] regex:pattern require:yesNo];
}

-(BOOL)isMatch:(NSString*)tipMsg value:(NSString*)value
{
    return [self isMatch:tipMsg value:value regex:nil];
}
-(BOOL)isMatch:(NSString*)tipMsg value:(NSString*)value regex:(NSString*)pattern
{
    return [self isMatch:tipMsg value:value regex:pattern require:YES];
}
-(BOOL)isMatch:(NSString*)tipMsg value:(NSString*)value regex:(NSString*)pattern require:(BOOL)yesNo
{
    if([NSString isNilOrEmpty:tipMsg]){return NO;}
    
    NSArray<NSString*> *items=[tipMsg split:@","];
    NSString *tip=items.firstObject;
    if([NSString isNilOrEmpty:value])
    {
        if(yesNo)
        {
            [self showTip:[tip append:@"不能为空!"]];
            return NO;
        }
    }
    else if(pattern!=nil && ![pattern isEqualToString:@""])
    {
        if([pattern startWith:@"^"] && [pattern endWith:@"$"])
        {
            NSPredicate *match = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
            if(match)
            {
                if(![match evaluateWithObject:value])
                {
                    if(items.count==1)
                    {
                        [self showTip:[tip append:@"格式错误!"]];
                    }
                    else
                    {
                        [self showTip:[tipMsg replace:[tip append:@","] with:tip]];
                    }
                    return NO;
                }
            }
            match=nil;
        }
        else
        {
            UIView *view=STUIView(pattern);
            if([view isKindOfClass:[UIImageView class]])
            {
                NSString * vc=view.asImageView.VerifyCode;
                if(vc!=nil && ![vc isEqual:[value toLower]])
                {
                    [self showTip:[tip append:@"错误!"]];
                    return NO;
                }
            }
            else if(view.isFormUI)
            {
                if(![value isEqual:view.stValue])
                {
                    [self showTip:[tip append:@"不一致!"]];
                    return NO;
                }
            }
        }
    }
    return YES;
}
-(BOOL)isMatch:(NSString*)tipMsg isMatch:(BOOL)result
{
    if(!result)
    {
        [self showTip:tipMsg];
    }
    return result;
}
-(void)showTip:(NSString*)tip
{
    id label=[self key:@"requireTipLabel"];
    if(label!=nil)
    {
        UILabel *uiLabel=nil;
        if([label isKindOfClass:[NSString class]])
        {
            uiLabel=STLabel((NSString*)label);
        }
        else if([label isKindOfClass:[UILabel class]])
        {
            uiLabel=(UILabel*)label;
        }
        if(uiLabel!=nil)
        {
            [uiLabel text:tip];
            return;
        }
    }
   
    [self.msgBox prompt:tip];
}
-(void)stValue:(NSString*)name value:(NSString *)value
{
    UIView *ui=[self.UIList get:name];
    if(ui!=nil)
    {
        [ui stValue:value];
    }
}
//get set ui view....
-(NSString*)stValue:(NSString*)name
{
    UIView *ui=[self.UIList get:name];
    if(ui!=nil)
    {
        return ui.stValue;
    }
    return nil;
}
-(void)setToAll:(id)data{[self.stView setToAll:data];}
-(NSMutableDictionary*)formData{return [self.stView formData:nil];}
//!获取表单数据:superView 可以指定一个子UI。
-(NSMutableDictionary*)formData:(id)superView{return [self.stView formData:superView];}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if([self key:@"dispose"]!=nil)
    {
        [self dispose];
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if([self key:@"dispose"]!=nil)
    {
        [self dispose];
    }
    [super dismissViewControllerAnimated:flag completion:completion];
}


#pragma mark - UITableView 协议实现

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSString *num=[tableView key:@"sectionCount"];
    if(num!=nil)
    {
        return [num integerValue];
    }
    return 1;
}

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    NSArray<NSString*> *numb=[tableView key:@"rowCountInSections"];
    if(numb!=nil)
    {
        count= [numb[section] integerValue];
    }
    else
    {
        count=tableView.source.count;
    }
    tableView.separatorStyle=count>0?UITableViewCellSeparatorStyleSingleLine:UITableViewCellSeparatorStyleNone;
    return count;
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell=[UITableViewCell reuseCell:tableView index:indexPath];
    if(!tableView.reuseCell && (cell.contentView.subviews.count>0 || cell.subviews.count>2)){return cell;}
    if(tableView.addCell)
    {
        NSInteger row=indexPath.row;
        if(indexPath.section>0)
        {
            for (NSInteger i=0; i<indexPath.section; i++) {
                row+=[tableView numberOfRowsInSection:i];
            }
        }
        if(tableView.source.count>row)
        {
            cell.source=tableView.source[row];
            if([cell.source isKindOfClass:[NSDictionary class]])
            {
                [cell firstValue:((NSDictionary*)cell.source).firstObject];
            }
        }
        tableView.addCell(cell,indexPath);
        [cell.contentView stSizeToFit];
        [cell stSizeToFit];//调整高度
    }
    NSMutableDictionary *dic=tableView.heightForCells;
    NSMutableArray *rows=dic[@(indexPath.section)];
    if(!rows)
    {
        rows=[NSMutableArray new];
        [dic set:@(indexPath.section) value:rows];
    }
    NSNumber *height=@(cell.frame.size.height);
    [cell key:@"initHeight" value:height];
    if(indexPath.row==rows.count)
    {
        [rows addObject:height];
    }
    else if(indexPath.row<rows.count)
    {
        rows[indexPath.row]=height;
    }
    else //处理乱序飞入
    {
        [dic setObject:height forKey:indexPath];
    }
    
    return cell;
}
//tableview 加载完成可以调用的方法--因为tableview的cell高度不定，所以在加载完成以后重新计算高度
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 && indexPath.section==0)
    {
        [cell y:0];
    }
    if(indexPath.row == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
    {
        //cell.separatorInset = UIEdgeInsetsMake(0, STScreeWidthPt , 0, 0);//去掉最后一条线的
        //兼容IOS系统10.3.1(闪退的情况，所以延时0.05秒处理）
        //闪退的情况发现生在OS 10.3.1(在此事件中对TextView赋值,同时该TextView自适应高度又引发TableView BeginUpdate/EndUpdate事件时，系统崩溃
        //报错内容为系统的索引超出范围。
        //同时：tableView.contentSize 因高度系统修正会延后，需要延时再获取。
        [Sagit delayExecute:0.05 onMainThread:YES block:^{
            CGFloat height=0;
            if(tableView.autoHeight)
            {
                CGFloat passValue=tableView.frame.origin.y+tableView.contentSize.height-tableView.superview.frame.size.height;
                if(passValue>0){tableView.scrollEnabled=YES;}
                NSInteger relateBottomPx=0;
                //检测是否有向下的约束
                STLayoutTracer *onTop= tableView.LayoutTracer[@"onTop"];
                if(onTop)
                {
                    CGSize superSize=[onTop.view superSizeWithFix];
                    relateBottomPx=superSize.height*Ypx-onTop.view.stY+onTop.v1;
                }
                STLayoutTracer *tracer= tableView.LayoutTracer[@"relate"];
                if(relateBottomPx!=0 || (tracer && tracer.hasRelateBottom))//|| onTop 两个都有：那个是后加的？
                {
                    if(relateBottomPx==0)
                    {
                        relateBottomPx=tracer.relateBottomPx;
                    }
                    //检测是否高度超过屏
                    passValue=passValue+relateBottomPx*Ypt;
                    if(passValue>0)
                    {
                        tableView.scrollEnabled=YES;
                        height=tableView.contentSize.height-passValue-1;
                    }
                    else
                    {
                        height=tableView.contentSize.height-1;//减1是去掉最后的线。
                    }
                }
                else
                {
                    height=tableView.contentSize.height-1;//减1是去掉最后的线。
                }
            }

            if(height!=0)
            {
                [tableView height:height*Ypx];
            }
            if(tableView.afterReload)
            {
                tableView.afterReload(tableView);
            }
        }];
    }
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSMutableArray *rows=[tableView.heightForCells get:@(indexPath.section)];
    if(rows && rows.count>indexPath.row)
    {
        return [(NSNumber*)rows[indexPath.row] integerValue];
    }
    NSNumber *value=[tableView.heightForCells get:indexPath];//乱序飞入的情况
    if(value){return [value integerValue];}
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
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01f;
//    //return tableView.tableHeaderView.frame.size.height;
//}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
//{
//    return 0.01f;
//}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}
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
#pragma mark UITableView 处理表头：Section View
// 设置表头的高度。如果使用自定义表头，该方法必须要实现，否则自定义表头无法执行，也不会报错
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.addSectionHeaderView)
    {
        NSString *key=[@"sectionHeaderView" append:STNumString(section)];
        UIView *view=[tableView key:key];
        if(view==nil)
        {
            view=[[UIView new] width:1 height:40*STStandardScale];
            [tableView key:key value:view];
        }
        tableView.addSectionHeaderView(view, section);
        return view.frame.size.height;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key=[@"sectionHeaderView" append:STNumString(section)];
    return [tableView key:key];
}
// 返回每组的组尾
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView.addSectionFooterView)
    {
        NSString *key=[@"sectionFooterView" append:STNumString(section)];
        UIView *view=[tableView key:key];
        if(view==nil)
        {
            view=[[UIView new] width:1 height:40*STStandardScale];
            [tableView key:key value:view];
        }
        tableView.addSectionFooterView(view, section);
        return view.frame.size.height;
    }
    return 0;
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString *key=[@"sectionFooterView" append:STNumString(section)];
    return [tableView key:key];
}


#pragma mark UITableView 编辑删除
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if(cell!=nil)
    {
        return cell.allowEdit;
    }
    return tableView.allowEdit;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//设置进入编辑状态时，Cell不会缩进，好像没生效。
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle==UITableViewCellEditingStyleDelete && tableView.delCell)
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        if(tableView.delCell(cell, indexPath))
        {
            [tableView afterDelCell:indexPath];
        }
    }
}
//增加自定义菜单处理。
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView.addCellAction) // 自定义menu
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.action=[[STUITableViewCellAction alloc] initWithCell:cell];
        tableView.addCellAction(cell.action, indexPath);
        NSArray *items=cell.action.items;
        if(items.count>0)
        {
            NSMutableArray *array=[NSMutableArray new];
            for (long i=items.count-1; i>=0; i--) {
                STCellAction *swipeAction=items[i];
                UITableViewRowActionStyle color=(i==items.count-1?UITableViewRowActionStyleDefault:UITableViewRowActionStyleNormal);
                UITableViewRowAction *rowAction  = [UITableViewRowAction rowActionWithStyle:color title:swipeAction.title
                                                                                    handler:^(UITableViewRowAction * _Nonnull action,NSIndexPath * _Nonnull indexPath) {
                    
                    if(swipeAction.onAction)
                    {
                        swipeAction.onAction(cell, indexPath);
                    }
                    
                }];
                if(swipeAction.bgColor!=nil)
                {
                    rowAction.backgroundColor=swipeAction.bgColor;
                }
                [array addObject:rowAction];
            }
            return array;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if(cell!=nil)
    {
        UIView *cellActionView=[self getCellActionView:cell];
        if(cellActionView!=nil)
        {
            [cellActionView backgroundColor:ColorClear];//清空底色。
            for (int i=0; i<cell.action.items.count; i++) {
                STCellAction *action=cell.action.items[i];
                if(action.onCustomView!=nil)
                {
                    UIView *actionView=cellActionView.subviews[i];//button 无法直接设置背景色。
                    [actionView removeAllSubViews];
                    action.onCustomView([[actionView addUIView:nil] width:1 height:1],indexPath);//添加全屏子控件，可以设置背景色。
                }
            }
        }
    }
}
-(UIView *)getCellActionView:(UITableViewCell *)cell
{
    UIView *uiSwipeActionPullView=cell.superview.subviews[0]; //UISwipeActionPullView
    if([uiSwipeActionPullView isKindOfClass:[UITableViewCell class]])
    {
        if(cell.table!=nil)
        {
            //IOS 13 以下。
            for (UIView *view in cell.table.subviews) {
                if([view isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
                {
                    uiSwipeActionPullView=view;
                    break;
                }
            }
        }
    }
    return uiSwipeActionPullView;
}
#pragma mark - UICollectionView 协议实现

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return collectionView.source.count;
}
//!控制方块的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    if(cell!=nil)
    {
        return cell.frame.size;
    }
    return  CGSizeMake(100, 100);
}
///* 设置方块视图和边界的上下左右间距 */
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
//                        layout:(UICollectionViewLayout*)collectionViewLayout
//        insetForSectionAtIndex:(NSInteger)section;
//{
//    collectionView.collectionViewLayout;
//    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
//    if(cell!=nil)
//    {
//        return cell.frame.size;
//    }
//    return  UIEdgeInsetsMake(10, 10, 10, 10);
//}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[UICollectionViewCell reuseCell:collectionView index:indexPath];
    if(collectionView.addCell)
    {
        if(collectionView.source.count>indexPath.row)
        {
            cell.source=collectionView.source[indexPath.row];
            [cell firstValue:cell.source.firstObject];
        }
        //默认设置
        collectionView.addCell(cell,indexPath);
    }
    return cell;
}
-(void)dealloc
{
    if([self key:@"regDeviceNotification"]!=nil)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    _onDeviceRotate=nil;
    _http=nil;
    if(_msgBox)
    {
        [_msgBox hideLoading];//切换面页都将隐藏掉。
        _msgBox=nil;
    }
    _stView=nil;
    NSLog(@"STController relase -> %@", [self class]);
}
@end
