//
//  Utility.m
//  ilovestage
//
//  Created by Mijin Cho on 16/05/2015.
//  Copyright (c) 2015 Rightster. All rights reserved.
//

#import "ParseAPI.h"



NSString *const kActivityClassKey = @"Feeds";
// Field keys
NSString *const kActivityTypeKey        = @"type";
NSString *const kActivityFromUserKey    = @"fromUser";

NSString *const kActivitytoUserKey    = @"toUser";
NSString *const kActivityToUserKey      = @"toUser";
NSString *const kActivityContentKey     = @"content";

// Type values
NSString *const kActivityTypeLike       = @"like";
NSString *const kActivityTypeRecommend     = @"recommend";
NSString *const kActivityTypeOrder       = @"order";
NSString *const kActivityTypeContribute      = @"contribute ";
NSString *const kVideoKey = @"video";
NSString *const kPerkKey = @"perk";
@implementation ParseAPI
// PAPUtility.m

/*

+ (void)orderPerkInBackground:(id)video order:(NSMutableDictionary*)orderinfo block:(void (^)(NSString* bookingid, NSError *error))completionBlock {
    // Create the like activity and save it
    
    NSDictionary* perk = [orderinfo objectForKey:@"perk"];
    //int index = [[orderinfo objectForKey:@"index"] integerValue];
    
     PFQuery *queryPerk = [PFQuery queryWithClassName:kPerksClassKey];
     
     [queryPerk getObjectInBackgroundWithId:[perk objectForKey:@"objectId"]
     block:^(PFObject *p, NSError *error) {
         if(error)
         {
             
         }
         else
         {
             NSLog(@"perkID %@",p.objectId);
             
             NSMutableArray* sponsors = [NSMutableArray new];
             [sponsors addObject:[PFUser currentUser]];
             
             if(p[@"sponsors"])
             {
                 
                 sponsors = [p[@"sponsors"] mutableCopy];
             }
             
             p[@"sponsors"] = sponsors;
             [p saveInBackground];
             
             PFObject *orderActivity = [PFObject objectWithClassName:kActivityClassKey];
             if([[perk objectForKey:@"type"] isEqualToString:@"default"])
             {
                 
                 [orderActivity setObject:kActivityTypeContribute forKey:kActivityTypeKey];
             }
             else
             {
                 
                 [orderActivity setObject:kActivityTypeOrder forKey:kActivityTypeKey];
                 
             }
             [orderActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
             [orderActivity setObject:[video objectForKey:@"user"] forKey:kActivitytoUserKey];
             [orderActivity setObject:video forKey:kVideoKey];
             [orderActivity setObject:[video objectForKey:@"videoid"] forKey:@"videoid"];
             [orderActivity setObject:[perk objectForKey:@"objectId"] forKey:@"perkid"];
             [orderActivity setObject:p forKey:@"perk"];
             
             
             
             
             if([orderinfo objectForKey:@"orderinfo"] )
                 [orderActivity setObject:[orderinfo objectForKey:@"orderinfo"] forKey:@"orderinfo"];
             
             
             
             NSMutableDictionary *newperk = [perk mutableCopy];
             
             int claimed = [[perk objectForKey:@"total"] integerValue] + 1;
             [newperk setObject:[NSNumber numberWithInt:claimed] forKey:@"total"];
             NSLog(@"newperk %@", newperk);
             
             // Don't forget the ACLs! As with other objects in Anypic, we make it public readonly
             PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
             [likeACL setPublicReadAccess:YES];
             orderActivity.ACL = likeACL;
             
             int totalfund = [[video objectForKey:@"totalfund"] integerValue];
             [orderActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 
                 if (completionBlock) {
                     completionBlock(orderActivity.objectId,error);
                 }
                 
                 PFQuery *query = [PFQuery queryWithClassName:@"Musixstars"];
                 
                 // Retrieve the object by id
                 PFObject *v =  (PFObject*)video;
                 
                 [query getObjectInBackgroundWithId:v.objectId
                                              block:^(PFObject *video, NSError *error) {
                                                  
                                                  if(error)
                                                  {
                                                      
                                                  }
                                                  else
                                                  {
                                                      video[@"totalfund"] =
                                                      [NSNumber numberWithInt:totalfund + [[perk objectForKey:@"price"] integerValue]];
                                                      NSMutableArray* perks = [video[@"perks"] mutableCopy];
                                                      
                                                      int index = 0;
                                                      
                                                      for (int i = 0; i<[perks count];i++) {
                                                          NSDictionary* item = [perks objectAtIndex:i];
                                                         if( [[item objectForKey:@""] isEqualToString:p.objectId])
                                                         {
                                                             index = i;
                                                             break;
                                                         }
                                                      }
                                                      
                                                      [perks replaceObjectAtIndex: index withObject:newperk];
                                                      
                                                      video[@"perks"] = perks;
                                                      
                                                      
                                                      [[Cache sharedInstance] addPerk:newperk of:video];
                                                      [video saveInBackground];
                                                      
                                                  }
                                              }];
                 
             }];
         }

     }];
   
    

}

+ (void)likeVideoInBackground:(id)video block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    // Create the like activity and save it
    PFObject *likeActivity = [PFObject objectWithClassName:kActivityClassKey];
    [likeActivity setObject:kActivityTypeLike forKey:kActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [likeActivity setObject:[video objectForKey:@"user"] forKey:kActivitytoUserKey];
    [likeActivity setObject:video forKey:kVideoKey];
    [likeActivity setObject:[video objectForKey:@"videoid"] forKey:@"videoid"];
    
    
    // Don't forget the ACLs! As with other objects in Anypic, we make it public readonly
    PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [likeACL setPublicReadAccess:YES];
    likeActivity.ACL = likeACL;
    
    int likecount = [[video objectForKey:@"likes"] integerValue];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (completionBlock) {
            completionBlock(succeeded,error);
        }
        PFQuery *query = [PFQuery queryWithClassName:@"Musixstars"];
        
        // Retrieve the object by id
        PFObject *v =  (PFObject*)video;
        
        [query getObjectInBackgroundWithId:v.objectId
                                     block:^(PFObject *video, NSError *error) {
                                       
                                         video[@"likes"] =
                                         [NSNumber numberWithInt:likecount];
                                         
                                         [[Cache sharedInstance] setAttributesForVideo:video likeCount:likecount];
                                         [video saveInBackground];
                                     }];
        
    }];
}

+ (void)unlikePhotoInBackground:(id)video block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kActivityClassKey];
    [queryExistingLikes whereKey:kVideoKey equalTo:video];
    [queryExistingLikes whereKey:kActivityTypeKey equalTo:kActivityTypeLike];
    [queryExistingLikes whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    
    int likecount = [[video objectForKey:@"likes"] integerValue];
    
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
            
            if (completionBlock) {
                completionBlock(YES,nil);
            }
            PFQuery *query = [PFQuery queryWithClassName:@"Musixstars"];
            
            // Retrieve the object by id
            PFObject *v =  (PFObject*)video;
            
            [query getObjectInBackgroundWithId:v.objectId
                                         block:^(PFObject *video, NSError *error) {
                                             
                                             video[@"likes"] =
                                             [NSNumber numberWithInt:likecount];
                                             
                                             [[Cache sharedInstance] removeVideo:video];
                                             [video saveInBackground];
                                         }];
            
       
            
        } else {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];  
}


+ (void)addDefaultPerks:(NSMutableDictionary*)perks block:(void (^)(NSMutableArray* newperks, NSError *error))completionBlock
{
    NSMutableArray* defaultperks = [NSMutableArray new];
 
    
    for (int i= 0; i<=2; i++) {
        PFObject *perks = [PFObject objectWithClassName:kPerksClassKey];
        
        NSString* title = @"£1 Contribution";
        NSString* description = @"£1 Contribution";
        NSString* price = @"1.0";
        
        if(i == 1)
        {
            title = @"£5 Contribution";
            description = @"£5 Contribution";
            price = @"5.0";
        }
        else if(i == 2)
        {
            title = @"£10 Contribution";
            description = @"£10 Contribution";
            price = @"10.0";
            
        }
        
        NSMutableDictionary *perk = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"default", @"type",
                                     title, @"title",
                                     description,@"description",
                                     [NSNumber numberWithFloat:[price floatValue]], @"price",
                                     @"",@"expirydate",
                                     [NSNumber numberWithInt:0],@"total",
                                     [NSNumber numberWithBool:NO],@"delivery",
                                      nil];
        
       [defaultperks addObject:perk ];
        
        perks[@"type"] = @"default";
        perks[@"title"] = [perk objectForKey:@"title"];
        perks[@"description"] = [perk objectForKey:@"description"];
        perks[@"price"] = [perk objectForKey:@"price"];
        perks[@"user"] = [PFUser currentUser];
        perks[@"delivery"] = [NSNumber numberWithBool:NO];
        
        [perks saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
                
                
                NSLog(@"objectId %@", perks.objectId);
                [perk setObject:perks.objectId forKey:@"objectId"];
                [[UserAccount sharedInstance].perks addObject:perk];
                
                if(i == 2)
                {
                    if (completionBlock) {
                        completionBlock(defaultperks,nil);
                    }
                }
                
            } else {
                // There was a problem, check error.description
                if (completionBlock) {
                    completionBlock(nil, error);
                }
            }
        }];
    }
}

+ (void)addNewVideoInBackground:(NSMutableDictionary*)video block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    // Create the like activity and save it
    NSLog(@"video %@",video);
    
    PFObject *musixstars = [PFObject objectWithClassName:@"Musixstars"];
    musixstars[@"title"] = [video objectForKey:@"title"];
    musixstars[@"description"] = [video objectForKey:@"description"];
    musixstars[@"videoid"] = [video objectForKey:@"videoid"];
    musixstars[@"user"] = [PFUser currentUser];
    
    musixstars[@"expiryDate"] = [video objectForKey:@"expiryDate"];
    musixstars[@"artist"] = [[video objectForKey:@"artist"] uppercaseString];
    musixstars[@"perks"] = [video objectForKey:@"perks"];
    musixstars[@"thumbnail"] = [video objectForKey:@"thumbnail"];
    
    [musixstars saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            
            [[UserAccount sharedInstance].contents insertObject:musixstars atIndex:0];
            
            if (completionBlock) {
                completionBlock(YES,nil);
            }
        } else {
            // There was a problem, check error.description
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];
}

+ (void)addNewPerkInBackground:(NSMutableDictionary*)perk block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    // Create the like activity and save it
    NSLog(@"perk %@",perk);
    PFObject *perks = [PFObject objectWithClassName:kPerksClassKey];
    perks[@"title"] = [perk objectForKey:@"title"];
    perks[@"description"] = [perk objectForKey:@"description"];
    perks[@"price"] = [perk objectForKey:@"price"];
    perks[@"user"] = [PFUser currentUser];
    perks[@"expirydate"] = [perk objectForKey:@"expirydate"];
    perks[@"delivery"] = [perk objectForKey:@"delivery"];
    
    [perks saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            
            NSLog(@"objectId %@", perks.objectId);
            [perk setObject:perks.objectId forKey:@"objectId"];
            [[UserAccount sharedInstance].perks addObject:perk];
            
            if (completionBlock) {
                completionBlock(YES,nil);
            }
        } else {
            // There was a problem, check error.description
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];
}

+ (void)editPerkInBackground:(id)obj block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    // Create the like activity and save it
    NSMutableDictionary* p =  (NSMutableDictionary* )obj;
    PFQuery *query = [PFQuery queryWithClassName:@"kPerksClassKey"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[p objectForKey:@"objectId"]
                                 block:^(PFObject *perk, NSError *error) {
                                     perk[@"title"] = [p objectForKey:@"title"];
                                     perk[@"description"] = [p objectForKey:@"description"];
                                     perk[@"price"] = [p objectForKey:@"price"];
                                     perk[@"expirydate"] = [p objectForKey:@"expirydate"];
                                     
                                     [perk saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (succeeded) {
                                             // The object has been saved.
                                             
                                             if (completionBlock) {
                                                 completionBlock(YES,nil);
                                             }
                                         } else {
                                             // There was a problem, check error.description
                                             if (completionBlock) {
                                                 completionBlock(NO,error);
                                             }
                                         }
                                     }];
                                     
                                     //[perk saveInBackground];
                                 }];
}

+ (void)addBankAccount:(id)info block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    // Create the like activity and save it
    NSLog(@"info? %@",info);
    PFUser *currentUser = [PFUser currentUser];
    
    currentUser[@"bankName"] = [info objectForKey:@"bankName"];
    currentUser[@"accountName"] =[info objectForKey:@"accountName"];
    currentUser[@"sortCode"] = [info objectForKey:@"sortCode"];
    currentUser[@"accountNumer"] = [info objectForKey:@"accountNumer"];
    
    
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The currentUser saved successfully.
            if (completionBlock)
                completionBlock(YES,nil);
        } else {
            // There was an error saving the currentUser.
            
            if (completionBlock)
                completionBlock(NO,error);
        }
    }];
}*/




@end
