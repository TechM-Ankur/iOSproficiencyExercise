//
//  CommonFunc.m
//  TechM-Ankur
//
//  Created by Ankur Patel on 5/29/16.
//  Copyright © 2016 Pro Start Me. All rights reserved.
//

#import "CommonFunc.h"

@implementation CommonFunc

#pragma mark - color text change for title

+(NSMutableAttributedString *)colorWordString:(NSString *)strText firstText:(NSString *)strFirstTxt secondText:(NSString *)strSecondTxt
{

    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:strText];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor  colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0] range:[strText rangeOfString:strText]];
    
    
    NSRange start1 = [strText rangeOfString:strSecondTxt];
    if (start1.location != NSNotFound)
    {
        NSRange range=[strText rangeOfString:strSecondTxt];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0] range:range];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14] range:range];
    }
    
    NSRange start = [strText rangeOfString:strFirstTxt];
    if (start.location != NSNotFound)
    {
        NSRange range=[strText rangeOfString:strFirstTxt];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor  colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0] range:range];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:14] range:range];
    }
    
    return string;
}

@end
