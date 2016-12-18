//
//  ParseAPI.h
//  ilovestage
//
//  Created by Mijin Cho on 16/05/2015.
//  Copyright (c) 2015 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cache.h"
@interface ParseAPI : NSObject <NSURLSessionDelegate>

+ (void)random:(id)genres  duration_min:(int)duration_min duration_max:(int)duration_max pubDate:(NSString*)pubDate max :(int) max block:(void (^)(NSArray* array, NSError *error))completionBlock;
+(void)test;

@end
