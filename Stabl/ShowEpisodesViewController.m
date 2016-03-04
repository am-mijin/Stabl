//
//  ShowEpisodesViewController.m
//  Stabl
//
//  Created by Mijin Cho on 12/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//


#import "Stabl-Swift.h"
#import "CustomTableViewCell.h"
#import "ShowEpisodesViewController.h"
#import "AAPLPlayerViewController.h"
//
//#import "Stabl-Bridging-Header.h"
// String used to identify the update object in the user defaults storage.
static NSString * const kLastStoreUpdateKey = @"LastStoreUpdate";

// Get the RSS feed for the first time or if the store is older than kRefreshTimeInterval seconds.
static NSTimeInterval const kRefreshTimeInterval = 3600;

// The number of songs to be retrieved from the RSS feed.
static NSUInteger const kImportSize = 300;
@interface ShowEpisodesViewController ()
{
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *description;
    NSMutableString *pubDate;
    NSString *element;
    NSString *channel;
}

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, weak)  IBOutlet UITableView *tableView;
@property (nonatomic, weak)  IBOutlet UIImageView *artwork;
@property (nonatomic, weak)  IBOutlet UILabel *titleLabel;
@property (nonatomic, weak)  IBOutlet UIView *sectionView;
@end
@implementation ShowEpisodesViewController
- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
   _sectionView.frame = CGRectMake(_sectionView.frame.origin.x, _sectionView.frame.origin.y, _sectionView.frame.size.width, 135);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text =  _podcast.collectionName;
  
    [[ImageLoader sharedLoader] imageForUrl: _podcast.artworkUrl100  completionHandler:^(UIImage *image, NSString *url) {
        _artwork.image = image;
    }];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterLongStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    self.dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
    // Do any additional setup after loading the view.
    _feeds = [NSMutableArray new];
    NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    
    url = [NSURL URLWithString:self.podcast.feedUrl];

    NSLog(@"%@",url);
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(NSInteger)numberofLines: (UILabel*)label
{
    
    CGSize sizeOfText = [label.text  sizeWithFont:label.font
                                    constrainedToSize:label.frame.size
                                        lineBreakMode:UILineBreakModeWordWrap];
    int numberOfLines = sizeOfText.height / label.font.pointSize;
    
     return numberOfLines;
}

#pragma mark - Table View



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return _feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CustomTableViewCell";
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDictionary* feed = [_feeds objectAtIndex:indexPath.row];

    cell.label1.text = [feed objectForKey: @"title"];
    NSString* dateString = [feed objectForKey: @"pubDate"];
    cell.label2.text = dateString;
    cell.desc.text =  [feed objectForKey: @"description"];

    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CustomTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int numberOfLines = [self numberofLines:cell.desc];
    
    [cell.button setHidden: YES];
    if(numberOfLines >= 2 )
        [cell.button setHidden: NO];
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(cell.label1.frame.origin.x, cell.label1.frame.origin.y + sizeOfText.height + 5 , 107, 30);
//    [button setBackgroundImage:[UIImage imageNamed:@"btn_show_notes"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(show_notes) forControlEvents:UIControlEventTouchUpInside];
//    
//    button.tag = indexPath.row;
//    
//    [cell.contentView addSubview:button];

    
    NSLog(@"numberOfLines %d",numberOfLines);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary *episode = _feeds[indexPath.row];
   
    AAPLPlayerViewController * controller = (AAPLPlayerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    controller.podcast = _podcast;
    controller.episode = episode;
    [self presentViewController:controller animated:NO completion:nil];
    
}

#pragma mark - <NSXMLParserDelegate> Implementation


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    if([elementName isEqualToString:@"channel"])
    {
        channel = [[NSMutableString alloc] init];
        return;
    }
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        pubDate    = [[NSMutableString alloc] init];
        description    = [[NSMutableString alloc] init];
        
    }
   
    
    if([element isEqualToString:@"enclosure"])
    {
        NSString *urlValue=[attributeDict valueForKey:@"url"];
        
        NSString *length=[attributeDict valueForKey:@"length"];
        NSLog(@"urlValue %@",urlValue);
        [item setObject:urlValue forKey:@"link"];
        [item setObject:length forKey:@"length"];
        //NSString *type=[attributeDict valueForKey:@"type"];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
   
    if([elementName isEqualToString:@"channel"]){
        
        [item setObject:description forKey:@"description"];
        NSLog(@"feeds %@",item);
    }
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        [item setObject:description forKey:@"description"];
        [item setObject:pubDate forKey:@"pubDate"];
        [_feeds addObject:[item copy]];
       // NSLog(@"feeds %@",item);
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    }
    else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
    }
    else if ([element isEqualToString:@"pubDate"]) {
        [pubDate appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
}

- (IBAction)backButtonPressed:(id )sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    //[self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)show_notes:(id )sender {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   /*
    if ([[segue identifier] isEqualToString:@"playAudio"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *episode = _feeds[indexPath.row];
        
        AAPLPlayerViewController* controller = (AAPLPlayerViewController*)[segue destinationViewController];
        controller.podcast = _podcast;
        controller.episode = episode;
        
    }*/
}
@end
