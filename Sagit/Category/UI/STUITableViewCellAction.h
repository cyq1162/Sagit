//
//  STUITableViewCellMenu.h
//
//  Created by 陈裕强 on 2020/9/16.
//

#import <UIKit/UIKit.h>

@interface STCellAction : NSObject
typedef  void(^OnCellAction)(UITableViewCell *cell, NSIndexPath * indexPath);
typedef  void(^OnCustomView)(UIView *actionView, NSIndexPath * indexPath);
//!事件【点击事件】
@property (nonatomic,copy) OnCellAction onAction;
//!事件【自定义ActionView事件】
@property (nonatomic,copy) OnCustomView onCustomView;
//!标题【非自定义ActionView事件时】
@property (nonatomic,retain) NSString* title;
//!背景色【非自定义ActionView事件时】
@property (nonatomic,retain) UIColor* bgColor;
//!释放。
-(void)dispose;
@end

@interface STUITableViewCellAction : NSObject

-(instancetype)initWithCell:(UITableViewCell*) cell;
//!action 集合。
@property (nonatomic,retain)  NSMutableArray<STCellAction*> *items;
//!获取当前所在的cell,(weak，不能造成双strong引用)
@property (nonatomic,weak) UITableViewCell *cell;
//添加 action 【非自定义ActionView】
-(void)addAction:(NSString*)title bgColor:(UIColor*)bgColor onAction:(OnCellAction)onAction;
//添加 action 【自定义ActionView】
-(void)addAction:(OnCustomView)onCustomView onAction:(OnCellAction)onAction;
//!释放。
-(void)dispose;
@end



