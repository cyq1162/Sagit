
#import <UIKit/UIKit.h>
#import "STView.h"
@interface CropImageView : STView
-(CropImageView*)setPara:(UIImage*)image scaleSize:(CGSize)scaleSize editScaleSize:(BOOL)editScaleSize;
- (UIImage*)cropImage;
@end
