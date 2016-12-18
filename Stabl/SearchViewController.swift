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

        self.navigationController?.navigationBar.tintColor = UIColor.purple
        self.title = "FIND NEW PODCASTS"
        self.sectionTitle.text = " THIS WEEK FROM STABL"
        searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override var prefersStatusBarHidden : Bool {
        return navigationController?.isNavigationBarHidden == false
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }
  
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
      
        let aString: String = self.searchBar.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+")

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
                if ((json?.object(forKey: "results") ) != nil && (json?.object(forKey: "results") as! NSArray).count > 0)
                {
                    self.tableView.isHidden = false
                    let array =  json?.object(forKey: "results") as! NSMutableArray
                    
                    if(array.count == 0){
                        
                        self.tableView.isHidden = true
                    }
                    for i in 0 ..< array.count {
                        let dic  = array[i] as! NSDictionary
                        
                        let artistId = 0
                            //dic.objectForKey("artistId") as! Int
                        
                        
                        let artistName = dic.object(forKey: "artistName")as! String
                        //let collectionId = dic.objectForKey("collectionId") as! Int
                        let collectionId = 0
                        
                        
                        
                        let collectionName = dic.object(forKey: "collectionName") as! String
                        let trackName = dic.object(forKey: "trackName") as! String
                        let artistViewUrl = ""
                            //dic.objectForKey("artistViewUrl") as! String
                        let collectionViewUrl = dic.object(forKey: "collectionViewUrl") as! String
                        let feedUrl = dic.object(forKey: "feedUrl") as! String
                        let artworkUrl100 = dic.object(forKey: "artworkUrl100") as! String
                        //artworkUrl600
                        let releaseDate = dic.object(forKey: "releaseDate") as! String
                        let country = dic.object(forKey: "country") as! String
                        let primaryGenreName = dic.object(forKey: "primaryGenreName") as! String
                        
                        /*
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
                        */
                        //managedContext.rollback()

                    }
                    
                }
                else{
                     //self.tableView.isHidden = true
                }
                DispatchQueue.main.async {
                    self.searchBar.resignFirstResponder()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func search(_ term:String, completion: @escaping (_ json:NSDictionary?, _ error:NSError?)->()) {
     
        search = true
        let urlStr = "https://itunes.apple.com/search?term=\(term)&entity=podcast&limit=25&country=gb"
        
        //let urlStr = "https://itunes.apple.com/lookup?id=1046028598&entity=podcast"
        print (urlStr)
        let endpoint : URL = URL(string: urlStr)!
        print(endpoint)
        
        
        let session = URLSession.shared
       
        let task = session.dataTask(with: endpoint, completionHandler: {
            (data:Data?, response:URLResponse?, error:NSError?) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
               
                
                completion(json, nil)
            } catch let caught as NSError {
                completion(nil, caught)
            } catch {
                let error: NSError = NSError(domain: "<Your domain>", code: 1, userInfo: nil)
                completion(nil, error)
            }
        } as! (Data?, URLResponse?, Error?) -> Void) 
        
        task.resume()
    }
    
    func getTrending(){
        
        let url = "https://www.audiosear.ch/api/trending"
        let endpoint = URL(string: url)
       
        let session = URLSession.shared
        let task = session.dataTask(with: endpoint!, completionHandler: {
            (data:Data?, response:URLResponse?, error:NSError?) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
              
                //completion(json: json, error:nil)
            } catch let caught as NSError {
               
                //completion(json: nil, error:caught)
            } catch {
                // Something else happened.
                let error: NSError = NSError(domain: "<Your domain>", code: 1, userInfo: nil)
                //completion(json: nil, error:error)
                print(error)
            }
        } as! (Data?, URLResponse?, Error?) -> Void) 
        
        task.resume()
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cellIdentifier = "SearchTableViewCell"
        
       let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
        var podcast:Podcast
        
        if(search)
        {
            podcast = self.results[(indexPath as NSIndexPath).row] as! Podcast
        }
        else
        {
             podcast = Global.sharedInstance().feeds[(indexPath as NSIndexPath).row] as! Podcast
        }
        
       let imageUrl:String  =  podcast.artworkUrl100!
       cell.nameLabel.text = podcast.collectionName
       cell.authorLabel.text = podcast.artistName!.uppercased()
        
       cell.episodesLabel.text = "24 EPISODES".uppercased()
       ImageLoader.sharedLoader.imageForUrl(imageUrl, completionHandler:{(image: UIImage?, url: String) in
            cell.artwork.image = image
        })
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       
        
        let selectedIndexPath:IndexPath = self.tableView.indexPathForSelectedRow!
        let podcast:Podcast  = self.results[(selectedIndexPath as NSIndexPath).row] as! Podcast
        
        
        if segue.identifier == "PodcastDetailsSegue" {
            
          
            if let controller = segue.destination as? ShowEpisodesViewController{
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
    @IBAction func showAllEpisodes(_ sender: AnyObject) {
        
    }
    @IBAction func backButtonPressed(_ sender: AnyObject) {
      //self.navigationController!.popViewControllerAnimated(true)
        self .dismiss(animated: false, completion: nil)
    }
    
   

}
