//
//  ImagesListViewController.m
//  TechM-Ankur
//
//  Created by Ankur Patel on 24/05/16.
//  Copyright © 2016 Ankur Patel. All rights reserved.
//

#import "ImagesListViewController.h"
#import "NSObject+SBJson.h"
#import "Reachability.h"
#import "ImageDetails.h"
#import "CommonFunc.h"
#import "WriteImage.h"

#import "GZIP.h"
#import "APICall.h"

float screenWidth = 320;
float screenHeight = 568;
#define FONT_SIZE_TEXT_IPHONE 15
#define PADDING_BET_CELL 5

@interface ImagesListViewController ()
{
    ImageDetails *objImageDetails;
}
@end

@implementation ImagesListViewController

#pragma mark - view did load

@synthesize viewNavBar,lblNavTitle,tableViewImages;



- (void)viewDidUnload
{
    objImageDetails = nil;
    self.viewNavBar = nil;
    self.lblNavTitle = nil;
    self.tableViewImages = nil;
    
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // this method make design
    
    [self initialObjects];
    // check internet connection
    [self checkInternetConnection:@"https://www.google.co.in"];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:TRUE];
    self.navigationController.navigationBarHidden = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create design

-(void)initialObjects
{
    // this is universal application. i do not need to use AutoLayout in this application becuase UI expand accoording to screen size. Thanks
    // Create viewIndicator view
    
    self.viewIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    self.viewIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.viewIndicator.color = [UIColor colorWithRed:45.0/255.0 green:189.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.viewIndicator.backgroundColor = [UIColor colorWithRed:0.0/0.0 green:0.0/0.0 blue:0.0/0.0 alpha:0.7];
    [self.view addSubview:self.viewIndicator];
    
    // Create navigation bar
    
    self.viewNavBar = [[UIView alloc]init];
    self.viewNavBar.frame = CGRectMake(0, 0, self.view.frame.size.width*(320/screenWidth), self.view.frame.size.height*(64/screenHeight));
    [self.viewNavBar setBackgroundColor:[UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0]];
    [self.view addSubview:self.viewNavBar];
    
    // Create navigation bar
    
    CGSize sizeCalLblNavTitle = CGSizeMake(self.view.frame.size.width*(150/screenWidth), self.view.frame.size.height*(44/screenHeight));
    self.lblNavTitle = [[UILabel alloc]initWithFrame:CGRectMake((self.viewNavBar.frame.size.width-sizeCalLblNavTitle.width)/2, (self.viewNavBar.frame.size.height-sizeCalLblNavTitle.height)/2, sizeCalLblNavTitle.width, sizeCalLblNavTitle.height)];
    self.lblNavTitle.numberOfLines = 0;
    [self.lblNavTitle setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:FONT_SIZE_TEXT_IPHONE]];
    //self.lblNavTitle.text = @"Nav Title";
    self.lblNavTitle.textAlignment  = NSTextAlignmentCenter;
    self.lblNavTitle.textColor = [UIColor whiteColor];
    [self.viewNavBar addSubview:self.lblNavTitle];
    [self.lblNavTitle setBackgroundColor:[UIColor clearColor]];
    
    // Create refresh button
    
    UIButton *btnRefersh = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize sizeCalBtnRefresh = CGSizeMake(self.view.frame.size.width*(30/screenWidth), self.view.frame.size.height*(30/screenHeight));
    btnRefersh.frame = CGRectMake(self.viewNavBar.frame.size.width-sizeCalBtnRefresh.width-20, (self.viewNavBar.frame.size.height-sizeCalBtnRefresh.height)/2, sizeCalBtnRefresh.width, sizeCalBtnRefresh.height);
    btnRefersh.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:FONT_SIZE_TEXT_IPHONE];
    [btnRefersh setTitle:@"Ref" forState:UIControlStateNormal];
    [btnRefersh setTitle:@"Ref" forState:UIControlStateHighlighted];
    [btnRefersh addTarget:self action:@selector(btnRefershClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnRefersh setBackgroundColor:[UIColor clearColor]];
    [self.viewNavBar addSubview:btnRefersh];
    
    
    NSLog(@"view : %f %f %f %f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    NSLog(@"self.viewNavBar : %f %f %f %f %f %f",self.viewNavBar.frame.origin.x,self.viewNavBar.frame.origin.y,self.viewNavBar.frame.size.width,self.viewNavBar.frame.size.height,(320/screenWidth),(64/screenHeight));
    
    // Create tableView for Images
    
    self.tableViewImages = [[UITableView alloc]init];
    self.tableViewImages.frame = CGRectMake(0, self.viewNavBar.frame.origin.y + self.viewNavBar.frame.size.height, self.view.frame.size.width*(320/screenWidth), self.view.frame.size.height*(504/screenHeight));
    self.tableViewImages.tag = 1;
    self.tableViewImages.delegate = self;
    self.tableViewImages.dataSource = self;
    self.tableViewImages.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableViewImages];
    
    
    // Call API to get Data
    [self startLoader];
    [self getImageDetails];
        
}

#pragma mark - check user internet resources

-(void)checkInternetConnection:(NSString *)strLink
{
    
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        [self alertViewInternetConnection];
        
    }
    else if (status == ReachableViaWiFi)
    {
        [self alertViewInternetConnection:@"Message" message:@"You are using wifi netwerok" cancelBtnTitle:@"Ok"];
        
    }
    else if (status == ReachableViaWWAN)
    {
        [self alertViewInternetConnection:@"Message" message:@"You are using cellular data" cancelBtnTitle:@"Ok"];
    }
}


#pragma mark - start stop activityindicator

-(void)startLoader
{
    
    [self.viewIndicator startAnimating];
}

-(void)stopLoader
{
    
    [self.viewIndicator stopAnimating];
}

#pragma mark - btn Refersh Click

- (IBAction)btnRefershClick:(id)sender
{
    [self startLoader];
    [self getImageDetails];
}


#pragma mark - get image deatils from server callinga api

-(void)getImageDetails
{
    /*
     NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
     NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/746330/facts.json"];
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
     cachePolicy:NSURLRequestUseProtocolCachePolicy
     timeoutInterval:60.0];
     [request setHTTPMethod:@"GET"];
     
     NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     
     // unGzip Data
     
     NSUInteger capacity = data.length * 2;
     NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
     const unsigned char *buf = data.bytes;
     NSInteger i;
     for (i=0; i<data.length; ++i) {
     [sbuf appendFormat:@"%02X", (NSUInteger)buf[i]];
     }
     
     NSString * str = sbuf;
     NSMutableString * strTemp = [[NSMutableString alloc] init];
     int z = 0;
     while (z < [str length])
     {
     NSString * hexChar = [str substringWithRange: NSMakeRange(z, 2)];
     int value = 0;
     sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
     [strTemp appendFormat:@"%c", (char)value];
     z+=2;
     }
     
     NSDictionary *dictResponse = [strTemp JSONValue];
     NSLog(@"dictResponse : %@",dictResponse);
     if(dictResponse != nil)
     {
     [self getImageDetailsDict:dictResponse];
     return ;
     }
     
     [self alertViewInternetConnection];
     }];
     
     [postDataTask resume];
     */
    
    
    [self setSharedCacheForImages];
    
    NSURLSession *session = [self prepareSessionForRequest];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://dl.dropboxusercontent.com/u/746330" stringByAppendingPathComponent:@"facts.json"]]];
    [request setHTTPMethod:@"GET"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            // i think this Data is not in Gzip Format
            
            NSLog(@"isGzippedData : %d",[data isGzippedData]);
            
            NSUInteger capacity = data.length * 2;
            NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
            const unsigned char *buf = data.bytes;
            NSInteger i;
            for (i=0; i<data.length; ++i) {
                [sbuf appendFormat:@"%02lX", (unsigned long)buf[i]];
            }
            
            NSString * str = sbuf;
            NSMutableString * strTemp = [[NSMutableString alloc] init];
            int z = 0;
            while (z < [str length])
            {
                NSString * hexChar = [str substringWithRange: NSMakeRange(z, 2)];
                int value = 0;
                sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
                [strTemp appendFormat:@"%c", (char)value];
                z+=2;
            }
            
            NSDictionary *dictResponse = [strTemp JSONValue];
            NSLog(@"dictResponse : %@",dictResponse);
            if(dictResponse != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self startLoader];
                    [self getImageDetailsDict:dictResponse];
                    
                });
                
                return ;
            }
            
            // response is not in proper format then show Message
            
            [self alertViewInternetConnection];
            
        }
        else
        {
            // error message from API api
            
            NSLog(@"Error: %@", error.localizedDescription);
            [self alertViewInternetConnection:@"Error" message:error.localizedDescription cancelBtnTitle:@"Ok"];
        }
    }];
    [dataTask resume];
    
}

- (void)setSharedCacheForImages
{
    NSUInteger cashSize = 250 * 1024 * 1024;
    NSUInteger cashDiskSize = 250 * 1024 * 1024;
    NSURLCache *imageCache = [[NSURLCache alloc] initWithMemoryCapacity:cashSize diskCapacity:cashDiskSize diskPath:@"someCachePath"];
    [NSURLCache setSharedURLCache:imageCache];
}

- (NSURLSession *)prepareSessionForRequest
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setHTTPAdditionalHeaders:@{@"Content-Encoding": @"gzip", @"Content-Type": @"text/plain; charset=ISO-8859-1"}];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    return session;
}


-(void)getImageDetailsDict:(NSDictionary *)dict
{
    NSString *str = [dict objectForKey:@"error"];
    
    if(str.length > 0)
    {
        [self alertViewInternetConnection:@"Message" message:str cancelBtnTitle:@"Ok"];
        return;
    }
    
    NSLog(@"title : %@",[dict objectForKey:@"title"]);
    
    objImageDetails = [ImageDetails new];
    objImageDetails.arrImagesDeatils = [[NSMutableArray alloc]init];
    objImageDetails.arrImagesDeatils = [dict objectForKey:@"rows"];
    
    for(int i=0;i<objImageDetails.arrImagesDeatils.count;i++)
    {
        NSMutableDictionary *tempDict =[objImageDetails.arrImagesDeatils objectAtIndex:i];
        [tempDict setObject:@"320,320" forKey:@"imgSize"];
        [objImageDetails.arrImagesDeatils replaceObjectAtIndex:i withObject:tempDict];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        //Wants to update UI or perform any task on main thread.
        self.lblNavTitle.text = [dict objectForKey:@"title"];
        NSLog(@"objImageDetails.arrImagesDeatils : %@",objImageDetails.arrImagesDeatils);
        [self.tableViewImages reloadData];
        [self stopLoader];
    });
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableViewImages.tag == 1 )
    {
        return 1;
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.tableViewImages.tag == 1)
    {
        return objImageDetails.arrImagesDeatils.count;
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (indexPath.section == 0)
    {
        if(tableView.tag == 1 )
        {
            NSMutableDictionary *tempDict = [objImageDetails.arrImagesDeatils objectAtIndex:indexPath.row];
            CGRect sizeLblContain = [self getImageDescContentHeight:[self makeImgDescriptionWithTile:[tempDict objectForKey:@"title"] stringImgDesc:[tempDict objectForKey:@"description"]]];
            
            if(![[tempDict objectForKey:@"imageHref"] isEqual:[NSNull null]])
            {
                NSArray *arrTemp = [[tempDict objectForKey:@"imgSize"] componentsSeparatedByString:@","];
                return sizeLblContain.size.height+[[arrTemp objectAtIndex:1] integerValue];
            }
            
            return sizeLblContain.size.height + PADDING_BET_CELL;
        }
    }
    return 0;
    
}

-(NSMutableAttributedString *)makeImgDescriptionWithTile:(NSString *)strImgTitle stringImgDesc:(NSString *)strImgDesc
{
    
    NSMutableAttributedString *strContent = nil;
    if(![strImgTitle isEqual:[NSNull null]])
    {
        strContent = [CommonFunc colorWordString:[NSString stringWithFormat:@"%@",strImgTitle] firstText:strImgTitle secondText:@""];
    }
    
    if(![strImgDesc isEqual:[NSNull null]])
    {
        strContent = [CommonFunc colorWordString:[NSString stringWithFormat:@"%@",strImgDesc] firstText:strImgDesc secondText:@""];
        
        if(![strImgTitle isEqual:[NSNull null]])
        {
            strContent = [CommonFunc colorWordString:[NSString stringWithFormat:@"%@ : %@",strImgTitle,strImgDesc] firstText:strImgTitle secondText:strImgDesc];
        }
        
    }
    
    return strContent;
}

-(CGRect)getImageDescContentHeight:(NSMutableAttributedString *)strImgContent
{
    // calculate dynamic size of label
    
    CGSize constraint;
    constraint = CGSizeMake(self.tableViewImages.frame.size.width, 20000.0f);
    
    CGRect sizeLblContain = [strImgContent.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:FONT_SIZE_TEXT_IPHONE]}context:nil];
    return sizeLblContain;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        
        if(tableView.tag == 1)
        {
            
            NSMutableDictionary *tempDict = [objImageDetails.arrImagesDeatils objectAtIndex:indexPath.row];
            
            UILabel *lblImagDesc;
            UIImageView *imgViewFromServer;
            
            CGRect sizeLblContain = [self getImageDescContentHeight:[self makeImgDescriptionWithTile:[tempDict objectForKey:@"title"] stringImgDesc:[tempDict objectForKey:@"description"]]];
            
            lblImagDesc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableViewImages.frame.size.width,sizeLblContain.size.height)];
            [lblImagDesc setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:FONT_SIZE_TEXT_IPHONE]];
            //lblImagDesc.textColor = [UIColor darkGrayColor];
            //[lblImagDesc setText:[self makeImgDescriptionWithTile:[tempDict objectForKey:@"title"] stringImgDesc:[tempDict objectForKey:@"description"]]];
            [lblImagDesc setAttributedText:[self makeImgDescriptionWithTile:[tempDict objectForKey:@"title"] stringImgDesc:[tempDict objectForKey:@"description"]]];
            lblImagDesc.numberOfLines = 0;
            [cell addSubview:lblImagDesc];
            
            if(![[tempDict objectForKey:@"imageHref"] isEqual:[NSNull null]])
            {
                NSArray *arrTemp = [[tempDict objectForKey:@"imgSize"] componentsSeparatedByString:@","];
                imgViewFromServer = [[UIImageView alloc]initWithFrame:CGRectMake(lblImagDesc.frame.origin.x, lblImagDesc.frame.origin.y+lblImagDesc.frame.size.height, self.tableViewImages.frame.size.width, [[arrTemp objectAtIndex:1] integerValue])];
                //imgViewFromServer.contentMode = UIViewContentModeScaleToFill;
                //imgViewFromServer.contentMode = UIViewContentModeScaleAspectFit;
                //imgViewFromServer.image = [UIImage imageNamed:@"default-profile-pic.png"];
                [cell addSubview:imgViewFromServer];
                [self downloadImage:[tempDict objectForKey:@"imageHref"] imageDownloadFromServer:imgViewFromServer indexPathOfImage:indexPath];
                
                [imgViewFromServer.layer setBorderColor: [[UIColor blackColor] CGColor]];
                [imgViewFromServer.layer setBorderWidth: 1.0];
                
            }
            
            
            
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        if(objImageDetails.arrImagesDeatils.count > 0)
        {
            
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - image download

-(void)downloadImage:(NSString *)strImageLink imageDownloadFromServer:(UIImageView *)imgViewFromServer indexPathOfImage:(NSIndexPath *)indexPath
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^(void) {
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImageLink]];
        
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                uint8_t c;
                [imageData getBytes:&c length:1];
                
                // is check data in image format or not ?
                
                if(c == 0xFF || c == 0x89  || c == 0x47  || c == 0x49 || c == 0x4D )
                {
                    
                    // calculate size of image
                    
                    [self sizeCalOfImage:[UIImage imageWithData:imageData] indexPathOfImage:indexPath];
                    imgViewFromServer.image = [UIImage imageWithData:imageData];
                    
                    // stroe image internal space if you want
                    
                    [WriteImage writeImageToInternalStorage:[UIImage imageWithData:imageData] imageName:[NSString stringWithFormat:@"%d,%d",indexPath.section,indexPath.row]];
                    //[self.tableViewImages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                }
            });
        }
    });
    
    
    /*
     NSURL *URL1 = [NSURL URLWithString:strImageLink];
     
     NSLog(@"URL1 ; %@",URL1);
     
     NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL1];
     [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *imageData, NSError *error)
     {
         uint8_t c;
         [imageData getBytes:&c length:1];
         
         if(c == 0xFF || c == 0x89  || c == 0x47  || c == 0x49 || c == 0x4D )
         {
             [self sizeCalOfImage:[UIImage imageWithData:imageData] indexPathOfImage:indexPath];
             imgViewFromServer.image = [UIImage imageWithData:imageData];
             
             // stroe image internal space if you want
             
             [WriteImage writeImageToInternalStorage:[UIImage imageWithData:imageData] imageName:[NSString stringWithFormat:@"%d,%d",indexPath.section,indexPath.row]];
             //[self.tableViewImages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
         }
     }];
    */
}


-(void)sizeCalOfImage:(UIImage *)imgDownload indexPathOfImage:(NSIndexPath *)indexPath
{
    
    if(!imgDownload)
    {
        return;
    }
    
    NSLog(@"imgCapture %f %f",imgDownload.size.width,imgDownload.size.height);
    CGSize imgSizeCal = CGSizeMake(self.tableViewImages.frame.size.width,(imgDownload.size.height*self.tableViewImages.frame.size.width)/imgDownload.size.width);
    NSLog(@"imgSizeCal %f %f",imgSizeCal.width,imgSizeCal.height);
    
    NSMutableDictionary *dictTemp = [objImageDetails.arrImagesDeatils objectAtIndex:indexPath.row];
    [dictTemp setObject:[NSString stringWithFormat:@"%f,%f",imgSizeCal.width,imgSizeCal.height] forKey:@"imgSize"];
    [objImageDetails.arrImagesDeatils replaceObjectAtIndex:indexPath.row withObject:dictTemp];
    
    /*
     if(imgDownload.size.width > imgDownload.size.height)
     {
     
     NSLog(@"imgCapture %f %f",imgDownload.size.width,imgDownload.size.height);
     CGSize imgSizeCal = CGSizeMake(self.tableViewImages.frame.size.width,(imgDownload.size.height*self.tableViewImages.frame.size.width)/imgDownload.size.width);
     NSLog(@"imgSizeCal %f %f",imgSizeCal.width,imgSizeCal.height);
     return ;
     
     }
     
     NSLog(@"imgCapture %f %f",imgDownload.size.width,imgDownload.size.height);
     CGSize imgSizeCal = CGSizeMake((imgDownload.size.width*self.tableViewImages.frame.size.height)/imgDownload.size.height,self.tableViewImages.frame.size.height);
     NSLog(@"imgSizeCal %f %f",imgSizeCal.width,imgSizeCal.height);
     */
    
}

#pragma mark - Alertview message

-(void)alertViewInternetConnection
{
    UIAlertView *alertMsg = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There is no internet connection. Please check interent connection. Thanks." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertMsg show];
}

-(void)alertViewInternetConnection:(NSString *)strTitle message:(NSString *)strMsg cancelBtnTitle:(NSString *)strBtnCancelTitle
{
    UIAlertView *alertMsg = [[UIAlertView alloc]initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:strBtnCancelTitle otherButtonTitles:nil, nil];
    [alertMsg show];
}





@end
