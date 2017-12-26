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
-(UIImageView *)corner:(BOOL)yesNo
{
    [self clipsToBounds:yesNo];
    if(yesNo)
    {
        [self layerCornerRadiusToHalf];
    }
    else
    {
        self.layer.cornerRadius=0;
    }
    return self;
}
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
-(NSString *)url
{
    return [self key:@"url"];
}
-(UIImageView *)url:(NSString *)url
{
    return [self url:url maxKb:256];
}
-(UIImageView *)url:(NSString *)url maxKb:(NSInteger)compress
{
    if([NSString isNilOrEmpty:url])
    {
        self.image=nil;
        [self.keyValue remove:@"url"];
        return self;
    }
    [self key:@"url" value:url];
    if(![url startWith:@"http"])
    {
       return [self image:url];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
        if (data != nil) {
            UIImage *image = [[UIImage alloc]initWithData:data];
            if(compress>=0 && data.length>compress*1024)//>400K
            {
                data= [image compress:compress];//压缩图片
                image = [[UIImage alloc]initWithData:data];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //在这里做UI操作(UI操作都要放在主线程中执行)
                self.image=image;
            });
        }
        
    });
    return self;
}
#pragma mark 扩展属性
-(UIImageView *)image:(id)imgOrName
{
    [self setImage:[UIView toImage:imgOrName]];
    return self;
}
@end
@implementation UIImage(ST)

-(NSData*)compress:(NSInteger)maxKb
{
    // Compress by quality
    NSInteger maxLength=maxKb*1024;//转字节处理
    CGFloat quality = 1;
    NSData *data = UIImageJPEGRepresentation(self, quality);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i)
    {
        quality = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, quality);
        if (data.length < maxLength * 0.9) {
            min = quality;
        } else if (data.length > maxLength) {
            max = quality;
        } else {
            break;
        }
    }
    return data;
}
-(UIImage *)reSize:(CGSize)maxSize
{
    UIImage *image=self;
    if (image.size.width < maxSize.width && image.size.height < maxSize.height) return image;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    CGFloat k = 0.0f;
    CGSize size = CGSizeMake(maxSize.width, maxSize.height);
    if (image.size.width > maxSize.width)
    {
        k = image.size.width / maxSize.width;
        imageH = image.size.height / k;
        size = CGSizeMake(maxSize.width, imageH);
    }
    if (imageH > maxSize.height) {
        k = image.size.height / maxSize.height;
        imageW = image.size.width / k;
        size = CGSizeMake(imageW, maxSize.height);
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return image;
}
@end
