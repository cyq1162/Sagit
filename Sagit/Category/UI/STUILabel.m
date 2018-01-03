//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUILabel.h"
#import "STDefineUI.h"
#import "STUIView.h"
#import "STUIViewEvent.h"
#import "STDictionary.h"

@implementation UILabel(ST)
#pragma mark 扩展系统事件
-(UILabel *)longPressCopy:(BOOL)yesNo
{
    if(yesNo)
    {
        if([self key:@"longPressCopy"]==nil)
        {
            [self key:@"longPressCopy" value:@"1"];
            
            [self onLongPress:^(UILabel *this) {
                [this key:@"backgroundColor" value:this.backgroundColor];
                [[NSNotificationCenter defaultCenter] addObserver:this  selector:@selector(didHideMenu:) name:UIMenuControllerDidHideMenuNotification object:nil];//注册菜单隐藏事件,在隐藏时会注销事件
                
                [this becomeFirstResponder];
                UIMenuController *menuC = [UIMenuController sharedMenuController];//全局的，其它地方修改也会影响
                UIMenuItem *menuCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy)];
                menuC.menuItems=@[menuCopy];
                [menuC setTargetRect:this.frame inView:this.superview];
                [[this backgroundColor:ColorGray] alpha:0.7];//设置背景色
                [menuC setMenuVisible:YES animated:YES];
            }];
        }
    }
    else
    {
        [self removeLongPress];
        [self.keyValue remove:@"longPressCopy"];
    }
    return self;
}
-(void)didHideMenu:(id)sender
{
    UIColor *color=[self key:@"backgroundColor"];
    if(color)
    {
        [self backgroundColor:color];//菜单隐藏，恢复
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}
- (BOOL)canBecomeFirstResponder
{
    return [self key:@"longPressCopy"]!=nil;
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return action == @selector(copy);
}

//!复制文本
-(UILabel*)copy
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    return self;
}

#pragma mark 扩展系统属性

-(UILabel*)text:(NSString*)text
{
    self.text=text;
    return self;
}
-(UILabel*)textColor:(id)colorOrHex
{
    self.textColor=[self toColor:colorOrHex];
    return self;
}
-(UILabel*)textAlignment:(NSTextAlignment)align
{
    self.textAlignment=align;
    return self;
}
-(UILabel*)font:(NSInteger)px
{
    self.font=STFont(px);
    return self;
}
-(UILabel*)numberOfLines:(NSInteger)value
{
    self.numberOfLines=value;
    return self;
}
@end
