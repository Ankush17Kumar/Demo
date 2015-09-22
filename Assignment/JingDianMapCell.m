

#import "JingDianMapCell.h"

@implementation JingDianMapCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imgPlaceImage.layer.cornerRadius=22.5;
        self.imgPlaceImage.layer.masksToBounds=YES;
   
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
