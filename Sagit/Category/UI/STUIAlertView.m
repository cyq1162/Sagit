//
//  STUIAlertView.m
//  IT恋
//
//  Created by 陈裕强 on 2018/1/2.
//  Copyright © 2018年 Silan Xie. All rights reserved.
//

#import "STUIAlertView.h"
#import "STUIView.h"
@implementation UIAlertView(ST)

-(BOOL)allowDismiss
{
    NSString* dismiss=[self key:@"allowDismiss"];
    return dismiss==nil || [dismiss isEqualToString:@"1"];
}
-(UIAlertView*)allowDismiss:(BOOL)yesNo
{
    [self key:@"allowDismiss" value:yesNo?@"1":@"0"];
    return self;
}
@end

@implementation STUIAlertView
-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if(self.allowDismiss)
    {
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
}
@end
