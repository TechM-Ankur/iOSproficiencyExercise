//
//  AppDelegate.m
//  TechM-Ankur
//
//  Created by Ankur Patel on 24/05/16.
//  Copyright © 2016 Ankur Patel. All rights reserved.
//

#import "WriteImage.h"

@implementation WriteImage

#pragma mark - write Image To Internal Storage

+(void)writeImageToInternalStorage:(UIImage *)img imageName:(NSString *)strImgName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *imagesPath = [documentsDir stringByAppendingPathComponent:@"/ImagesFolder"];
    
    NSError *error1;
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagesPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesPath withIntermediateDirectories:NO attributes:nil error:&error1];
        
    }
    
    NSData *jpgData = UIImageJPEGRepresentation(img,1.0);
    NSString *filePath = [imagesPath stringByAppendingPathComponent:strImgName];
    NSError *errWrite;
    [jpgData writeToFile:filePath options:NSDataWritingAtomic error:&errWrite];
    
    NSLog(@"storeUserProfileAndCoverPic filePath : %@",filePath);
}

#pragma mark - get Images path


+(NSString *)getImagesPath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *imagesPathFolder = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/ImagesFolder"]];
    
    NSError *error1;
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagesPathFolder])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesPathFolder withIntermediateDirectories:NO attributes:nil error:&error1];
        
    }
    
    return imagesPathFolder;
}

#pragma mark - sort Directory Content DateWise

+(NSArray *)sortDirectoryContentDateWise:(NSString *)strDirectoryPath
{
    NSError *error;
    NSArray* filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strDirectoryPath error:&error];
    if(error != nil) {
        NSLog(@"Error in reading files: %@", [error localizedDescription]);
        return nil;
    }
    
    // sort by creation date
    NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[filesArray count]];
    for(NSString* file in filesArray) {
        NSString* filePath = strDirectoryPath;//[iMgr.documentsPath stringByAppendingPathComponent:file];
        NSDictionary* properties = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:filePath
                                    error:&error];
        NSDate* modDate = [properties objectForKey:NSFileModificationDate];
        
        if(error == nil)
        {
            [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                           file, @"fileName",
                                           modDate, @"lastModDate",
                                           nil]];
        }
    }
    
    // sort using a block
    // order inverted as we want latest date first
    NSArray* sortedFiles = [filesAndProperties sortedArrayUsingComparator:
                            ^(id path1, id path2)
                            {
                                // compare
                                NSComparisonResult comp = [[path1 objectForKey:@"lastModDate"] compare:
                                                           [path2 objectForKey:@"lastModDate"]];
                                // invert ordering
                                if (comp == NSOrderedDescending) {
                                    comp = NSOrderedAscending;
                                }
                                else if(comp == NSOrderedAscending){
                                    comp = NSOrderedDescending;
                                }
                                return comp;
                            }];
    
    return sortedFiles;
}

@end
