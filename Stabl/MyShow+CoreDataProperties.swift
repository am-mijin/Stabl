//
//  Person+CoreDataProperties.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import Foundation
import CoreData


extension MyShow {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyShow> {
//        return NSFetchRequest<MyShow>(entityName: "MyShow");
//    }

    @NSManaged var podcast: NewPodcast?
    @NSManaged var trackName: String?

}
