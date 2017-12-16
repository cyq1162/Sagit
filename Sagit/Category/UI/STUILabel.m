//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUILabel.h"
#import "STDefineUI.h"

@implementation UILabel(ST)
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
@end
