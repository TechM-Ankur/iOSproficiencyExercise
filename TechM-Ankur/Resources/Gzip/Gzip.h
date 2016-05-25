//
//  Gzip.h
//  TechM-Ankur
//
//  Created by Anks Patel on 24/05/16.
//  Copyright © 2016 Pro Start Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gzip : NSObject

+(NSData *)unGzipData:(NSData*)dataGzip;
+(NSData *)gzipData:(NSData*)dataGzip;

@end
