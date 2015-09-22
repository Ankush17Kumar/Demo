
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@interface RWAnnotationData : NSObject<MKAnnotation> {
	
	CLLocationCoordinate2D	coordinate;
	NSString*				title;
	NSString*				subtitle;
    NSInteger   identity;
	Place* place;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) Place* place;
@property (nonatomic, copy)		NSString*				title;
@property (nonatomic, copy)		NSString*				subtitle;
@property NSInteger   identity;
@property NSInteger   section;
@property (nonatomic, strong) NSString *Loactionid;
-(id) initWithPlace: (Place*) p;

@end