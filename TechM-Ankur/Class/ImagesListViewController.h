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
    UIView *viewNavBar;
    UILabel *lblNavTitle;
    UITableView *tableViewImages;
    NSMutableArray *arrImagesDeatils;
    UIView *viewForAlertView;
}

@property (nonatomic) UIActivityIndicatorView *viewIndicator;

@end
