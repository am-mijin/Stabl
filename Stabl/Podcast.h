/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Managed object subclass for Song entity.
 */

#import <UIKit/UIKit.h>


@interface Podcast : NSObject

@property (nonatomic, strong) NSString* artistId;
@property (nonatomic, strong) NSString* collectionId;

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *collectionName;

@property (nonatomic, strong) NSString *trackName;

@property (nonatomic, strong) NSString *artistViewUrl;

@property (nonatomic, strong) NSString *collectionViewUrl;
@property (nonatomic, strong) NSString *feedUrl;

@property (nonatomic, strong) NSString *artworkUrl100;
@property (nonatomic, strong) NSDate *releaseDate;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *primaryGenreName;


@end
