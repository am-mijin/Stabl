//
//  Global.h
//  Stabl
//
//  Created by Mijin Cho on 19/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Consts.h"
@interface Global : NSObject

@property (nonatomic, strong) NSMutableArray *feeds;

@property (nonatomic, strong) NSMutableArray *genres;
@property (nonatomic, readwrite) BOOL isFirstTime;
@property (nonatomic, readwrite) CurrentMenu curMenu;
@property (nonatomic, readwrite) BOOL *playing;
+(id)Global;
+(Global*)sharedInstance;

@end
