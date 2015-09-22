

#import "DetailViewController.h"

@interface DetailViewController ()
{
    BOOL flipped;
    BOOL isAll;
    
}

@end

@implementation DetailViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id del = [[UIApplication sharedApplication] delegate];
    if ([del performSelector:@selector(managedObjectContext)]) {
        context = [del managedObjectContext];
    }
    return context;
}
@synthesize arrTotal,arrCoreData,arrCoreTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrCoreTable=[[NSMutableArray alloc]init];
    arrMapData  =[[NSMutableArray alloc]init];
    lblTitle.text=self.strTitle;
    
    UIView *vw=[[UIView alloc]init];
    vw.backgroundColor=[UIColor clearColor];
    [tblDetail setTableFooterView:vw];
    
    [self ShowFavoriteData];

    
    for (NSManagedObject *objId in arrCoreData)
    {
        for (MyPlaces *obj1 in arrTotal)
        {
            if ([obj1.strId isEqualToString:[objId valueForKey:@"id"]])
            {
            obj1.strIsFav=@"1";
            }
        }
    }
    [tblDetail reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark IBACTIONS

- (IBAction)actionMapList:(id)sender {
    [self ShowFavoriteData];
    [UIView transitionWithView:vwMap
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        
                        if (!flipped) {
                            [btnMap setTitle:@"List" forState:UIControlStateNormal];
                            tblDetail.hidden=YES;
                            vwAllFavorite.hidden=YES;
                            vwMap.hidden=NO;
                            [self showAnnotationOnMap];
                            flipped = YES;
                        } else {
                            [btnMap setTitle:@"Map" forState:UIControlStateNormal];
                            vwMap.hidden=YES;
                            tblDetail.hidden=NO;
                            vwAllFavorite.hidden=NO;
                            flipped = NO;
                        }
                        
                    } completion:nil];
}
- (IBAction)actionAllFavorite:(id)sender {
    UIButton *btn=(UIButton *)sender;
    
    if (btn.tag==101)
    {
        isAll=NO;
        [btnAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnAll.backgroundColor=[UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1];
        [btnFavorite setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btnFavorite.backgroundColor=[UIColor whiteColor];
        [tblDetail reloadData];
    }
     else
    {
        isAll=YES;
        [self createObjectArray];
        [btnFavorite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnFavorite.backgroundColor=[UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1];
        [btnAll setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btnAll.backgroundColor=[UIColor whiteColor];
    }
}

- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark REQUIRED METHODS
 //DOWNLOADING IMAGE ASYNCHRONOUSLY
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

//CREATE ARRAY OF OBJECTS FROM NSMANAGED CONTEXT COREDATA
-(void)createObjectArray
{
    [self ShowFavoriteData];
    [arrCoreTable removeAllObjects];
    for (int i=0; i<arrCoreData.count; i++)
    {
        NSManagedObject *objCore = [arrCoreData objectAtIndex:i];
        MyPlaces *obj=[[MyPlaces alloc]init];
        obj.strId=[objCore valueForKey:@"id"];
        obj.strName=[objCore valueForKey:@"name"];
        obj.strLat=[objCore valueForKey:@"lat"];
        obj.strLong=[objCore valueForKey:@"long"];
        obj.strImage=[objCore valueForKey:@"image"];
        obj.strIsFav=[objCore valueForKey:@"isFav"];
        [arrCoreTable addObject:obj];
    }
    [tblDetail reloadData];
    
}



//SHOW ANNOTATIONS ON MAP
-(void)showAnnotationOnMap
{
    [mapLive removeAnnotations:mapLive.annotations];
    if (!isAll) {
        arrMapData=arrTotal;
    }
    else
    {
        arrMapData=arrCoreTable;
    }
    
    
    if (arrMapData.count>0)
    {
        NSMutableArray* annotations=[[NSMutableArray alloc] init];
        for (int i=0; i<arrMapData.count; i++) {
            MyPlaces *holder=(MyPlaces *)[arrMapData objectAtIndex:i];
            CLLocationCoordinate2D location1;
            
            location1.latitude= [holder.strLat floatValue];
            location1.longitude= [holder.strLong floatValue];
            
            RWAnnotationData* myAnnotation=[[RWAnnotationData alloc] init];
            myAnnotation.coordinate=location1;
            myAnnotation.identity=i;
            [annotations addObject: myAnnotation];
            [mapLive addAnnotation:myAnnotation];
        }
        [self adjustMap];
        
    }
}

#pragma mark CORE DATA

//STORE DELETE DATA FROM COREDATA
-(void)tapped:(id)sender
{
    CustomButton *btn=(CustomButton *)sender;
    MyPlaces *obj=(MyPlaces*)[arrTotal objectAtIndex:btn.selectedIndex];
    
    BOOL isPresent;
    isPresent=NO;
    for (NSManagedObject *objId in arrCoreData)
    {
        if ([[objId valueForKey:@"id"] isEqualToString:obj.strId])
        {
            isPresent=YES;
            break;
        }
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (isPresent)
    {
        obj.strIsFav=@"0";
        if (arrCoreData.count > 0)
        {
            for(NSManagedObject *managedObject in arrCoreData)
            {
                if ([[managedObject valueForKey:@"id"] isEqualToString:obj.strId])
                {
                    [context deleteObject:managedObject];
                }
            }
            //Save context to write to store
            [context save:nil];
        }
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataIsFav"];
        arrCoreData = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    }
    else
    {
        obj.strIsFav=@"1";
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"DataIsFav" inManagedObjectContext:context];
        [newDevice setValue:obj.strId forKey:@"id"];
        [newDevice setValue:obj.strIsFav forKey:@"isFav"];
        [newDevice setValue:obj.strName forKey:@"name"];
        [newDevice setValue:obj.strImage forKey:@"image"];
        [newDevice setValue:[NSString stringWithFormat:@"%@",obj.strLat] forKey:@"lat"];
        [newDevice setValue:[NSString stringWithFormat:@"%@",obj.strLong] forKey:@"long"];
    }
    
    
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    [self ShowFavoriteData];
}


//FETCH DATA FROM COREDATA
-(void)ShowFavoriteData
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataIsFav"];
    arrCoreData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [tblDetail reloadData];
}

#pragma mark UITABLEVIEW DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!isAll)
        return arrTotal.count;
    else
        return arrCoreTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdent=@"Cell";
    UITableViewCell *Cell=[tblDetail dequeueReusableCellWithIdentifier:cellIdent];
    [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    MyPlaces *obj;
    
    //DATA TO DISPLAY ON TABLEVIEW (LIKE ALL DATA OR FAVORITE DATA)
    if (!isAll) {
        obj=(MyPlaces*)[arrTotal objectAtIndex:indexPath.row];
    }else{
        obj=(MyPlaces*)[arrCoreTable objectAtIndex:indexPath.row];
    }
    
    UIImageView *img=(UIImageView *)[Cell.contentView viewWithTag:101];
    UILabel *lblCategory=(UILabel*)[Cell.contentView viewWithTag:102];
    UIImageView *imgIsFav=(UIImageView *)[Cell.contentView viewWithTag:104];
    CustomButton *btn=(CustomButton *)[Cell.contentView viewWithTag:103];
    
    [btn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    btn.selectedIndex=indexPath.row;
    
    img.layer.cornerRadius=10;
    img.layer.masksToBounds=YES;
    
    lblCategory.text=obj.strName;
    
    //DISPLAY FAVORITE PALACE
    if ([obj.strIsFav isEqualToString:@"1"])
    {
        imgIsFav.image=[UIImage imageNamed:@"StarSelected.png"];
    }
    else
    {
        imgIsFav.image=[UIImage imageNamed:@"Star.png"];
    }
    
    
    if (isAll)
    {
        btn.hidden=YES;
        imgIsFav.hidden=YES;
    }
    else
    {
        btn.hidden=NO;
        imgIsFav.hidden=NO;
    }
    
    
    
    
    
    //DOWNLOADING IMAGE ASYNCHRONOUSLY AND DISPLAY ON CELL
    
    if (obj.image)
    {
        img.image = obj.image;
    }
    else
    {
        // set default user image while image is being downloaded
        img.image = [UIImage imageNamed:@"placeholder.jpg"];
        
        // download the image asynchronously
        NSURL *url=[NSURL URLWithString:obj.strImage];
        [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                img.image = image;
                
                // cache the image for use later (when scrolling up)
                obj.image = image;
            }
        }];
    }
    
    
   
    return Cell;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



#pragma mark- MAPVIEW DELEGATE METHOD

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
       if ([annotation isKindOfClass:[RWAnnotationData class]])
       {
            MKAnnotationView *pinView = nil;
            static NSString *defaultPinID = @"com.invasivecode.pin";
            pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
            if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                           initWithAnnotation:annotation reuseIdentifier:defaultPinID];

        }
    
    // SET CUSTOM CALLOUT ON TAPPING ANNOTATION IN MAPVIEW
       if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
        {
            CalloutMapAnnotation *bm    = (CalloutMapAnnotation *)annotation;
            
            CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
            
            if (!annotationView)
            {
                annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
                for (JingDianMapCell *cell in annotationView.contentView.subviews)
                {
                    [cell removeFromSuperview];
                }
                JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
                [annotationView.contentView addSubview:cell];
            }
           
            
            MyPlaces *obj=(MyPlaces *)[arrMapData objectAtIndex:bm.str1];
            
            UIImageView *imgPlace    = (UIImageView*)[annotationView viewWithTag:1];
            UILabel *lblPlaceName      = (UILabel*)[annotationView viewWithTag:2];
            
            imgPlace.layer.cornerRadius = 22;
            imgPlace.clipsToBounds = YES;
            
            lblPlaceName.text=obj.strName;
            
            
            if (obj.image)
            {
                imgPlace.image = obj.image;
            }
            else
            {
               imgPlace.image = [UIImage imageNamed:@"placeholder.jpg"];
               NSURL *url=[NSURL URLWithString:obj.strImage];
                
                [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image)
                {
                    if (succeeded)
                    {
                        imgPlace.image = image;
                        obj.image = image;
                    }
                }];
            }
 
            return annotationView;
        }
    return nil;
    
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
        if ([view.annotation isKindOfClass:[RWAnnotationData class]])
        {
            RWAnnotationData *bm1 = (RWAnnotationData *)view.annotation;
            
            if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
                _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude)
            {
                return;
            }
            if (_calloutAnnotation)
            {
                [mapView removeAnnotation:_calloutAnnotation];
                _calloutAnnotation = nil;
            }
            _calloutAnnotation = [[CalloutMapAnnotation alloc]
                                  initWithLatitude:view.annotation.coordinate.latitude
                                  andLongitude:view.annotation.coordinate.longitude];
            [mapView addAnnotation:_calloutAnnotation];
            _calloutAnnotation.str1=bm1.identity;
        }

    
    if (![view.annotation isKindOfClass:[mapView.userLocation class]])
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationVifew class]])
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

//ADD A LITTLE EXTRA SPACE ON THE SIDES OF ANNOTATIONS

-(void)adjustMap
{
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapLive.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapLive regionThatFits:region];
    [mapLive setRegion:region animated:YES];
}

@end
