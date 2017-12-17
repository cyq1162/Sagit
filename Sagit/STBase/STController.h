//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STHttp.h"
#import "STMessageBox.h"
#import "STEnum.h"

@class STView;
@interface STController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,strong) STView* stView;
@property (nonatomic,retain) STHttp *http;
@property (nonatomic,retain) STMessageBox *box;
//所有name的控件
@property (nonatomic,retain) NSMutableDictionary *UIList;

//如果没有对应的View，[子类重写]
-(void)initUI;

-(NSString*)stValue:(NSString*)name;
-(void)stValue:(NSString*)name value:(NSString*)value;
//验证文本枉的值是否填写或格式是否错误
-(BOOL)isMatch:(NSString*)tipMsg uiName:(NSString*)name;
-(BOOL)isMatch:(NSString*)tipMsg uiName:(NSString*)name regex:(NSString*)pattern;
-(BOOL)isMatch:(NSString*)tipMsg v:(NSString*)value;
-(BOOL)isMatch:(NSString*)tipMsg v:(NSString*)value regex:(NSString*)pattern;
-(BOOL)isMatch:(NSString*)tipMsg isMatch:(BOOL)result;


//-(id)data:(NSString*)key;
//-(void)setData:(NSString*)key v:(NSString*)value;
-(void)loadData:(NSDictionary*)data;
-(NSMutableDictionary*)formData;
-(NSMutableDictionary*)formData:(id)superView;


-(void)open:(UITapGestureRecognizer*)recognizer;

-(void)asRoot:(RootViewControllerType) rootType;
@end
