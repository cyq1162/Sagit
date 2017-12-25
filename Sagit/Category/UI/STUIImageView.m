//
//  STUIImageView.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/24.
//  Copyright © 2017年. All rights reserved.
//

#import "STUIImageView.h"
#import "STMessageBox.h"
@implementation UIImageView(ST)

-(UIImageView *)longPressSave:(BOOL)yesNo
{
    if(yesNo)
    {
        [self longPress:@"save" target:self];
    }
    return self;
}

-(UIImageView*)save
{
    [[STMessageBox share] confirm:@"提示" msg:@"是否保存图片？" click:^(BOOL isOK) {
        if(isOK)
        {
            UIImageView *view=self;
            UIImageWriteToSavedPhotosAlbum(view.image, self, @selector(afterImageSave:error:contextInfo:),nil);
        }
    }];
    return self;
}
- (void)afterImageSave:(UIImage *)image error:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [[STMessageBox share] prompt:@"保存成功"];
    }else {
        
        [[STMessageBox share] prompt:@"保存失败:保存照片权限被拒绝，您需要重新设置才能保存！"];
    }
}


@end
