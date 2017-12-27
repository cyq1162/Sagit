//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIControl.h"

@implementation UIControl (ST)

-(UIControl *)enabled:(BOOL)yesNo
{
    [self alpha:yesNo?1:0.4];
    [self setEnabled:yesNo];
    return self;
}
-(UIControl *)selected:(BOOL)yesNo
{
    [self setSelected:yesNo];
    return self;
}
-(UIControl *)highlighted:(BOOL)yesNo
{
    [self setHighlighted:yesNo];
    return self;
}
@end
