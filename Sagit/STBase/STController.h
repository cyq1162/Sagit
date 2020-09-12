//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STEnum.h"

@class STView;
@class STHttp;
@class STMsgBox;

@interface STController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
//!当前控制器的STView根视图
@property (nonatomic,retain) STView* stView;
//!用于发起http请求
@property (nonatomic,retain) STHttp *http;
//!用于弹窗提示消息
@property (nonatomic,retain) STMsgBox *msgBox;

#pragma mark 屏幕旋转
//!屏幕旋转事件：【 return true 系统调用刷新布局（[self.view refleshLayoutAfterRotate];）；return false 用户自己手动控制】 @isEventRotate 是旋转屏幕、还是点击事件触发。
typedef  BOOL(^OnRotate)(NSNotification* notify,BOOL isEventRotate);
//!屏幕旋转事件。
@property (nonatomic,assign) OnRotate onDeviceRotate;
//!设置当前视图支持的屏幕旋转方向
-(void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)orientation;
//!设置当前视图的屏幕显示方向（可设置默认的显示方向）
-(void)setInterfaceOrientation:(UIInterfaceOrientation)orientation;
//!手动调用旋转屏幕。
-(STController*)rotateOrientation:(UIInterfaceOrientation)direction;

#pragma mark 通用的三个事件方法：onInit、initUI、initData(还有一个位于基类的：reloadData)
//!事件在UI初始化之前执行【只执行1次】
-(void)onInit;
//!内部使用。
-(void)initView;
//!UI初始化【只执行1次】
-(void)initUI;
//!事件在UI初始化之后执行【只执行1次】
-(void)initData;

#pragma mark 系统的2个事件方法
//呈现UI之前【执行N次】
-(void)beforeViewAppear;
//UI消失之前【执行N次】
-(void)beforeViewDisappear;


//!执行view的stValue属性
-(NSString*)stValue:(NSString*)name;
//!执行view的stValue属性
-(void)stValue:(NSString*)name value:(NSString*)value;

//!验证文本框的值是否填写或格式是否错误 根据ui的name进行处理
-(BOOL)isMatch:(NSString*)tipMsg name:(NSString*)name;
-(BOOL)isMatch:(NSString*)tipMsg name:(NSString*)name regex:(NSString*)pattern;
-(BOOL)isMatch:(NSString*)tipMsg name:(NSString*)name regex:(NSString*)pattern require:(BOOL)yesNo;
//!验证文本框的值是否填写或格式是否错误 根据已获取的value进行处理
-(BOOL)isMatch:(NSString*)tipMsg value:(NSString*)value;
-(BOOL)isMatch:(NSString*)tipMsg value:(NSString*)value regex:(NSString*)pattern;
-(BOOL)isMatch:(NSString*)tipMsg value:(NSString*)value regex:(NSString*)pattern require:(BOOL)yesNo;
//!根据指定的结果弹出消息。
-(BOOL)isMatch:(NSString*)tipMsg isMatch:(BOOL)result;
//!指向view的setToAll：将指定的数据批量赋值到所有的UI中：data可以是字典、是json，是实体等
-(void)setToAll:(id)data;
//!指向view的formData： 从UIList中遍历获取属性isFormUI的表单数据列表
-(NSMutableDictionary*)formData;
//!指向view的formData： 从UIList中遍历获取属性isFormUI的表单数据列表  superView ：指定一个父，不指定则为根视图
-(NSMutableDictionary*)formData:(id)superView;

@end
