//
//  BaseViewController.h
//  Stabl
//
//  Created by mijin on 26/01/2016.
//  Copyright © 2016 mijin. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Consts.h"


@interface BaseViewController : UIViewController

- (BOOL)validateEmail: (NSString *) candidate;
- (void)showLoading:(NSString*)msg;
- (void)dismiss;

@end
