//
//  Global.h
//  Stabl
//
//  Created by Mijin Cho on 19/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

@property (nonatomic, strong) NSMutableArray *feeds;

+(id)Global;
+(Global*)sharedInstance;

@end
