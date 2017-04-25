//
//  SearchResultsViewController.swift
//  Stabl
//
//  Created by Mijin Cho on 02/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//




import UIKit
class MyShowsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var loadingView: UIImageView!
    
    var genres: NSArray = []
    
    var results:NSArray = NSArray ()
    
    var dateFormatter:DateFormatter = DateFormatter.init()
    
    var pubDateFormatter:DateFormatter = DateFormatter.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        
        pubDateFormatter.dateFormat = "dd MMM yyyy"
       
       
        
        self.navigationController?.isNavigationBarHidden = false
        
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
       
        //Global.sharedInstance().curMenu = kSearch
        self.fetchAllMyShows()
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    /*
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
        
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print (self.results.count)
        return self.results.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cellIdentifier = "SearchTableViewCell"
        
       let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
        
       let show : MyShow = self.results[(indexPath as NSIndexPath).row] as! MyShow
      
        
       let podcast : NewPodcast = show.podcast! 
       
       let imageUrl:String  =  podcast.artworkUrl100!
       
       cell.collectionLabel.text = podcast.collectionName
       cell.authorLabel.text = podcast.artistName!.uppercased()
       cell.nameLabel.text = podcast.title
       //cell.episodesLabel.text = "\(podcast.trackCount) EPISODES".uppercased()
        
       cell.artwork.image = UIImage(named:"playicon")
       
       print(imageUrl)
    
       let trackCount:Int = podcast.trackCount as! Int
       cell.durationLabel.text = "\(trackCount) EPISODES"
       //cell.descriptionLabel.text = podcast.desc
       cell.button.tag = indexPath.row
       ImageLoader.sharedLoader.imageForUrl(imageUrl, completionHandler:{(image: UIImage?, url: String) in
            cell.artwork.image = image
        })
        
        cell.button.tag = indexPath.row
        
        cell.artworkButton.tag = indexPath.row
        //let releaseDate :NSDate = self.dateFormatter.date(from :podcast.releaseDate) as! NSDate
        
        //cell.dateLabel.text = pubDateFormatter.string(from: releaseDate as Date)
       
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show : MyShow = self.results[(indexPath as NSIndexPath).row] as! MyShow
        
        
        let podcast : NewPodcast = show.podcast!
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! AAPLPlayerViewController
     
        controller.episode = nil
        controller.podcast = podcast
        self.present(controller, animated: true, completion: nil)
        //self.navigationController!.pushViewController(controller, animated: true)
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    @IBAction func about(_ sender: AnyObject) {
        let show : MyShow = self.results[sender.tag] as! MyShow
        
        
        let podcast : NewPodcast = show.podcast!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        controller.subtitle = podcast.collectionName!
        controller.podcast = podcast
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //All objects and view are transparent

        self.present(controller, animated: false, completion: nil)
        
        
    }
    
    
    @IBAction func refresh(_ sender: AnyObject) {
        
    }
    
    
    @IBAction func back(_ sender: AnyObject) {
        
        self.navigationController!.popViewController(animated: true)
    }

   
    @IBAction func play(sender: AnyObject) {
        let show : MyShow = self.results[sender.tag] as! MyShow
        
        
        let podcast : NewPodcast = show.podcast!
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! AAPLPlayerViewController
        
        controller.episode = nil
        controller.podcast = podcast
        self.present(controller, animated: true, completion: nil)
    }
    
    func fetchAllMyShows()
    {
        let managedContext = CoreDataStackManager.sharedInstance().managedObjectContext
        
        let fetchRequest   = NSFetchRequest<MyShow>(entityName: "MyShow")
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [MyShow]
            
            if let results = fetchedResult
            {
                self.results = results as NSArray
                self.tableView.reloadData()
                
                if (results.count > 0){
                    self.tableView.isHidden = false
                    
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
}
