//
//  ParseAPI.h
//  Stabl
//
//  Created by mijin on 26/01/2016.
//  Copyright © 2016 mijin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cache.h"
@interface ParseAPI : NSObject <NSURLSessionDelegate>

+ (void)random:(id)genres  duration_min:(int)duration_min duration_max:(int)duration_max pubDate:(NSString*)pubDate max :(int) max block:(void (^)(NSArray* array, NSError *error))completionBlock;
+(void)test;

@end
