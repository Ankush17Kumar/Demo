
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    singleObject =[API sharedManager];
    singleObject.delegate=self;
    
    [self.navigationController setNavigationBarHidden:YES];

    arrTypes=[[NSArray alloc]initWithObjects:@"Food",@"Gym",@"School",@"Hospital",@"Spa",@"Restaurant", nil];
    lblSliderValue.text=[NSString stringWithFormat:@"%ld M",(long)[self GetIntegervalue:slider.value]];
    
    UIView *vw=[[UIView alloc]init];
    vw.backgroundColor=[UIColor clearColor];
    [tblCategory setTableFooterView:vw];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITABLEVIEW DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *lblCategory=(UILabel*)[Cell.contentView viewWithTag:101];
    lblCategory.text=[arrTypes objectAtIndex:indexPath.row];
    
    return Cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexToPass=indexPath.row;
    NSUserDefaults *data=[NSUserDefaults standardUserDefaults];
    
    NSString *lowerCase = [[arrTypes objectAtIndex:indexPath.row] lowercaseString];
    NSString *strMain=@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=";
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@,%@&radius=%ld&types=%@&key=%@",strMain,[data valueForKey:KEY_LAT],[data valueForKey:KEY_LONG],(long)[self GetIntegervalue:slider.value],lowerCase,KEY_GOOGLE_API];
    
    
    if ([data valueForKey:KEY_LAT]&&[data valueForKey:KEY_LONG])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [singleObject getDataOnlyURL:strUrl with:1];
    }else
    {
        [singleObject showAlertWithTitle:@"Assignment" withMessage:@"App does not have access to your location. To allow this app to access to your location please enable it from the Settings menu."];
    }
   
   
}


#pragma mark API RESPONSE
-(void)passDataWithDictionary:(NSDictionary *)dict with:(int)APINo
{
   [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"%@",dict);
    
    if (APINo==1) {
        NSMutableArray *arrResult=[dict valueForKey:@"results"];
        
        if (arrResult.count>0)
        {
            arrData=[[NSMutableArray alloc]init];
            for (int i=0; i<arrResult.count; i++)
            {
                NSDictionary *temp=[arrResult objectAtIndex:i];
                MyPlaces *obj=[[MyPlaces alloc]init];
                obj.strLat=[temp valueForKeyPath:@"geometry.location.lat"];
                obj.strLong=[temp valueForKeyPath:@"geometry.location.lng"];
                obj.strName=[temp valueForKey:@"name"];
                obj.strId=[temp valueForKey:@"id"];

                
             if([temp valueForKey:@"photos"] != nil)
                {
                    NSDictionary *di=[[temp valueForKey:@"photos"]objectAtIndex:0];
                    obj.strPhotoRefrence=[NSString stringWithFormat:@"%@",[di valueForKey:@"photo_reference"]];
                    obj.strImage=[self getImage:obj.strPhotoRefrence];
                }
                else
                {
                    obj.strPhotoRefrence=@"";
                    obj.strImage=[temp valueForKey:@"icon"];
                }
                 [arrData addObject:obj];
                
            }
           
            DetailViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
            vc.arrTotal=arrData;
            vc.strTitle=[arrTypes objectAtIndex:indexToPass];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else
        {
            [singleObject showAlertWithTitle:@"Assignment" withMessage:@"No record found"];
        }
    }
    

}

-(void)didFailPassingDta:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
     NSLog(@"%@",error);
    [singleObject showAlertWithTitle:@"" withMessage:@"Please try again. Unable to process your request"];
}

#pragma mark REQUIRED METHODS

//FOR GENERATING URL OF THE IMAGE FROM PHOTO REFERENCE
-(NSString*)getImage :(NSString *)strImage
{
    NSString *strMain=@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&photoreference=";
    NSString *strUrl=[NSString stringWithFormat:@"%@%@&key=%@",strMain,strImage,KEY_GOOGLE_API];
    return strUrl;
    
}
//RETURN INTEGER VALUE FROM SLIDER VALUE TO SHOW ON LABEL
-(NSInteger)GetIntegervalue:(float)Value
{
    NSInteger val;
    val=Value;
    return val;
}
- (IBAction)actionSlider:(id)sender {

    lblSliderValue.text=[NSString stringWithFormat:@"%ld M",(long)[self GetIntegervalue:slider.value]];
}


@end
