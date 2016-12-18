//
//  ShowEpisodesViewController.h
//  Stabl
//
//  Created by Mijin Cho on 12/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@class Podcast;
@interface ShowEpisodesViewController : BaseViewController <NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) Podcast *podcast;

@end
