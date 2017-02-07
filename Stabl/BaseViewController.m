//
//  BaseViewController.m
//  Stabl
//
//  Created by mijin on 26/01/2016.
//  Copyright © 2016 mijin. All rights reserved.
//

#import "BaseViewController.h"

//#import "SVProgressHUD.h"


@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor =  [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:    [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        Top_Black, NSForegroundColorAttributeName,
                                                                         [UIFont fontWithName:@"Dosis- SemiBold" size:23.0], NSFontAttributeName, nil]];
    
    
}


-(void)backButtonTapped {
   
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        
}
/*
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(void)dismiss
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

- (void) showLoading:(NSString*)msg
{
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0/255.0 green:101/255.0 blue:144/255.0 alpha:1.0]];
    //[SVProgressHUD setForegroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]];
    [SVProgressHUD setRingThickness:5];
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 0)];
    [SVProgressHUD show];
}

- (void) updateDeviceStatus:(NSNotification *)notification
{
    
}



-(void)alert:(NSString*)alertTitle:(NSString*)msg
{
    
    [[[UIAlertView alloc] initWithTitle:alertTitle
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}
*/

@end
