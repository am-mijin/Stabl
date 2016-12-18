/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    View controller containing a player view and basic playback controls.
*/

#import "AAPLPlayerViewController.h"
#import "AAPLPlayerView.h"
#import "Stabl-Swift.h"

#import "Consts.h"
#import <HockeySDK/HockeySDK.h>

#define panGestureRecognizer_Y 250

// Private properties
@interface AAPLPlayerViewController ()
{
    
    AVPlayer *_player;
    AVURLAsset *_asset;
    id<NSObject> _timeObserverToken;
    AVPlayerItem *_playerItem;
    
    CGPoint originalPoint;
    CGFloat px;
    CGFloat py;
    CGFloat timebarX;
}

@property AVPlayerItem *playerItem;

@property (readonly) AVPlayerLayer *playerLayer;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong)ShowEpisodesViewController *showEpisodesViewController;
@end

@implementation AAPLPlayerViewController

// MARK: - View Handling

/*
	KVO context used to differentiate KVO callbacks for this class versus other
	classes in its class hierarchy.
*/
static int AAPLPlayerViewControllerKVOContext = 0;
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
    
}

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [_player play];
    
    _timeSlider.minimumTrackTintColor = Secondary;
    _timeSlider.maximumTrackTintColor = [UIColor whiteColor ];
    [_timeSlider setMinimumTrackImage: [UIImage imageNamed:@"slider_left"] forState: UIControlStateNormal];
    [_timeSlider setMaximumTrackImage: [UIImage imageNamed:@"slider_right"] forState: UIControlStateNormal];
    
    dispatch_queue_t globalConcurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //dispatch_async(globalConcurrentQueue, ^{
     //});
    if ( self.showEpisodesViewController == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.showEpisodesViewController = [storyboard instantiateViewControllerWithIdentifier:@"ShowEpisodesViewController"];
        
        self.showEpisodesViewController.podcast = _podcast;
        
        
        [self.view addSubview:self.showEpisodesViewController.view];
        
        self.showEpisodesViewController.view.frame = CGRectMake( self.view.frame.size.width,
                                                               0 ,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height);

    }
    
    
    
    
}

- (void)initPlayer {
    
    [self addObserver:self forKeyPath:@"asset" options:NSKeyValueObservingOptionNew context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.currentItem.duration" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.rate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    
    self.playerView.playerLayer.player = self.player;
    
    NSURL *url = [NSURL URLWithString:@"http://broadappeal.podomatic.com/enclosure/2016-01-20T16_02_21-08_00.mp3"];
    
   
    _titleLabel.text =  _podcast.collectionName;
    _bigTitleLabel.text =  _podcast.collectionName;
    
    if(_episode){
        url = [NSURL URLWithString :[_episode objectForKey: @"link"]];
        //NSLog(@"_episode url %@",url);
        
        _subtitleLabel.text = [_episode objectForKey: @"title"];
        _episodeLabel.text =  [_episode objectForKey: @"title"];
        
    }else{
        
        url = [NSURL URLWithString :[_podcast.enclosure objectForKey:@"url"]];
        //NSLog(@"url %@",url);
        
        _subtitleLabel.text = _podcast.title;
        _episodeLabel.text = _podcast.title;
        
    }
    
    BITMetricsManager *metricsManager = [BITHockeyManager sharedHockeyManager].metricsManager;
    [metricsManager trackEventWithName:[NSString stringWithFormat: @"%@ - %@",self.podcast.collectionName,_episodeLabel.text]];
    
  
    
    NSString* imageUrl= _podcast.artworkUrl100;
    //NSLog(@"_podcast.artworkUrl100 %@",_podcast.artworkUrl100);

    
    
    [[ImageLoader sharedLoader] imageForUrl:imageUrl  completionHandler:^(UIImage *image, NSString *url) {
        _imageView.image = image;
        _backgorund.image = image;
        _frontImageView.image = image;
        
    }];
    
    /*
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: _artwork];
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *songInfo = [NSMutableDictionary dictionary];
  
    
    [songInfo setValue:albumArt forKey:MPMediaItemPropertyArtwork];
    [songInfo setValue:_podcast.collectionName forKey:MPMediaItemPropertyTitle];
    [songInfo setValue:[_episode objectForKey: @"title"] forKey:MPMediaItemPropertyArtist];
    
    
    infoCenter.nowPlayingInfo = songInfo;
    */
    
    
    self.asset = [AVURLAsset assetWithURL:url];
    
    // Use a weak self variable to avoid a retain cycle in the block.
    AAPLPlayerViewController __weak *weakSelf = self;
    _timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:
                          ^(CMTime time) {
                              
                              weakSelf.timeSlider.value = CMTimeGetSeconds(time);
                              int remain = CMTimeGetSeconds( self.duration) - CMTimeGetSeconds(time);
                              
                              int sec = CMTimeGetSeconds(time);
                              NSString* minstr;
                              NSString* secstr;
                              if (sec/60 <10)
                              {
                                  minstr= [NSString stringWithFormat:@"0%d",(int)sec/60];
                              }
                              else
                                  minstr= [NSString stringWithFormat:@"%d",(int)sec/60];
                              
                              if (sec%60 <10)
                                  secstr= [NSString stringWithFormat:@"0%d",(int)sec%60];
                              
                              else
                                  secstr= [NSString stringWithFormat:@"%d",(int)sec%60];
                              
                              float total = CMTimeGetSeconds( self.duration);
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [UIView animateWithDuration:0.0 animations:^{
                                      
                                      _currentTimeLabel.text = [NSString stringWithFormat:@"%@ : %@",minstr,secstr];
                                      
                                      _remainTimeLabel.text = [NSString stringWithFormat:@"-%@ : %@",minstr,secstr];
                                      
                                      if(sec * (self.view.frame.size.width/total)  <=
                                         (self.view.frame.size.width -_currentTimeLabel.frame.size.width + 45))
                                      {
                                          _currentTimeLabel.frame = CGRectMake(sec * (self.view.frame.size.width/total) +5,
                                                                               _currentTimeLabel.frame.origin.y,
                                                                               _currentTimeLabel.frame.size.width,
                                                                               _currentTimeLabel.frame.size.height);
                                      }
                                      
                                      
                                  } completion:^(BOOL finished) {
                                      
                                      MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
                                      NSMutableDictionary *songInfo = [NSMutableDictionary dictionary];
                                      
                                      [songInfo setValue:_podcast.collectionName forKey:MPMediaItemPropertyTitle];
                                      
                                      [songInfo setValue:_episodeLabel.text forKey:MPMediaItemPropertyArtist];
                                                                     
                                      float total = CMTimeGetSeconds( self.duration);
                                      [songInfo setValue:[NSNumber numberWithFloat:total] forKey:MPMediaItemPropertyPlaybackDuration];
                                      
                                      float currentTime = CMTimeGetSeconds( self.currentTime);
                                      
                                       [songInfo setValue:[NSNumber numberWithFloat:currentTime]forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
                                      
                                      infoCenter.nowPlayingInfo = songInfo;
                                      
                                  
                                      
                                  }];
                              });
                          }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //self.navigationController.navigationBar.translucent = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidChange:) name:kPodecastNotification object:nil];
    
    [self initPlayer];
    
    
    
   // self.minimizedView.hidden = YES;
    /*
        Update the UI when these player properties change.
    
        Use the context parameter to distinguish KVO for our particular observers and not
        those destined for a subclass that also happens to be observing these properties.
    */
    
    
    //UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector (moveViewWithGestureRecognizer:)];
    //[self.view addGestureRecognizer:panGestureRecognizer];
}

-(void)playerItemDidChange:(NSNotification*)notification
{
  
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         
                         self.showEpisodesViewController.view.frame = CGRectMake(self.view.frame.size.width,
                                                                                 0,
                                                                                 self.view.frame.size.width,
                                                                                 self.view.frame.size.height );
                     }completion:^(BOOL complete){
                         NSDictionary* ep = notification.userInfo;
                         
                         if(ep != nil){
                             self.episode = ep;
                             
                             [self clearObservers];
                             [self initPlayer];
                         }
                     }];
}

- (void)clearObservers {
 
    if (_timeObserverToken) {
        [self.player removeTimeObserver:_timeObserverToken];
        _timeObserverToken = nil;
    }
    
    [self.player pause];
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    @try{
        [self removeObserver:self forKeyPath:@"asset" context:&AAPLPlayerViewControllerKVOContext];
        [self removeObserver:self forKeyPath:@"player.currentItem.duration" context:&AAPLPlayerViewControllerKVOContext];
        [self removeObserver:self forKeyPath:@"player.rate" context:&AAPLPlayerViewControllerKVOContext];
        [self removeObserver:self forKeyPath:@"player.currentItem.status" context:&AAPLPlayerViewControllerKVOContext];
        
        
    }
   
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    
    // Turn off remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    // Resign as first responder
    [self resignFirstResponder];
    
    [super viewDidDisappear:animated];

    if (_timeObserverToken) {
        [self.player removeTimeObserver:_timeObserverToken];
        _timeObserverToken = nil;
    }

    [self.player pause];
    
    [self removeObserver:self forKeyPath:@"asset" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"player.currentItem.duration" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"player.rate" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"player.currentItem.status" context:&AAPLPlayerViewControllerKVOContext];
  
}

// MARK: - Properties

// Will attempt load and test these asset keys before playing
+ (NSArray *)assetKeysRequiredToPlay {
    return @[ @"playable", @"hasProtectedContent" ];
}

- (AVPlayer *)player {
    if (!_player)
        _player = [[AVPlayer alloc] init];
    return _player;
}

- (CMTime)currentTime {
    return self.player.currentTime;
}

- (void)setCurrentTime:(CMTime)newCurrentTime {
    [self.player seekToTime:newCurrentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (CMTime)duration {
    return self.player.currentItem ? self.player.currentItem.duration : kCMTimeZero;
}

- (float)rate {
    return self.player.rate;
}
- (void)setRate:(float)newRate {
    self.player.rate = newRate;
}

- (AVPlayerLayer *)playerLayer {
    return self.playerView.playerLayer;
}

- (AVPlayerItem *)playerItem {
    return _playerItem;
}

- (void)setPlayerItem:(AVPlayerItem *)newPlayerItem {
    if (_playerItem != newPlayerItem) {

        _playerItem = newPlayerItem;
    
        // If needed, configure player item here before associating it with a player
        // (example: adding outputs, setting text style rules, selecting media options)
        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
    }
}

// MARK: - Asset Loading

- (void)asynchronouslyLoadURLAsset:(AVURLAsset *)newAsset {

    /*
        Using AVAsset now runs the risk of blocking the current thread
        (the main UI thread) whilst I/O happens to populate the
        properties. It's prudent to defer our work until the properties
        we need have been loaded.
    */
    [newAsset loadValuesAsynchronouslyForKeys:AAPLPlayerViewController.assetKeysRequiredToPlay completionHandler:^{

        /*
            The asset invokes its completion handler on an arbitrary queue.
            To avoid multiple threads using our internal state at the same time
            we'll elect to use the main thread at all times, let's dispatch
            our handler to the main queue.
        */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (newAsset != self.asset) {
                /*
                    self.asset has already changed! No point continuing because
                    another newAsset will come along in a moment.
                */
                return;
            }
        
            /*
                Test whether the values of each of the keys we need have been
                successfully loaded.
            */
            for (NSString *key in self.class.assetKeysRequiredToPlay) {
                NSError *error = nil;
                if ([newAsset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {

                    NSString *message = [NSString localizedStringWithFormat:NSLocalizedString(@"error.asset_key_%@_failed.description", @"Can't use this AVAsset because one of it's keys failed to load"), key];

                    [self handleErrorWithMessage:message error:error];

                    return;
                }
            }

            // We can't play this asset.
            if (!newAsset.playable || newAsset.hasProtectedContent) {
                NSString *message = NSLocalizedString(@"error.asset_not_playable.description", @"Can't use this AVAsset because it isn't playable or has protected content");

                [self handleErrorWithMessage:message error:nil];

                return;
            }

            /*
                We can play this asset. Create a new AVPlayerItem and make it
                our player's current item.
            */
            self.playerItem = [AVPlayerItem playerItemWithAsset:newAsset];
        });
    }];
    
    [self.player play];
}

- (void)dealloc
{
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:_playerItem];
}

// MARK: - IBActions

- (IBAction)playPauseButtonWasPressed:(UIButton *)sender {
    if (self.player.rate != 1.0) {
        // not playing foward so play
        if (CMTIME_COMPARE_INLINE(self.currentTime, ==, self.duration)) {
            // at end so got back to begining
            self.currentTime = kCMTimeZero;
        }
        [self.player play];
    } else {
        // playing so pause
        [self.player pause];
    }
}

- (IBAction)rewindButtonWasPressed:(UIButton *)sender {
    
    float second =  CMTimeGetSeconds(self.currentTime) -10.0;
    CMTime time = CMTimeMake(second, 1);
    [self  setCurrentTime:time ];
    
    //self.rate = MAX(self.player.rate - 2.0, -2.0); // rewind no faster than -2.0
}

- (IBAction)fastForwardButtonWasPressed:(UIButton *)sender {
    
    float second = 10.0 + CMTimeGetSeconds(self.currentTime);
    CMTime time = CMTimeMake(second, 1);
    [self  setCurrentTime:time ];
 
    //self.rate = MIN(self.player.rate + 2.0, 2.0); // fast forward no faster than 2.0
}
/*
- (IBAction)fastForwardButtonWasPressed:(UISlider *)sender {
}
- (IBAction)rewindButtonWasPressed:(UISlider *)sender {
    
}*/

- (IBAction)timeSliderDidChange:(UISlider *)sender {
    self.currentTime = CMTimeMakeWithSeconds(sender.value, 1000);
}

// MARK: - KV Observation

// Update our UI when player or player.currentItem changes
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (context != &AAPLPlayerViewControllerKVOContext) {
        // KVO isn't for us.
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }

    if ([keyPath isEqualToString:@"asset"]) {
        if (self.asset) {
            [self asynchronouslyLoadURLAsset:self.asset];
        }
    }
    else if ([keyPath isEqualToString:@"player.currentItem.duration"]) {

        // Update timeSlider and enable/disable controls when duration > 0.0

        // Handle NSNull value for NSKeyValueChangeNewKey, i.e. when player.currentItem is nil
        NSValue *newDurationAsValue = change[NSKeyValueChangeNewKey];
        CMTime newDuration = [newDurationAsValue isKindOfClass:[NSValue class]] ? newDurationAsValue.CMTimeValue : kCMTimeZero;
        BOOL hasValidDuration = CMTIME_IS_NUMERIC(newDuration) && newDuration.value != 0;
        double newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0;

        self.timeSlider.maximumValue = newDurationSeconds;
        self.timeSlider.value = hasValidDuration ? CMTimeGetSeconds(self.currentTime) : 0.0;
        self.rewindButton.enabled = hasValidDuration;
        self.playPauseButton.enabled = hasValidDuration;
        
        self.smallPlayPauseButton.enabled = hasValidDuration;
        self.fastForwardButton.enabled = hasValidDuration;
        self.timeSlider.enabled = hasValidDuration;
        self.startTimeLabel.enabled = hasValidDuration;
        self.durationLabel.hidden = NO;
        self.durationLabel.enabled = hasValidDuration;
        int wholeMinutes = (int)trunc(newDurationSeconds / 60);
        self.durationLabel.text = [NSString stringWithFormat:@"%d:%02d", wholeMinutes, (int)trunc(newDurationSeconds) - wholeMinutes * 60];
        
        _totaldurationLabel.text = self.durationLabel.text ;
       
    }
    else if ([keyPath isEqualToString:@"player.rate"]) {
        // Update playPauseButton image

        double newRate = [change[NSKeyValueChangeNewKey] doubleValue];
        UIImage *buttonImage1 = (newRate == 1.0) ? [UIImage imageNamed:@"btn_pause"] : [UIImage imageNamed:@"btn_play"];
        [self.playPauseButton setImage:buttonImage1 forState:UIControlStateNormal];

        
        UIImage *buttonImage2 = (newRate == 1.0) ? [UIImage imageNamed:@"btn_pause"] : [UIImage imageNamed:@"btn_play"];
        [self.smallPlayPauseButton setImage:buttonImage2 forState:UIControlStateNormal];

    }
    else if ([keyPath isEqualToString:@"player.currentItem.status"]) {
        // Display an error if status becomes Failed

        // Handle NSNull value for NSKeyValueChangeNewKey, i.e. when player.currentItem is nil
        NSNumber *newStatusAsNumber = change[NSKeyValueChangeNewKey];
        AVPlayerItemStatus newStatus = [newStatusAsNumber isKindOfClass:[NSNumber class]] ? newStatusAsNumber.integerValue : AVPlayerItemStatusUnknown;
        
        if (newStatus == AVPlayerItemStatusFailed) {
            [self handleErrorWithMessage:self.player.currentItem.error.localizedDescription error:self.player.currentItem.error];
        }

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

// Trigger KVO for anyone observing our properties affected by player and player.currentItem
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"duration"]) {
        return [NSSet setWithArray:@[ @"player.currentItem.duration" ]];
    } else if ([key isEqualToString:@"currentTime"]) {
        return [NSSet setWithArray:@[ @"player.currentItem.currentTime" ]];
    } else if ([key isEqualToString:@"rate"]) {
        return [NSSet setWithArray:@[ @"player.rate" ]];
    } else {
        return [super keyPathsForValuesAffectingValueForKey:key];
    }
}

// MARK: - Error Handling

- (void)handleErrorWithMessage:(NSString *)message error:(NSError *)error {
    NSLog(@"Error occured with message: %@, error: %@.", message, error);

    NSString *alertTitle = NSLocalizedString(@"alert.error.title", @"Alert title for errors");
    NSString *defaultAlertMesssage = NSLocalizedString(@"error.default.description", @"Default error message when no NSError provided");
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:alertTitle message:message ?: defaultAlertMesssage preferredStyle:UIAlertControllerStyleAlert];

    NSString *alertActionTitle = NSLocalizedString(@"alert.error.actions.OK", @"OK on error alert");
    UIAlertAction *action = [UIAlertAction actionWithTitle:alertActionTitle style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];

    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)backButtonPressed:(id )sender {
    
    self.navigationController.navigationBar.hidden = false;
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
   

  
    //[self clearObservers];
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (IBAction)showAllEpisodes:(id )sender {
    
    /*
    self.view.frame = CGRectMake(0,
                                 self.view.frame.size.height -30 ,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
    
    self.minimizedView.hidden = NO;
    
    NSDictionary* data = [NSDictionary dictionaryWithObject:_podcast forKey:@"podcast"];
    [[NSNotificationCenter defaultCenter]postNotificationName:ShowAllEpisodesNotification object:@""
                                                     userInfo: data];
    */
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         
                         self.showEpisodesViewController.view.frame = CGRectMake(0,
                                                      0,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.height );
                     }completion:^(BOOL complete){
                         
                     }];
    
}

- (IBAction)enterFullScreen:(id )sender {
    
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         
                         self.view.frame = CGRectMake(0,
                                                      0,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.height );
                     }completion:^(BOOL complete){
                         
                         self.minimizedView.hidden = YES;
                     }];
    
}

- (void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    switch ( recognizer.state )
    {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handlGestureStateChangedWithRecognizer:recognizer];
            break;
            
        case UIGestureRecognizerStateEnded:
            
            [self handlGestureStateEndedWithRecognizer:recognizer];
            
            break;
            
        case UIGestureRecognizerStateCancelled:
            break;
            
        default:
            break;
    }
    

    
}

- (void)handlGestureStateChangedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    
    int y = [recognizer translationInView:self.view].y;
    
    if(y > panGestureRecognizer_Y)
    {
        
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.view.frame = CGRectMake(0, y,  self.view.frame.size.width, self.view.frame.size.height);
                             
                             
                         }completion:^(BOOL complete){
                             self.view.frame = CGRectMake(0,
                                                          self.view.frame.size.height - 30,
                                                          self.view.frame.size.width,
                                                          self.view.frame.size.height );
                             
                             self.minimizedView.hidden = NO;
                         }];
        
       
    }
}

- (void)handlGestureStateEndedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    int y = [recognizer translationInView:self.view].y;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    //NSLog(@"got a remote event! %ld", (long)receivedEvent);
  
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
           
            case UIEventSubtypeRemoteControlPlay:
                [self.player play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self.player pause];
                break;
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playPauseButtonWasPressed:nil];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                [self rewindButtonWasPressed:nil];

                break;
            case UIEventSubtypeRemoteControlNextTrack:
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                [self fastForwardButtonWasPressed:nil];
                
                break;
                
            default:
                break;
        }
    }
}
@end
