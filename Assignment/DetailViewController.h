

#import <UIKit/UIKit.h>
#import "MyPlaces.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "CustomButton.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#import "RWAnnotationData.h"

@protocol MapViewControllerDidSelectDelegate;
@interface DetailViewController : UIViewController<MKMapViewDelegate>
{
    CalloutMapAnnotation *_calloutAnnotation;
    id<MapViewControllerDidSelectDelegate> delegate;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnFavorite;
    IBOutlet UIView *vwAllFavorite;
    
    IBOutlet MKMapView *mapLive;
    IBOutlet UIButton *btnAll;
    IBOutlet UIButton *btnMap;
    IBOutlet UIView *vwMap;
    IBOutlet UITableView *tblDetail;
    NSMutableArray *arrMapData;
}
@property (strong,nonatomic)NSMutableArray *arrCoreTable;
@property (strong,nonatomic)NSMutableArray *arrTotal;
@property (strong)NSMutableArray *arrCoreData;
@property (strong,nonatomic)NSString *strTitle;
//@property(nonatomic,assign)id<MapViewControllerDidSelectDelegate> delegate;
- (IBAction)actionMapList:(id)sender;
- (IBAction)actionAllFavorite:(id)sender;
- (IBAction)Back:(id)sender;

@end

@protocol MapViewControllerDidSelectDelegate <NSObject>



@end

