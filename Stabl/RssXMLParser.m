//
//  RssXMLParser.m
//  Stabl
//
//  Created by Mijin Cho on 06/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

#import "RssXMLParser.h"

@implementation RssXMLParser
- (void) parseRssXML:(NSData *)xmldata
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmldata];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"item"])
    {
        aNode = invalidNode;
        if(articles == nil)
        {
            articles = [[NSMutableDictionary alloc] init];
        }
    }
    else if([elementName isEqualToString:@"title"])
    {
        aNode = title;
    }
    else if([elementName isEqualToString:@"link"])
    {
        aNode = postlink;
    }
    else
    {
        aNode = invalidNode;
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if( [elementName isEqualToString:@"rss"] )
    {
        NSLog(@"xxxxx");
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    switch (aNode) {
        case title:
        {
            string = [string stringByTrimmingCharactersInSet:[NSCharacterSet nonBaseCharacterSet]];
            string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(string.length != 0)
            {
                lastTitle = string;
            }
        }
            
            break;
        case postlink:
        {
            string = [string stringByTrimmingCharactersInSet:[NSCharacterSet nonBaseCharacterSet]];
            string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(string.length != 0 && articles != nil)
            {
                [articles setObject:string forKey:lastTitle];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
