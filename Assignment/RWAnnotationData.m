

#import "RWAnnotationData.h"

@implementation RWAnnotationData
@synthesize title,coordinate,subtitle,identity,Loactionid,place,section;
-(id) initWithPlace: (Place*) p
{
	self = [super init];
	if (self != nil) {
		coordinate.latitude = p.latitude;
		coordinate.longitude = p.longitude;
		self.place = p;
	}
	return self;
}

@end
