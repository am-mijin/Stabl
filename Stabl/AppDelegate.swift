//
//  AppDelegate.swift
//  Stabl
//
//  Created by Mijin Cho on 02/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import Parse
import FirebaseAnalytics

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var playerViewController: AAPLPlayerViewController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
     
        
       /*Autosend crash reports*/
       /*
       BITHockeyManager.shared().configure(withIdentifier: "88329a4ab29a47c79a55a630d6e6216b")
       BITHockeyManager.shared().crashManager.crashManagerStatus  = BITCrashManagerStatus.autoSend
        
       BITHockeyManager.shared().start()
        
       BITHockeyManager.shared().authenticator.authenticateInstallation();
       // This line is obsolete in the crash only build
       */
        
       FIRApp.configure()
     
       let configuration = ParseClientConfiguration {
            $0.applicationId = "stabl"
            $0.server = "https://stabl.herokuapp.com/parse"
            //$0.server = "http://YOUR_PARSE_SERVER:1337/parse"
        }
        Parse.initialize(with: configuration)
        
        
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError
        {
            print(error)
        }
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        self.restore()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        self.save()
    }

  
    

    func quaryFeed(){
        
        let primaryGenreName = PFQuery(className:"NewPodcastItem")
        primaryGenreName.whereKey("primaryGenreName", equalTo:"Comedy")
        
        
        
        
        let genres = ["Comedy","History"]
        
        let predicate = NSPredicate(format: "enclosure.duration > 2155 AND genres IN %@",genres)
        let query = PFQuery(className: "NewPodcastItem", predicate: predicate)
       
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) objects.")
                // Do something with the found objects
                if let objects = objects {
                    
                    for object in objects {
                        print (object)
                        let collectionId:Int = (object["collectionId"] as? Int)!
                         print(collectionId)

                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!._userInfo)")
            }
        }
        
        //let genres = PFQuery(className:"PodcastItem")
        //genres.whereKey("genres", containedIn:["Comedy","History","Professional","Literature","Society & Culture"])
        
        /*
        let query = PFQuery.orQueryWithSubqueries([duration])
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
               // results contains players with lots of wins or only a few wins.
              
                for podcast in results! {
                   
                    let title = podcast["title"] as? String
                    let primaryGenreName = podcast["primaryGenreName"] as? String
                    
                    let enclosure:NSDictionary = (podcast["enclosure"] as? NSDictionary)!
                    print(enclosure)
                    
                    let duration:Int = (enclosure ["duration"] as? Int)!
                    print(title)
                    
                    print(duration)
                }
            }
        }*/
        
//        
//        let query = PFQuery(className:"PodcastItem")
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count).")
//                
//                // Do something with the found objects
//                if let objects = objects {
//                    
//                    
//                    Global.sharedInstance().feeds.removeAllObjects()
//                    
//                    for object in objects {
//                        print(object)
//                        print(object.objectId)
//                            let artistId = 0
//                            //let artistId = object.objectForKey("artistId") as! Int
//                        
//                            let collectionId = 0
//                            let artistName = object.objectForKey("artistName")as! String
//                            //let collectionId = object.objectForKey("collectionId") as! Int
//                            let collectionName = object.objectForKey("collectionName") as! String
//                            //let trackName = object.objectForKey("trackName") as! String
//                            let trackName = ""
//                            let artistViewUrl = ""
//                            let collectionViewUrl = ""
//                            //let artistViewUrl = object.objectForKey("artistViewUrl") as! String
//                            //let collectionViewUrl = object.objectForKey("collectionViewUrl") as! String
//                            let feedUrl = object.objectForKey("feedUrl") as! String
//                            let artworkUrl100 = object.objectForKey("artworkUrl100") as! String
//                            //let releaseDate = object.objectForKey("releaseDate") as! String
//                            let releaseDate = ""
//                            let country = ""
//                            let primaryGenreName = ""
//                            //let country = object.objectForKey("country") as! String
//                            //let primaryGenreName = object.objectForKey("primaryGenreName") as! String
//                            
//                        
//                            let podcast = Podcast(artistId:artistId,
//                                collectionId:collectionId,
//                                artistName:artistName,
//                                collectionName:collectionName,
//                                trackName:trackName,
//                                artistViewUrl:artistViewUrl,
//                                collectionViewUrl:collectionViewUrl,
//                                feedUrl:feedUrl,
//                                artworkUrl100:artworkUrl100,
//                                releaseDate:releaseDate,
//                                country:country,
//                                primaryGenreName:primaryGenreName)
//                        
//
//                                Global.sharedInstance().feeds.addObject(podcast)
//                        
//                        /*
//                       
//                      
//                        //let entity = NSEntityDescription.insertNewObjectForEntityForName("NewPodcast", inManagedObjectContext: self.managedObjectContext) as! NewPodcast
//                        
//                        let entity = NSEntityDescription.insertNewObjectForEntityForName("NewPodcast", inManagedObjectContext: self.managedObjectContext) as! NewPodcast
//
//                        
//                        entity.artistId = artistId
//                        entity.artistName = artistName
//                        
//                        entity.collectionId = collectionId
//                        
//                        entity.trackName = trackName
//                        
//                        entity.artistViewUrl = artistViewUrl
//                        
//                        entity.collectionViewUrl = collectionViewUrl
//                        entity.feedUrl = feedUrl
//                        
//                        entity.artworkUrl100 = artworkUrl100
//                        
//                        entity.releaseDate = releaseDate
//                        
//                        entity.country = country
//                        
//                        
//                        var error: NSError?
//                        let success = self.self.managedObjectContext.save(&error)
//                        
//                        Global.sharedInstance().feeds.addObject(entity)
//                        //self.managedObjectContext.rollback()
//                        
//                        */
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
//        
    }
    /*
    func test(){
        
        ParseAPI.test()
    }
    */
    /*
    func enterFullScreen(){
        
        self.window?.addSubview(self.playerViewController!.view)
        self.playerViewController!.view.frame = self.window!.bounds
        DispatchQueue.main.async {
            
        }
    }
    
    func exitFullScreen(){
        
        //self.playerViewController!.podcast = podcast
        //self.playerViewController!.episode = episode as! [NSObject : AnyObject]
        let serialQueue = DispatchQueue(label: "com.stabl.stablapp", attributes: [])
        
        serialQueue.sync {
            
            self.playerViewController!.clearObservers()
        }
        
        self.playerViewController!.initPlayer()
    }
    */
    /*
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        let rc = event.subtype
        print("rc.rawValue: \(rc.rawValue)")
    
    }*/
    
    func restore(){
        
        let defaults  = UserDefaults.standard
        if let genres:NSMutableArray = defaults.object(forKey: "genres") as? NSMutableArray {
            Global.sharedInstance().genres = genres.mutableCopy() as! NSMutableArray
        }
        
        if let isFirstTime:Bool = defaults.object(forKey: "isFirstTime") as? Bool {
            
            Global.sharedInstance().isFirstTime = isFirstTime
        }
    }

    func save(){
        
        let defaults  = UserDefaults.standard
     
        
        defaults.set(Global.sharedInstance().genres, forKey: "genres")
        
        defaults.set(Global.sharedInstance().isFirstTime, forKey: "isFirstTime")
        
        print(Global.sharedInstance().isFirstTime)
        defaults.synchronize()
    }

}

