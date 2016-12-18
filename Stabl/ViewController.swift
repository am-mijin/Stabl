//
//  ViewController.swift
//  Stabl
//
//  Created by Mijin Cho on 02/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit

import CoreData
extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var podcasts = [NSManagedObject]()
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
  
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let navigationController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as! UINavigationController
        let rootController = storyboard.instantiateViewController(withIdentifier: "SelectGenresViewController") as! SelectGenresViewController
        navigationController.setViewControllers([rootController], animated: false)
        self.present(navigationController, animated: false, completion: nil)
        
        //fetchAllPodcasts()
    }
    
    func saveName(_ name : String)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        
    
        
        let podcast = NSEntityDescription.insertNewObject(forEntityName: "NewPodcast", into: managedContext) as! NewPodcast
        
        podcast.artistName = "BBC"
        podcasts.append(podcast)
        
    }
    
    func fetchAllPodcasts()
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NewPodcast>(entityName: "NewPodcast")
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NewPodcast]
            
            if let results = fetchedResult
            {
                podcasts = results
                self.tableView.reloadData()
                
                if (results.count > 0){
                    self.tableView.isHidden = false
                    
                    print(fetchedResult![0].artistName )
                }else{
                    self.tableView.isHidden = true
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
        var podcast:NewPodcast
        
       
        podcast = self.podcasts[(indexPath as NSIndexPath).row] as! NewPodcast
        
        
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        /*
        
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
        }*/
    }
    
   @IBAction func addPodcasts(_ sender: AnyObject) {
    
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as! UINavigationController
        
        self.present(navigationController, animated: true, completion: nil)

    //self.fetchAllPodcasts()
    }
    
  
}

