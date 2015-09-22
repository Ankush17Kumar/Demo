

#import <UIKit/UIKit.h>
#import "MyPlaces.h"
#import "DetailViewController.h"


@interface ViewController : UIViewController<passDataWithDelegate>
{
    IBOutlet UISlider *slider;
    IBOutlet UITableView *tblCategory;
    IBOutlet UILabel *lblSliderValue;
   
    API *singleObject;
    NSArray *arrTypes;
    NSMutableArray *arrData;
    NSInteger indexToPass;
}
- (IBAction)actionSlider:(id)sender;


@end

