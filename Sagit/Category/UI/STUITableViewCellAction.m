//
//  STUITableViewCellMenu.m
//
//  Created by 陈裕强 on 2020/9/16.
//

#import "STUITableViewCellAction.h"
@implementation STCellAction
-(void)dispose
{
    self.onAction = nil;
    self.onCustomView = nil;
    self.title=nil;
    self.bgColor=nil;
}
@end
@implementation STUITableViewCellAction

-(instancetype)initWithCell:(UITableViewCell*) cell
{
    self=[self init];
    if(cell!=nil)
    {
        self.cell=cell;
    }
    return self;
}
-(NSMutableArray<STCellAction*>*) items
{
    
    if(_items==nil)
    {
        _items=[NSMutableArray<STCellAction*> new];
    }
    return _items;
    
}
-(void)addAction:(NSString*)title bgColor:(UIColor*)bgColor onAction:(OnCellAction)onAction;
{
    STCellAction *menu=[STCellAction new];
    menu.title=title;
    menu.bgColor=bgColor;
    menu.onAction = onAction;
    [self.items addObject:menu];
}
-(void)addAction:(OnCustomView)onCustomView onAction:(OnCellAction)onAction
{
    STCellAction *menu=[STCellAction new];
    menu.onCustomView = onCustomView;
    menu.onAction = onAction;
    [self.items addObject:menu];
}
-(void)dispose
{
    if(self.items.count>0)
    {
        for (STCellAction *action in self.items) {
            [action dispose];
        }
        [self.items removeAllObjects];
    }
    _items=nil;
}
-(void)dealloc
{
    [self dispose];
    NSLog(@"%@ ->STUITableViewCellAction relase", [self class]);
}
@end
