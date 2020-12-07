//
//  STUIViewValue.h
//  STITLink
//
//  Created by 陈裕强 on 2020/8/27.
//  Copyright © 2020 随天科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (STUIViewValue)

//!根据UI类型不同而返回不同的属性值
-(NSString*)stValue;
//!为UI赋属性值
-(UIView*)stValue:(NSString*)value;
//!默认为下拉选择等做简化（扩展属性）
-(NSString*)selectText;
-(UIView*)selectText:(NSString*)text;
//!默认为下拉选择等做简化（扩展属性）
-(NSString*)selectValue;
-(UIView*)selectValue:(NSString*)value;


#pragma mark 共用接口
//!重新加载数据（一般由子类重写，由于方法统一，在不同控制器中都可以直接调用，而不用搞代理事件）
-(void)reloadData;
//!重新加载数据（一般由子类重写，只是多了个参数，方便根据参数重新加载不同的数据）
-(void)reloadData:(NSString*)para;

//!将指定的数据批量赋值到所有的UI中：data可以是字典、是json，是实体等
-(void)setToAll:(id)data;
//!将指定的数据批量赋值到所有的UI中：data可以是字典、是json，是实体等 toChild:是否检测子控件并对子控件也批量赋值，默认NO。
-(void)setToAll:(id)data toChild:(BOOL)toChild;
//!从UIList中遍历获取属性isFormUI的表单数据列表
-(NSMutableDictionary*)formData;
//!从UIList中遍历获取属性isFormUI的表单数据列表 superView ：指定一个父，不指定则为根视图
-(NSMutableDictionary*)formData:(id)superView;

#pragma mark 设置数据校验
//!【表单设置】用于校验输入的必填、格式。(点击事件时被检测触发)
-(UIView*)require:(BOOL)yesNo;
-(UIView*)require:(BOOL)yesNo regex:(NSString*)regex;
-(UIView*)require:(BOOL)yesNo regex:(NSString*)regex tipName:(NSString*)tipName;
//!用于校验的分组触发（表单、按钮可设置）。
-(UIView*)requireGroup:(NSString*)name;

#pragma mark 触发数据校验[按钮]
//!【按钮设置】点击事件设置是否触发验证。
-(UIView*)requireBeforeClick:(BOOL)yesNo;
//!【按钮设置】若需要将提示语显示在指定人UILabel中。
-(UIView*)requireTipLabel:(id)nameOrLabel;
//!触发验证。（内部点击触发）
-(BOOL)exeRequire;
@end

