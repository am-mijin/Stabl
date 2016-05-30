//
//  SearchViewController.swift
//  Stabl
//
//  Created by Mijin Cho on 02/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var sectionTitle: UILabel!
    
    var search: Bool = false
    
    var results:NSMutableArray = NSMutableArray ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.purpleColor()
        self.title = "FIND NEW PODCASTS"
        self.sectionTitle.text = " THIS WEEK FROM STABL"
        searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }
  
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
      
      
        let aString: String = self.searchBar.text!
        let newString = aString.stringByReplacingOccurrencesOfString(" ", withString: "+")

        if(search == true)
        {
            
            self.sectionTitle.text = " SEARCH RESULTS"
            return
        }
        
        self.sectionTitle.text = " THIS WEEK FROM STABL"
        search(newString) { (json, error) -> () in
            if error != nil {
                print(error!)
            } else {
                print(json!)
                
                self.results.removeAllObjects()
                if ((json?.objectForKey("results") ) != nil)
                {
                    let array =  json?.objectForKey("results") as! NSMutableArray
                    for var i = 0; i<array.count;i++ {
                        let dic  = array[i] as! NSDictionary
                        
                        let artistId = dic.objectForKey("artistId") as! Int
                        let artistName = dic.objectForKey("artistName")as! String
                        let collectionId = dic.objectForKey("collectionId") as! Int
                        let collectionName = dic.objectForKey("collectionName") as! String
                        let trackName = dic.objectForKey("trackName") as! String
                        let artistViewUrl = dic.objectForKey("artistViewUrl") as! String
                        let collectionViewUrl = dic.objectForKey("collectionViewUrl") as! String
                        let feedUrl = dic.objectForKey("feedUrl") as! String
                        let artworkUrl100 = dic.objectForKey("artworkUrl100") as! String
                        //artworkUrl600
                        let releaseDate = dic.objectForKey("releaseDate") as! String
                        let country = dic.objectForKey("country") as! String
                        let primaryGenreName = dic.objectForKey("primaryGenreName") as! String
                        
                        /*
                        let appDelegate    = UIApplication.sharedApplication().delegate as? AppDelegate
                        
                        let managedContext = appDelegate!.managedObjectContext
                     
                        let entity = NSEntityDescription.insertNewObjectForEntityForName("NewPodcast", inManagedObjectContext:managedContext) as! NewPodcast
                       
                       
                        entity.artistId = artistId
                        entity.artistName = artistName
                        
                        entity.collectionId = collectionId
                        
                        entity.trackName = trackName
                        
                        entity.artistViewUrl = artistViewUrl
                        
                        entity.collectionViewUrl = collectionViewUrl
                        entity.feedUrl = feedUrl
                        
                        entity.artworkUrl100 = artworkUrl100
                        
                        entity.releaseDate = releaseDate
                        
                        entity.country = country
                        */
                        let podcast = Podcast(artistId:artistId,
                            collectionId:collectionId,
                            artistName:artistName,
                            collectionName:collectionName,
                            trackName:trackName,
                            artistViewUrl:artistViewUrl,
                            collectionViewUrl:collectionViewUrl,
                            feedUrl:feedUrl,
                            artworkUrl100:artworkUrl100,
                            releaseDate:releaseDate,
                            country:country,primaryGenreName:primaryGenreName)
                        
                        
                        self.results.addObject(podcast)
                        
                        //managedContext.rollback()

                    }
                    
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.searchBar.resignFirstResponder()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func search(term:String, completion: (json:NSDictionary?, error:NSError?)->()) {
     
        search = true
        let urlStr = "https://itunes.apple.com/search?term=\(term)&entity=podcast&limit=25&country=gb"
        
        print (urlStr)
        let endpoint : NSURL = NSURL(string: urlStr)!
        print(endpoint)
        
        let session = NSURLSession.sharedSession()
       
        let task = session.dataTaskWithURL(endpoint) {
            (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary
               
                
                completion(json: json, error:nil)
            } catch let caught as NSError {
                completion(json: nil, error:caught)
            } catch {
                let error: NSError = NSError(domain: "<Your domain>", code: 1, userInfo: nil)
                completion(json: nil, error:error)
            }
        }
        
        task.resume()
    }
    
    func getTrending(){
        
        let url = "https://www.audiosear.ch/api/trending"
        let endpoint = NSURL(string: url)
       
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(endpoint!) {
            (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary
              
                //completion(json: json, error:nil)
            } catch let caught as NSError {
               
                //completion(json: nil, error:caught)
            } catch {
                // Something else happened.
                let error: NSError = NSError(domain: "<Your domain>", code: 1, userInfo: nil)
                //completion(json: nil, error:error)
                print(error)
            }
        }
        
        task.resume()
    }
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(search)
        {
              return self.results.count
        }
        else
        {
            return Global.sharedInstance().feeds.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cellIdentifier = "SearchTableViewCell"
        
       let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchTableViewCell
        
        var podcast:Podcast
        
        if(search)
        {
            podcast = self.results[indexPath.row] as! Podcast
        }
        else
        {
             podcast = Global.sharedInstance().feeds[indexPath.row] as! Podcast
        }
        
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
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       
        
        let selectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
        var podcast:Podcast
        
        if(search == true)
        {
           podcast = self.results[selectedIndexPath.row] as! Podcast
        }
        else
        {
            podcast = Global.sharedInstance().feeds[selectedIndexPath.row] as! Podcast
        }
        
        if segue.identifier == "PodcastDetailsSegue" {
            
          
            if let controller = segue.destinationViewController as? ShowEpisodesViewController{
                controller.podcast = podcast
                
                print("-----------")
                print(podcast.artworkUrl100)
            }
        }
    }
    /*
    func hello (){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ShowEpisodesViewController") as! ShowEpisodesViewController
        
        vc.podcast = podcast
        
    }*/
    
    @IBAction func backButtonPressed(sender: AnyObject) {
      //self.navigationController!.popViewControllerAnimated(true)
        self .dismissViewControllerAnimated(false, completion: nil)
    }
    
   

}
