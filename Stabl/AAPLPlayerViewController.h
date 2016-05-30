/*
	Copyright (C) 2015 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	View controller containing a player view and basic playback controls.
*/

@import UIKit;

@import Foundation;
@import AVFoundation;

@import MediaPlayer;
@import CoreMedia.CMTime;
@class AAPLPlayerView;
@class Podcast;
@interface AAPLPlayerViewController : UIViewController

@property (readonly) AVPlayer *player;
@property AVURLAsset *asset;

@property CMTime currentTime;
@property (readonly) CMTime duration;
@property float rate;

@property (nonatomic, strong) Podcast *podcast;
@property (nonatomic, strong) NSDictionary *episode;
@property (weak) IBOutlet UILabel *titleLabel;

@property (weak) IBOutlet UILabel *currentTimeLabel;
@property (weak) IBOutlet UIImageView *imageView;

@property (weak) IBOutlet UIImageView *frontImageView;
@property (weak) IBOutlet UIView *minimizedView;

@property (weak) IBOutlet UISlider *timeSlider;
@property (weak) IBOutlet UILabel *bigTitleLabel;
@property (weak) IBOutlet UILabel *episodeLabel;

@property (weak) IBOutlet UILabel *startTimeLabel;
@property (weak) IBOutlet UILabel *durationLabel;
@property (weak) IBOutlet UILabel *totaldurationLabel;
@property (weak) IBOutlet UILabel *remainTimeLabel;

@property (weak) IBOutlet UILabel *subtitleLabel;
@property (weak) IBOutlet UIButton *rewindButton;
@property (weak) IBOutlet UIButton *playPauseButton;
@property (weak) IBOutlet UIButton *smallPlayPauseButton;
@property (weak) IBOutlet UIButton *fastForwardButton;

@property (weak) IBOutlet UIImageView *backgorund;
@property (weak) IBOutlet AAPLPlayerView *playerView;

@property (strong,nonatomic) UIImage *artwork;

- (void)initPlayer;

- (void)clearObservers;
@end

