

#define INTERNET_TIMEOUT 
#import "API.h"

@implementation API
@synthesize alert;

+(id)sharedManager
{
    static API *sharedMyManager=nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager=[[self alloc] init];
    });
    
    return sharedMyManager;
}

-(instancetype)init
{
    return self;
}


-(NSDictionary*)getDataOnlyURL:(NSString*)strUrl with:(int)APINo
{
    
    NSURL *url=[NSURL URLWithString:strUrl];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer=[AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dict=responseObject;
         
         [self.delegate passDataWithDictionary:dict with:APINo];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.delegate didFailPassingDta:error];
     }];
    [operation start];
    return nil;
}


-(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message
{
    alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


@end
