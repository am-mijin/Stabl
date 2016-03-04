//
//  PodcastDetailsViewController.h
//  Stabl
//
//  Created by Mijin Cho on 06/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Podcast;
@interface PodcastDetailsViewController : UIViewController <NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) Podcast *podcast;
@end
