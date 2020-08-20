//
//  STUIImage.m
//
//  Created by 陈裕强 on 2020/8/19.
//


@implementation UIImage(ST)
static char nameChar='n';
-(NSString *)name
{
    return (NSString*)objc_getAssociatedObject(self, &nameChar);
}
-(void)setName:(NSString *)name
{
    objc_setAssociatedObject(self, &nameChar, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
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
static char afterImageSaveBlockChar='c';
-(AfterImageSave)afterImageSaveBlock
{
    return (AfterImageSave)objc_getAssociatedObject(self, &afterImageSaveBlockChar);
}
-(void)setAfterImageSaveBlock:(AfterImageSave)afterImageSaveBlock
{
     objc_setAssociatedObject(self, &afterImageSaveBlockChar, afterImageSaveBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)save:(AfterImageSave)afterSaveBlock
{
    self.afterImageSaveBlock=afterSaveBlock;
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(afterImageSave:error:contextInfo:),nil);
}
- (void)afterImageSave:(UIImage *)image error:(NSError *)error contextInfo:(void *)contextInfo
{
    if(self.afterImageSaveBlock)
    {
        self.afterImageSaveBlock(error);
        self.afterImageSaveBlock = nil;
    }
}
-(UIImage *)reSize:(CGSize)maxSize
{
    //[self width:maxSize.width height:maxSize.height];
    UIImage *image=self;
    if (image.size.width < maxSize.width && image.size.height < maxSize.height) return image;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    CGFloat k = 0.0f;
    CGSize size = CGSizeMake(maxSize.width, maxSize.height);
    if (image.size.width > maxSize.width)
    {
        k = image.size.width / maxSize.width;
        imageH = ceil(image.size.height / k);
        size = CGSizeMake(maxSize.width, imageH);
    }
    if (imageH > maxSize.height) {
        k = image.size.height / maxSize.height;
        imageW = ceil(image.size.width / k);
        size = CGSizeMake(imageW, maxSize.height);
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return image;
}
-(NSData *)data
{
   return UIImagePNGRepresentation(self);
}
@end
