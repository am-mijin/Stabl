//
//  Podcast.swift
//  Stabl
//
//  Created by Mijin Cho on 06/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//


import UIKit

class Podcast: NSObject {
    var artistId : Int!
    var collectionId : Int!
    var artistName : String!
    var collectionName : String!
    var title: String!
    var desc: String!
    var genres: NSArray!
    var enclosure: NSDictionary!
//    var trackName : String!
//    var artistViewUrl : String!
    var feedUrl : String!
    var artworkUrl30 : String!
    var artworkUrl60 : String!
    var artworkUrl100 : String!
    var artworkUrl600 : String!
    var pubDate : NSDate!
    var country : String!
    var currency : String!
    var primaryGenreName : String!
    var collectionPrice: Float!
    var trackCount: Int!
    var duration: Int!
    var releaseDate: String!
    
    init( artistName : String, collectionId : Int, collectionName : String, title : String, description: String, genres : NSArray,
         duration: Int, enclosure : NSDictionary, feedUrl : String, artworkUrl100 : String, releaseDate : String, collectionPrice : Float, country : String, currency: String, primaryGenreName : String, trackCount:Int) {
        
        //self.artistId = artistId
        self.collectionId = collectionId
        self.artistName = artistName
        self.collectionName = collectionName
        self.title = title
        self.desc = description
        self.genres = genres
        self.enclosure = enclosure
        self.feedUrl = feedUrl
        self.artworkUrl100 = artworkUrl100
        self.collectionPrice = collectionPrice
        
        self.duration = duration
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.releaseDate = releaseDate
        //self.pubDate = dateFormatter.date(from: pubDate)
        self.country = country
        self.currency = currency
        self.primaryGenreName = primaryGenreName
        
        self.trackCount = trackCount
        super.init()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.trackCount = aDecoder.decodeObject(forKey: "trackCount") as! Int
        self.artistId = aDecoder.decodeObject(forKey: "artistId") as! Int
        self.collectionId = aDecoder.decodeObject(forKey: "collectionId") as! Int
        self.artistName = aDecoder.decodeObject(forKey: "artistName") as! String
        self.collectionName = aDecoder.decodeObject(forKey: "collectionName") as! String
        self.collectionPrice = aDecoder.decodeObject(forKey: "collectionPrice") as! Float
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.desc = aDecoder.decodeObject(forKey: "description") as! String
        self.feedUrl = aDecoder.decodeObject(forKey: "feedUrl") as! String
        self.artworkUrl100 = aDecoder.decodeObject(forKey: "artworkUrl100") as! String
        self.pubDate = aDecoder.decodeObject(forKey: "pubDate") as! Date as NSDate!
        self.country = aDecoder.decodeObject(forKey: "country") as! String
        self.currency = aDecoder.decodeObject(forKey: "currency") as! String
        self.primaryGenreName = aDecoder.decodeObject(forKey: "primaryGenreName") as! String
        self.genres = aDecoder.decodeObject(forKey: "genres") as! NSArray
        self.enclosure = aDecoder.decodeObject(forKey: "enclosure") as! NSDictionary
        
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(self.artistId, forKey: "artistId")
        aCoder.encode(self.collectionId, forKey: "collectionId")
        aCoder.encode(self.artistName, forKey: "artistName")
        aCoder.encode(self.collectionName, forKey: "collectionName")
        aCoder.encode(self.desc, forKey: "description")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.feedUrl, forKey: "feedUrl")
        aCoder.encode(self.artworkUrl100, forKey: "artworkUrl100")
        aCoder.encode(self.pubDate, forKey: "pubDate")
        aCoder.encode(self.country, forKey: "country")
        aCoder.encode(self.currency, forKey: "currency")
        aCoder.encode(self.primaryGenreName, forKey: "primaryGenreName")
       
        aCoder.encode(self.genres, forKey: "genres")
        aCoder.encode(self.enclosure, forKey: "enclosure")
        
        aCoder.encode(self.trackCount, forKey: "trackCount")
        aCoder.encode(self.collectionPrice, forKey: "collectionPrice")
    }
}
