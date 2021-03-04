//
//  STUIImage.h
//
//  Created by 陈裕强 on 2020/8/19.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
@interface UIImage(ST)
//!为每个UI都扩展有一个name
@property (nonatomic,copy) NSString* name;
typedef void (^OnAfterImageSave)(NSError *err);
@property (nonatomic,copy) OnAfterImageSave afterImageSaveBlock;
//!获取图片压缩后的字节数据，当前图片不受变化
-(NSData*)compress:(NSInteger)maxKb;
-(void)save:(OnAfterImageSave)afterSave;
//!在UIImage周围添加透明空间
-(UIImage*)drawIn:(CGSize)size point:(CGPoint)point;

//!检测最大宽高的等比缩放
-(UIImage *)reSize:(CGSize)maxSize;
-(UIImage *)reSize:(CGSize)maxSize point:(CGPoint)point;
-(NSData*)data;

+(UIImage*)toImage:(id)imgOrName;

@end

