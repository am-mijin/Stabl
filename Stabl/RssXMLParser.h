//
//  RssXMLParser.h
//  Stabl
//
//  Created by Mijin Cho on 06/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssXMLParser : NSObject <NSXMLParserDelegate>
{
    //for switch and case
    enum nodes {title = 1, postlink = 2, pubDate = 3, invalidNode = -1};
    enum nodes aNode;
    
    NSMutableDictionary *articles;
    
    NSString *lastTitle;
}
-(void) parseRssXML: (NSData *)xmldata;
@end
