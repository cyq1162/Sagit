//
//  STUIAlertView.h
//  IT恋
//
//  Created by 陈裕强 on 2018/1/2.
//  Copyright © 2018年 Silan Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertView(ST)
-(BOOL)allowDismiss;
-(UIAlertView*)allowDismiss:(BOOL)yesNo;
@end


@interface STUIAlertView:UIAlertView
@end
