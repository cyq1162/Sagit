//
//  STUIImage.m
//
//  Created by 陈裕强 on 2020/8/19.
//

#import "STUIImage.h"
#import "STUIViewEvent.h"
#import "STCategory.h"
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
    if (data.length <= maxLength || maxKb<=0) return data;

    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 7; ++i)
    {
        quality = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, quality);
        if (data.length < maxLength * 0.8) {
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
-(OnAfterImageSave)afterImageSaveBlock
{
    return (OnAfterImageSave)objc_getAssociatedObject(self, &afterImageSaveBlockChar);
}
-(void)setAfterImageSaveBlock:(OnAfterImageSave)afterImageSaveBlock
{
     objc_setAssociatedObject(self, &afterImageSaveBlockChar, afterImageSaveBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)save:(OnAfterImageSave)afterSaveBlock
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
- (UIImage *)reSize:(CGSize)maxSize
{
    return [self reSize:maxSize point:CGPointZero];
}
-(UIImage *)reSize:(CGSize)maxSize point:(CGPoint)point
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
    [image drawInRect:CGRectMake(point.x, point.y, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return image;
}
-(NSData *)data
{
   return UIImagePNGRepresentation(self);
}
-(UIImage *)drawIn:(CGSize)size point:(CGPoint)point
{
    // Setup a new context with the correct size
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
     
    // Now we can draw anything we want into this new context.
    [self drawAtPoint:point];
     
    // Clean up and get the new image.
    UIGraphicsPopContext();
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIImage*)toImage:(id)imgOrName
{
    if([imgOrName isKindOfClass:[NSString class]])
    {
        NSString* name=(NSString*)imgOrName;
        if([name startWith:@"http://"] || [name startWith:@"https://"])
        {
            return nil;//-------------------------------------------------------------------------------------
        }
        else
        {
            UIImage *img=[UIImage imageNamed:imgOrName];
            img.name=imgOrName;
            return img;
        }
    }
    else if([imgOrName isKindOfClass:[NSData class]])
    {
        return [UIImage imageWithData:imgOrName];
    }
    else if([imgOrName isKindOfClass:[UIImage class]])
    {
        return imgOrName;
    }
    else if([imgOrName isKindOfClass:[UIImageView class]])
    {
        return ((UIImageView*)imgOrName).image;
    }
    return nil;
}
-(CGSize)getMaxScale:(CGSize)scaleSize
{
    return scaleSize;
}
@end
