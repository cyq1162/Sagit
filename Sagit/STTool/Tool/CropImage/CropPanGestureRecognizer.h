
#import <UIKit/UIKit.h>

@interface CropPanGestureRecognizer : UIPanGestureRecognizer

@property(assign, nonatomic) CGPoint beginPoint;
@property(assign, nonatomic) CGPoint movePoint;

-(instancetype)initWithTarget:(id)target action:(SEL)action inview:(UIView*)view;


@end
