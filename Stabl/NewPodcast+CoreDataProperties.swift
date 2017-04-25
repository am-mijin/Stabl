//
//  NewPodcast+CoreDataProperties.swift
//  Stabl
//
//  Created by Mijin Cho on 06/03/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension NewPodcast {

    @NSManaged var artistId: NSNumber?
    @NSManaged var collectionId: NSNumber?
    @NSManaged var artistName: String?
    @NSManaged var collectionName: String?
    @NSManaged var trackName: String?
    @NSManaged var artistViewUrl: String?
    @NSManaged var collectionViewUrl: String?
    @NSManaged var feedUrl: String?
    @NSManaged var playUrl: String?
    @NSManaged var artworkUrl100: String?
    @NSManaged var releaseDate: String?
    @NSManaged var country: String?
    @NSManaged var primaryGenreName: String?
    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var trackCount: NSNumber?
    @NSManaged var currentTrack: NSNumber?
    @NSManaged var currency: String?
    @NSManaged var duration: NSNumber?
    @NSManaged var collectionPrice: NSNumber?

    
}
