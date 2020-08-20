//
//  STUIImage.h
//
//  Created by 陈裕强 on 2020/8/19.
//

#import <Foundation/Foundation.h>


@interface UIImage(ST)
//!为每个UI都扩展有一个name
@property (nonatomic,copy) NSString* name;
typedef void (^AfterImageSave)(NSError *err);
@property (nonatomic,copy) AfterImageSave afterImageSaveBlock;
//!获取图片压缩后的字节数据，当前图片不受变化
-(NSData*)compress:(NSInteger)maxKb;
-(void)save:(AfterImageSave)afterSave;
//!检测最大宽高的等比缩放
-(UIImage *)reSize:(CGSize)maxSize;
-(NSData*)data;
@end

