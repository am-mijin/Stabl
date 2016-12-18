//
//  Global.m
//  Stabl
//
//  Created by Mijin Cho on 19/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

#import "Global.h"

@implementation Global
static Global *instance = nil;
+(Global*)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

-(id)init
{
    if(self = [super init])
    {
        _feeds = [NSMutableArray new];
        _genres = [NSMutableArray new];
        _isFirstTime = YES;
    }
    return self;
}

+(id)Global {
    return [[self alloc]init];
}

@end
