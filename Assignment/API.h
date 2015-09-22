

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@protocol passDataWithDelegate <NSObject>

@required
-(void)didFailPassingDta:(NSError *)error;

@optional
-(void )passDataWithDictionary:(NSDictionary*)dict with:(int)APINo;
@end


@interface API : NSObject
{
    
}

@property (strong,nonatomic) id<passDataWithDelegate> delegate;
@property (nonatomic,strong) UIAlertView *alert;

+(id)sharedManager;

-(NSDictionary*)getDataOnlyURL:(NSString*)strUrl with:(int)APINo;
//Show Alert VIew
-(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message;




@end
