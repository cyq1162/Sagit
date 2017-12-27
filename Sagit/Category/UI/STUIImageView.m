//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIImageView.h"
#import "STMessageBox.h"
#import <objc/runtime.h>

@implementation UIImageView(ST)

static char pickChar='p';
-(void)setPickBlock:(OnPick)block
{
    objc_setAssociatedObject(self, &pickChar, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
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

-(UIImageView*)pick:(OnPick)pick edit:(BOOL)yesNo
{
    return [self pick:pick edit:yesNo maxKb:256];
}
-(UIImageView*)pick:(OnPick)pick edit:(BOOL)yesNo maxKb:(NSInteger)maxKb
{
    if(pick==nil){return self;}
    [self key:@"maxKb" value:[@(maxKb) stringValue]];
    [self setPickBlock:pick];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = yesNo;
    [self.STController presentViewController:picker animated:YES completion:nil];
    return self;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[picker.allowsEditing?UIImagePickerControllerEditedImage:UIImagePickerControllerOriginalImage];
    NSData *data = [image compress:[[self key:@"maxKb"] intValue]];//[ITTool compressImage:image toByte:250000];
    OnPick event = (OnPick)objc_getAssociatedObject(self, &pickChar);
    if(event)
    {
        event(data,picker,info);
    }
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
