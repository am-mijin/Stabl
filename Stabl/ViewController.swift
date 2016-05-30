//
//  ViewController.swift
//  Stabl
//
//  Created by Mijin Cho on 02/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit

import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var podcasts = [NSManagedObject]()
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // saveName("bbc")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
  
        fetchAllPodcasts()
    }
    
    func saveName(name : String)
    {
        
        let appDelegate    = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        
    
        
        let podcast = NSEntityDescription.insertNewObjectForEntityForName("NewPodcast", inManagedObjectContext: managedContext) as! NewPodcast
        
        podcast.artistName = "BBC"
        podcasts.append(podcast)
        
    }
    
    func fetchAllPodcasts()
    {
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest(entityName: "NewPodcast")
        
        do
        {
            let fetchedResult = try managedContext.executeFetchRequest(fetchRequest) as? [NewPodcast]
            
            if let results = fetchedResult
            {
                podcasts = results
                self.tableView.reloadData()
                
                if (results.count > 0){
                    self.tableView.hidden = false
                    
                    print(fetchedResult![0].artistName )
                }else{
                    self.tableView.hidden = true
                }
               
            }
            else
            {
                print("Could not fetch result")
            }
        }
        catch
        {
            print("There is some error.")
        }
        
    }
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.podcasts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchTableViewCell
        
        var podcast:NewPodcast
        
       
        podcast = self.podcasts[indexPath.row] as! NewPodcast
        
        
        let imageUrl:String  =  podcast.artworkUrl100!
        cell.nameLabel.text = podcast.collectionName
        cell.authorLabel.text = podcast.artistName!.uppercaseString
        
        cell.episodesLabel.text = "24 EPISODES".uppercaseString
        ImageLoader.sharedLoader.imageForUrl(imageUrl, completionHandler:{(image: UIImage?, url: String) in
            cell.artwork.image = image
        })
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        let selectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
        let newPodcast:NewPodcast = self.podcasts[selectedIndexPath.row] as! NewPodcast
       
        let artistId = newPodcast.artistId as! Int
        let artistName = newPodcast.artistName
        let collectionId = newPodcast.collectionId as! Int
        let collectionName = newPodcast.collectionName
        let trackName = newPodcast.trackName
        let artistViewUrl = newPodcast.artistViewUrl
        let collectionViewUrl = newPodcast.collectionViewUrl
        let feedUrl = newPodcast.feedUrl
        //let releaseDate = newPodcast.releaseDate
        let country = newPodcast.country
        let artworkUrl100 = newPodcast.artworkUrl100
        let primaryGenreName = newPodcast.primaryGenreName
        
        
        let podcast = Podcast(artistId:artistId,
            collectionId:collectionId,
            artistName:artistName!,
            collectionName:collectionName!,
            trackName:trackName!,
            artistViewUrl:artistViewUrl!,
            collectionViewUrl:collectionViewUrl!,
            feedUrl:feedUrl!,
            artworkUrl100:artworkUrl100!,
            releaseDate:"",
            country:country!,
            primaryGenreName:primaryGenreName!)

        
        if segue.identifier == "PodcastDetailsSegue" {
            
            if let controller = segue.destinationViewController as? ShowEpisodesViewController{
                controller.podcast = podcast
                
                print(podcast.artworkUrl100)
            }
        }
    }
    
   @IBAction func addPodcasts(sender: AnyObject) {
    
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("SearchNavigationController") as! UINavigationController
        
        self.presentViewController(navigationController, animated: true, completion: nil)

    //self.fetchAllPodcasts()
    }
    
  
}

