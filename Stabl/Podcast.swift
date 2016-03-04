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
    var trackName : String!
    var artistViewUrl : String!
    var collectionViewUrl : String!
    var feedUrl : String!
    var artworkUrl100 : String!
    
    var releaseDate : NSDate!
    
    var country : String!
    
    var primaryGenreName : String!
  
    
    init(artistId : Int, collectionId : Int, artistName : String, collectionName : String, trackName : String, artistViewUrl : String, collectionViewUrl : String,feedUrl : String, artworkUrl100 : String, releaseDate : String, country : String, primaryGenreName : String) {
        
        self.artistId = artistId
        self.collectionId = collectionId
        self.artistName = artistName
        self.collectionName = collectionName
        self.trackName = trackName
        self.artistViewUrl = artistViewUrl
        self.collectionViewUrl = collectionViewUrl
        self.feedUrl = feedUrl
        self.artworkUrl100 = artworkUrl100
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "EEEE, h a"
//        
//        let dateString = dateFormatter.stringFromDate(releaseDate)
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.releaseDate = dateFormatter.dateFromString(releaseDate)
        
        self.country = country
        self.primaryGenreName = primaryGenreName
        super.init()
        
    }
    required init(coder aDecoder: NSCoder) {
        self.artistId = aDecoder.decodeObjectForKey("artistId") as! Int
        self.collectionId = aDecoder.decodeObjectForKey("collectionId") as! Int
        self.artistName = aDecoder.decodeObjectForKey("artistName") as! String
        self.collectionName = aDecoder.decodeObjectForKey("collectionName") as! String
        self.trackName = aDecoder.decodeObjectForKey("trackName") as! String
        self.artistViewUrl = aDecoder.decodeObjectForKey("artistViewUrl") as! String
        self.collectionViewUrl = aDecoder.decodeObjectForKey("collectionViewUrl") as! String
        
        self.feedUrl = aDecoder.decodeObjectForKey("feedUrl") as! String
        
        self.artworkUrl100 = aDecoder.decodeObjectForKey("artworkUrl100") as! String
        self.releaseDate = aDecoder.decodeObjectForKey("releaseDate") as! NSDate
        
        self.country = aDecoder.decodeObjectForKey("country") as! String
        
        self.primaryGenreName = aDecoder.decodeObjectForKey("primaryGenreName") as! String
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.artistId, forKey: "artistId")
        aCoder.encodeInteger(self.collectionId, forKey: "collectionId")
        aCoder.encodeObject(self.artistName, forKey: "artistName")
        aCoder.encodeObject(self.collectionName, forKey: "collectionName")
        
        aCoder.encodeObject(self.trackName, forKey: "trackName")
        aCoder.encodeObject(self.artistViewUrl, forKey: "artistViewUrl")
        
        aCoder.encodeObject(self.collectionViewUrl, forKey: "collectionViewUrl")
        
        aCoder.encodeObject(self.feedUrl, forKey: "feedUrl")
        aCoder.encodeObject(self.artworkUrl100, forKey: "artworkUrl100")
        
        aCoder.encodeObject(self.releaseDate, forKey: "releaseDate")
        
        aCoder.encodeObject(self.country, forKey: "country")
        aCoder.encodeObject(self.primaryGenreName, forKey: "primaryGenreName")
    }
}
