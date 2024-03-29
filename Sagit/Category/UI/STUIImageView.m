//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIImageView.h"
#import "STMsgBox.h"
#import <objc/runtime.h>
#import "STSagit.h"
#import "STUIView.h"
#import "STUIViewEvent.h"
#import "STString.h"
#import "STDictionary.h"
#import "CropImageView.h"
@implementation UIImageView(ST)

//static char pickChar='p';
//-(void)setPickBlock:(OnPick)block
//{
//    objc_setAssociatedObject(self, &pickChar, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
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
        [self addLongPress:@"save" target:self];
    }
    else
    {
        [self removeLongPress];
    }
    return self;
}

-(void)save
{
    [Sagit.MsgBox confirm:@"是否保存图片？" title:@"消息提示" click:^void(NSInteger isOK,id view) {
        if(isOK>0)
        {
            [self.image save:^(NSError *err) {
                [Sagit.MsgBox prompt:!err?@"保存成功":@"保存失败:保存照片权限被拒绝，您需要重新设置才能保存！"];
            }];
        }
    }];
}

-(NSString *)url
{
    return [self key:@"url" ];
}

-(UIImageView *)url:(NSString *)url
{
    return [self url:url default:nil maxKb:256];
}
//-(UIImageView *)url:(NSString *)url after:(AfterSetImageUrl)block
//{
//    return [self url:url maxKb:256 default:nil after:block];
//}
-(UIImageView *)url:(NSString *)url default:(id)imgOrName
{
    return [self url:url default:imgOrName maxKb:256 ];
}
//-(UIImageView *)url:(NSString *)url maxKb:(NSInteger)compress
//{
//    return [self url:url maxKb:compress default:nil  after:nil];
//}
//-(UIImageView *)url:(NSString *)url maxKb:(NSInteger)compress default:(id)imgOrName
//{
//    return [self url:url maxKb:compress default:nil after:nil];
//}
-(UIImageView *)url:(NSString *)url default:(id)imgOrName maxKb:(NSInteger)compress //after:(AfterSetImageUrl)block
{
    if(imgOrName==nil)
    {
        UIView *defaultView=[[[UIView new] backgroundColor:ColorBlack] width:self.stWidth height:self.stHeight];
        [[[[defaultView addLabel:nil text:@"Loading..." font:46 color:ColorWhite] textAlignment:NSTextAlignmentCenter ] stSizeToFit] toCenter];
        imgOrName= defaultView.asImage;
        
    }
    OnAfterEvent block=self.onAfter;
    if([NSString isNilOrEmpty:url])
    {
        
        if(block){block(@"url",self);block=nil;}
        return self;
    }
    [self key:@"url" value:url];
    if(![url startWith:@"http"])
    {
        [self image:url];
        if(block){block(@"url",self);block=nil;}
        return self;
    }
    NSString *cacheKey=[@"STImgUrl_" append:[@([url hash]) stringValue]];
    NSData * cacheImg=[Sagit.File get:cacheKey];
    //检测有没有缓存
    if(cacheImg)
    {
        [self image:cacheImg];
        if(block){block(@"url",self);block=nil;}
        return self;
    }
    if(imgOrName)
    {
        self.image=[UIImage toImage:imgOrName];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
        if (data != nil)
        {
            if(compress>=0 && data.length>compress*1024)//>400K
            {
                UIImage *image = [[UIImage alloc]initWithData:data];
                data= [image compress:compress];//压缩图片
            }
        }
        if (data || block)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //在这里做UI操作(UI操作都要放在主线程中执行)
                if(data)
                {
                    [self image:data];
                    [Sagit.File set:cacheKey value:data];
                }
                if(block)
                {
                    block(@"url",self);
                }
            });
        }
        data=nil;
    });
    return self;
}

-(UIImageView*)pick:(OnPick)pick edit:(BOOL)yesNo
{
    return [self pick:pick edit:yesNo maxKb:256 scaleSize:CGSizeZero editScaleSize:NO];
}
-(UIImageView*)pick:(OnPick)pick edit:(BOOL)yesNo maxKb:(NSInteger)maxKb
{
    return [self pick:pick edit:yesNo maxKb:maxKb scaleSize:CGSizeZero editScaleSize:NO];
}
-(UIImageView*)pick:(OnPick)pick edit:(BOOL)yesNo maxKb:(NSInteger)maxKb scaleSize:(CGSize)scaleSize
{
    return [self pick:pick edit:yesNo maxKb:maxKb scaleSize:scaleSize editScaleSize:NO];
}
-(UIImageView*)pick:(OnPick)pick edit:(BOOL)yesNo maxKb:(NSInteger)maxKb scaleSize:(CGSize)scaleSize editScaleSize:(BOOL)editScaleSize
{
    if(pick==nil){return self;}
    [self key:@"maxKb" value:[@(maxKb) stringValue]];
    [self key:@"pickBlock" value:pick];
    [self key:@"edit" value:@(yesNo)];
    [self key:@"editScaleSize" value:@(editScaleSize)];
    [self key:@"scaleSize" value:@(scaleSize)];
    //[self setPickBlock:pick];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = yesNo && CGSizeEqualToSize(scaleSize, CGSizeZero);
    [self.stController presentViewController:picker animated:YES completion:nil];
    return self;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if([self key:@"picking"]){return;}
    [self key:@"picking" value:@"1"];//这里只允许一次选择一张，避免快速点击产生多选（先不开启一次性多选）
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[picker.allowsEditing?UIImagePickerControllerEditedImage:UIImagePickerControllerOriginalImage];
    
    NSNumber *edit=[self key:@"edit"];
    NSNumber *editScaleSize=[self key:@"editScaleSize"];
    NSValue *size=[self key:@"scaleSize"];
    if(edit.boolValue && !CGSizeEqualToSize(CGSizeZero, size.CGSizeValue))
    {
        [self showEditView:image size:size.CGSizeValue editScaleSize:editScaleSize.boolValue onCut:^(UIImage *image) {
            [self afterPick:picker info:info image:image];
        }];
    }
    else
    {
        [self afterPick:picker info:info image:image];
    }
    [Sagit delayExecute:1 onMainThread:NO block:^{
        [self key:@"picking" value:nil];
    }];
    
}
-(void)afterPick:(UIImagePickerController *)picker info:(NSDictionary<NSString *,id> *)info image:(UIImage *)image
{
    NSData *data = [image compress:[[self key:@"maxKb"] intValue]];//[Sagit.Tool compressImage:image toByte:250000];
    OnPick event = [self key:@"pickBlock"];// (OnPick)objc_getAssociatedObject(self, &pickChar);
    if(event)
    {
        event(data,picker,info);
    }
}
-(void)showEditView:(UIImage*)img size:(CGSize)size editScaleSize:(BOOL)editScaleSize onCut:(OnImageCrop)onCut
{
    if(img==nil){return;}
    [Sagit.MsgBox dialog:^(UIView *winView) {
        [[winView addUIView:nil] block:^(UIView* view) {
            [[view frame:winView.frame]  onClick:^(id view) {
                NSLog(@"...click...");
               //禁止点击退出。
            }];
            [view backgroundColor:ColorBlack];
            CropImageView *imageView=[view addSTView:@"CropImageView"];
            [imageView setPara:img scaleSize:size editScaleSize:editScaleSize];
            [[[view addButton:nil title:@"取消"] relate:LeftBottom v:40 v2:40] onClick:^(id view) {
                [winView click];
            }];
            [[[view addButton:nil title:@"选取"] relate:RightBottom v:40 v2:40] onClick:^(id view) {
                if(onCut)
                {
                    onCut([imageView cropImage]);
                }
                //处理回调
                [winView click];
            }];
        }];
    }];
}

-(UIImageView *)reSize:(CGSize)maxSize
{
    self.image=[self.image reSize:maxSize];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.image.size.width, self.image.size.height)];
    return self;
}
#pragma mark 扩展属性
-(NSString *)imageName
{
    if(self.image)
    {
        return self.image.name;
    }
    return nil;
}
-(UIImageView *)image:(id)imgOrName
{
    self.image=[UIImage toImage:imgOrName];
    if(CGSizeEqualToSize(CGSizeZero,self.frame.size))
    {
        self.image=[self.image reSize:STFullSize];
        [self frame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.image.size.width, self.image.size.height)];
    }
    return self;
}
#pragma mark 浏览查看大图、（去掉第3方图片查看）
-(void)zoom
{
    if(!Sagit.MsgBox.isDialoging)
    {
        [self show];
    }
    else
    {
        NSString *zoomScale=[self key:@"zoomScale"];
        if(zoomScale==nil)
        {
            [self key:@"oldX" value:@(self.stX)];
            [self key:@"oldY" value:@(self.stY)];
            zoomScale=@"2";
        }
        else if ([zoomScale isEqual:@"0.5"])
        {
            zoomScale=@"2";
        }
        else
        {
            zoomScale=@"0.5";
        }
        [self key:@"zoomScale" value:zoomScale];
        float scale=zoomScale.floatValue;
        //动画放大所展示的ImageView
        [UIView animateWithDuration:0.4 animations:^{
            self.transform=CGAffineTransformScale(self.transform, scale,scale);
            
           if([self.superview isKindOfClass:[UIScrollView class]])
           {
               UIScrollView *scroll=(UIScrollView*)self.superview;
               for (int i=0; i<scroll.gestureRecognizers.count; i++) {
                   scroll.gestureRecognizers[i].enabled=scale!=2;
               }
               [scroll bringSubviewToFront:self];
               if(scale!=2)
               {
                   NSString *oldX= [self key:@"oldX"];
                   NSString *oldY= [self key:@"oldY"];
                   [self x:oldX.floatValue y:oldY.floatValue];
               }
           }

        } completion:^(BOOL finished) {
            if(finished)
            {
                if(scale==2)
                {
                    [self onDrag:^BOOL(id view, UIPanGestureRecognizer *recognizer) {
                        return true;
                    }];
                }
                else
                {
                    [self removeDrag];
                    
                }
            }
        }];
    }
}
-(UIImageView *)zoom:(BOOL)yesNo
{
        if(yesNo)
       {
           [self addDbClick:@"zoom" target:self];
       }
       else
       {
           [self removeDbClick];
       }
       return self;
}
-(void)show
{
    [UIImageView show:0 images:self, nil];
}
-(UIImageView *)show:(BOOL)yesNo
{
        if(yesNo)
          {
              [self addClick:@"show" target:self];
          }
          else
          {
              [self removeClick];
          }
          return self;
}
+(void)show:(NSInteger)startIndex images:(id)imgOrNameOrArray, ...
{
    if(imgOrNameOrArray==nil){return;}
    [Sagit.MsgBox dialog:^(UIView *winView) {
        [[[winView addScrollView:nil direction:X]  addImages:imgOrNameOrArray, nil]block:^(UIScrollView* scrollView) {
            [scrollView setPagerIndex:startIndex];
            [[scrollView showPager:YES] backgroundColor:ColorBlack];

            for (int i=0; i<scrollView.subviews.count; i++) {
                UIImageView *imgView=(UIImageView*)scrollView.subviews[i];
                [[imgView longPressSave:YES] zoom:YES];
                [imgView onClick:^(id view) {
                    [winView  click];
                }];
            }
        }];
    }];
}

#pragma mark 本地验证码
-(NSString *)VerifyCode
{
    return [self key:@"VerifyCode"];
}
-(UIImageView *)VerifyCode:(NSInteger)length
{
    return [self VerifyCode:length fixBgColor:nil fixFontColor:nil];
}
-(UIImageView *)VerifyCode:(NSInteger)length fixBgColor:(UIColor *)fixColor
{
    return [self VerifyCode:length fixBgColor:fixColor fixFontColor:nil];
}
-(UIImageView *)VerifyCode:(NSInteger)length fixBgColor:(id)fixBgColor fixFontColor:(id)fixFontColor
{
    NSString *text=[self getRandomText:length];
    [self key:@"VerifyCode" value:[text toLower]];
    UIView *bgView=[self drawBackgroud:length fixBgColor:[UIColor toColor:fixBgColor]];
    UIColor *fontColor=fixFontColor!=nil?[UIColor toColor:fixFontColor]:ColorRandom;
    [[[[bgView addLabel:nil text:text font:88 color:fontColor] adjustsFontSizeToFitWidth:YES] textAlignment:NSTextAlignmentCenter] block:^(UILabel* view) {
        [view x:0 y:0 width:bgView.stWidth height:bgView.stHeight];
    }];
    self.image=nil;
    self.image=bgView.asImage;
    if([self key:@"click"]==nil)
    {
        [self onClick:^(UIImageView* view) {
            [view VerifyCode:length fixBgColor:fixBgColor fixFontColor:fixFontColor];
        }];
    }
    return self;
}
-(NSString*)getRandomText:(NSInteger)length
{
    //@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
    NSArray *arr=@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"j",@"k",@"m",@"n",@"p",@"r",@"s",@"t",@"w",@"x",@"y",@"z"];
     NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:length];
       for (int i = 0 ; i<length ; i ++) {
          int index = arc4random() % arr.count;
           [newString appendFormat:@"%@",arr[index]];
       }
       return newString;
}
-(UIView*)drawBackgroud:(NSInteger)length fixBgColor:(UIColor *)fixBgColor
{
    UIView *view=[[UIView alloc]initWithFrame:self.frame];
    if(fixBgColor!=nil)
    {
       return [view backgroundColor:fixBgColor];
    }
    NSInteger splitHeight=3;
    NSInteger width=view.stWidth/length;
    NSInteger height=view.stHeight/splitHeight;
    NSInteger x=0,y=0;
    UIColor *cornerColor=ColorBlack;
    UIColor *y1Color=ColorWhite;
    for (int i=0; i<length*splitHeight; i++) {
        UIColor *color= ((x==0 && y==0) || (x==0 && y==splitHeight-1) || (x==length-1 && y==0) ||(x==length-1 && y==splitHeight-1))?cornerColor:[ColorRandom alpha:0.2];
        if(y==1){color=y1Color;}
        [[[[view addUIView:nil]  width:width height:height] relate:LeftTop v:x*width v2:y*height] block:^(UIView* bgView) {
            [bgView backgroundColor:color];
        }];
        x++;
               if(x/length==1)
               {
                   y++;
                   x=0;
               }
    }
    return view;
}
@end



