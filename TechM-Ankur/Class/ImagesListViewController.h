//
//  ImagesListViewController.h
//  TechM-Ankur
//
//  Created by Ankur Patel on 24/05/16.
//  Copyright © 2016 Ankur Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDelegate>
{
    
    
    
}

@property (nonatomic) UIActivityIndicatorView *viewIndicator;



@property (nonatomic, retain) UIView *viewNavBar;
@property (nonatomic, retain) UILabel *lblNavTitle;
@property (nonatomic, retain) UITableView *tableViewImages;


@end
