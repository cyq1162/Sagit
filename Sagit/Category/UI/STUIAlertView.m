//
//  STUIAlertView.m
//  IT恋
//
//  Created by 陈裕强 on 2018/1/2.
//  Copyright © 2018年 . All rights reserved.
//

#import "STUIAlertView.h"
#import "STUIView.h"
#import "STUIViewAddUI.h"
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
        [super dispose];
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
        
    }
}
//-(void)dealloc
//{
//    NSLog(@"STUIAlertView relase -> %@", [self class]);
//}
@end
