//
//  WriteImage.h
//  TechM-Ankur
//
//  Created by Ankur Patel on 24/05/16.
//  Copyright © 2016 Ankur Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WriteImage : NSObject


#pragma mark - write Image To Internal Storage

+(void)writeImageToInternalStorage:(UIImage *)img imageName:(NSString *)strImgName;

#pragma mark - get Images path

+(NSString *)getImagesPath;

#pragma mark - sort Directory Content DateWise

+(NSArray *)sortDirectoryContentDateWise:(NSString *)strDirectoryPath;
@end
