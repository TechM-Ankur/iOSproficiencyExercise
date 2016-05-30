//
//  APICall.m
//  TechM-Ankur
//
//  Created by Ankur Patel on 5/28/16.
//  Copyright © 2016 Pro Start Me. All rights reserved.
//

#import "APICall.h"
#import "NSObject+SBJson.h"

@implementation APICall

#pragma mark - get image deatils from server callinga api

+(NSDictionary *)getImageDetails
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
    
    /*
    NSOperationQueue *queueAPICall = [[NSOperationQueue alloc]init];
    NSInvocationOperation *invOperationAPICall = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(getImageDataAPI) object:nil];
    
    [queueAPICall addOperation:invOperationAPICall];
    [queueAPICall waitUntilAllOperationsAreFinished];
    */

    return nil;
}

+(NSDictionary *)getImageDataAPI
{
    [APICall setSharedCacheForImages];
    
    NSURLSession *session = [self prepareSessionForRequest];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://dl.dropboxusercontent.com/u/746330" stringByAppendingPathComponent:@"facts.json"]]];
    [request setHTTPMethod:@"GET"];
    
    __block NSDictionary *dictResponse = nil;
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            
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
            
            dictResponse = [strTemp JSONValue];
            NSLog(@"dictResponse : %@",dictResponse);
            
        }
    }];
    [dataTask resume];
    
    return dictResponse;
}

+ (void)setSharedCacheForImages
{
    NSUInteger cashSize = 250 * 1024 * 1024;
    NSUInteger cashDiskSize = 250 * 1024 * 1024;
    NSURLCache *imageCache = [[NSURLCache alloc] initWithMemoryCapacity:cashSize diskCapacity:cashDiskSize diskPath:@"someCachePath"];
    [NSURLCache setSharedURLCache:imageCache];
}

+ (NSURLSession *)prepareSessionForRequest
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setHTTPAdditionalHeaders:@{@"Content-Encoding": @"gzip", @"Content-Type": @"text/plain; charset=ISO-8859-1"}];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue: [NSOperationQueue mainQueue]];//[NSURLSession sessionWithConfiguration:sessionConfiguration];
    return session;
}



@end
