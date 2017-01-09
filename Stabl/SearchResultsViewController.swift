//
//  SearchResultsViewController.swift
//  Stabl
//
//  Created by Mijin Cho on 02/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//


@objc class Constants: NSObject {
    static var string: String?
    private override init() {}
    
    public class func htmlEncodedString() -> String {
        return String(htmlEncodedString:string!)
    }
}

extension String
{
   
    init(htmlEncodedString: String) {
        self.init()
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }
        
        let attributedOptions: [String : Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        } catch {
            print("Error: \(error)")
            self = htmlEncodedString
        }
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.regularExpression, range: nil)
    }
}

import UIKit
class SearchResultsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate  {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var loadingView: UIImageView!
    
    var genres: NSArray = []
    
    var min_duration :Int = 0
    var max_duration :Int = 0
    var results:NSMutableArray = NSMutableArray ()
    
    var sortArray:NSMutableDictionary = NSMutableDictionary ()
    var dateFormatter:DateFormatter = DateFormatter.init()
    
    var pubDateFormatter:DateFormatter = DateFormatter.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        
        pubDateFormatter.dateFormat = "dd MMM yyyy"
        switch max_duration {
        case 900:
             self.title = "Up to 15 Minutes"
            break
            
        case 1800:
             self.title = "15-30 Minutes"
            break
        case 2700:
             self.title = "30-45 Minutes"
            break
        case 4500:
             self.title = "Around 1 hour"
            break
        default:
             self.title = "Random podcasts"
        }
       
       
        self.search()
        
        self.navigationController?.isNavigationBarHidden = false
        
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 160
        //self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        /*
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SearchResultsViewController.messageRecieved(_:)),
            name: NSNotification.Name(rawValue: ShowAllEpisodesNotification),
            object: nil)
        */
        Global.sharedInstance().curMenu = kSearch

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
 
    
    
    @objc func messageRecieved(_ notification: NSNotification){
        
        navigationController?.isNavigationBarHidden = false
     
        if(Global.sharedInstance().curMenu != kAllEpisodes){
            
            let userInfo = notification.userInfo
            
            let podcast:Podcast = userInfo!["podcast"]  as! Podcast
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ShowEpisodesViewController") as! ShowEpisodesViewController
            vc.podcast = podcast
            
            self.navigationController!.pushViewController(vc, animated: false)
        }
        //self.present(vc, animated: false, completion: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
        
    }
    
    func search() {
        var images: [UIImage] = []
        for i in 1...3 {
            images.append(UIImage(named: "spinner_\(i)")!)
        }
        
        self.loadingView.animationImages = images
        self.loadingView.animationDuration = 0.7
        self.loadingView.animationRepeatCount = 0
        self.loadingView.startAnimating()

        
        
        self.results.removeAllObjects()
        self.sortArray.removeAllObjects()
        
        let date = Date()
        let pubDate:Date = date.addingTimeInterval(-60*3600*30*6)
        print(   dateFormatter.string(from: pubDate as Date))
     
        ParseAPI.random(self.genres, duration_min:Int32(Int(min_duration)), duration_max: Int32(Int(max_duration)), pubDate:dateFormatter.string(from: pubDate as Date),max:3,
                        block: { (result, error) in
                            //print(result)
                            
                            DispatchQueue.main.async {
                                
                                self.loadingView.stopAnimating()
                                self.loadingView.image = UIImage(named: "btn_refresh")!
                            }
                            
                            if(result != nil){
                                
                                
                                DispatchQueue.main.async {
                                    if((result as! NSArray).count == 0){
                                        self.tableView.isHidden = true
                                    }
                                    else{
                                        self.tableView.isHidden = false
                                    }
                                }
                               
                                
                                for object  in (result as? NSArray)! {
                                    let dic = object as! NSDictionary
                                    
                                    print(object)
                                    
                                    
                                    let duration:Int = dic.object(forKey:"duration") as! Int
                                    
                                    let collectionId:Int = dic.object(forKey:"collectionId") as! Int
                                    let trackCount:Int = dic.object(forKey:"trackCount") as! Int
                                    let collectionPrice:Float = dic.object(forKey:"collectionPrice") as! Float
                                    let currency:String = dic.object(forKey:"currency") as! String
                                    
                                    var enclosure:NSDictionary = NSDictionary()
                                    if((dic.object(forKey:"enclosure")) != nil){
                                        
                                        
                                        enclosure = dic.object(forKey:"enclosure") as! NSDictionary
                                    }
                                    //print(enclosure.object(forKey: "duration"))
                                    
                                    let artistName = dic.object(forKey: "artistName")as! String
                                    
                                    let collectionName = dic.object(forKey: "collectionName") as! String
                                    let title = dic.object(forKey: "title") as! String
                                    let string:String = dic.object(forKey: "description") as! String
                                  
                                    //print (String.init(htmlEncodedString:string))
                                    let description = String(htmlEncodedString:string)
                                    
                                        //string.replace(target: "<[^>]+>", withString:"")
                                    //description = description.replace(target: "&nbsp;", withString:"")
                                    
                                    //print(description)

                                    let feedUrl = dic.object(forKey: "feedUrl") as! String
                                    let artworkUrl100 = dic.object(forKey: "artworkUrl600") as! String
                                    
                                    //let pubDate = dic.object(forKey: "pubDate") as! Date
                                    let country = dic.object(forKey: "country") as! String
                                    let primaryGenreName = dic.object(forKey: "primaryGenreName") as! String
                                    let genres = dic.object(forKey: "genres") as! NSArray
                                    let releaseDate:String = dic.object(forKey: "releaseDate") as! String
                                    let pubDate :NSDate = self.dateFormatter.date(from :dic.object(forKey: "releaseDate") as! String) as! NSDate
                                    
                                    let podcast = Podcast(
                                        artistName:artistName,
                                        collectionId:collectionId,
                                        collectionName:collectionName,
                                        title:title,
                                        description:description,
                                        genres:genres,
                                        duration:duration,
                                        enclosure:enclosure,
                                        feedUrl:feedUrl,
                                        artworkUrl100:artworkUrl100,
                                        releaseDate:releaseDate,
                                        collectionPrice:collectionPrice,
                                        country:country,
                                        currency:currency,
                                        primaryGenreName:primaryGenreName,
                                        trackCount:trackCount )
                                    
                                    
                                    //self.results.add(podcast)
                                    self.sortArray.setValue(podcast, forKey: releaseDate)
                                    
                                    
                                }
                                
                                
                                let allkeys:NSArray = self.sortArray.allKeys as NSArray
                                let array:NSArray = allkeys.sortedArray(using: "compare:")  as NSArray
                                
                                for index in (0 ..< array.count).reversed() {
                                    let key =  array.object(at: index)
                                    print (key)
                                    self.results.add(self.sortArray.object(forKey: key))
                                }
                              
                                
                              
                           }
                           
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                          
                            
        })
    }

    /*
 
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
    */
    
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
    
        return self.results.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cellIdentifier = "SearchTableViewCell"
        
       let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
       var podcast:Podcast
       podcast = self.results[(indexPath as NSIndexPath).row] as! Podcast
       
        
       let imageUrl:String  =  podcast.artworkUrl100
       
       cell.collectionLabel.text = podcast.collectionName
       cell.authorLabel.text = podcast.artistName!.uppercased()
       cell.nameLabel.text = podcast.title
       //cell.episodesLabel.text = "\(podcast.trackCount) EPISODES".uppercased()
        
       cell.artwork.image = UIImage(named:"playicon")
       
       print(imageUrl)
       let totalSeconds:Int = podcast.duration
       let seconds = totalSeconds % 60;
       var min = totalSeconds / 60
       let hours = totalSeconds / 3600
        
       if(hours == 0){
        
            //cell.durationLabel.text = "\(min) mins"
       }else{
            min = (totalSeconds % 3600) / 60
        
        }
        
       cell.durationLabel.text = "\(hours):\(min):\(seconds)"
        
        let trackCount:Int = podcast.trackCount as! Int
       cell.durationLabel.text = "\(trackCount) EPISODES"
       //cell.descriptionLabel.text = podcast.desc
       cell.button.tag = indexPath.row
       ImageLoader.sharedLoader.imageForUrl(imageUrl, completionHandler:{(image: UIImage?, url: String) in
            cell.artwork.image = image
        })
        
        cell.button.tag = indexPath.row
        
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
       
        let podcast:Podcast = self.results[(indexPath as NSIndexPath).row] as! Podcast
        
        
         /*
        let appDelegate:AppDelegate   = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.playerViewController?.podcast = podcast
        
        appDelegate.playerViewController?.episode = nil
        
        if(appDelegate.playerViewController?.player.rate != 1.0)
        {
            appDelegate.enterFullScreen()
        }
        else
        {
            appDelegate.exitFullScreen()
            
        }
        */
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! AAPLPlayerViewController
        
        controller.episode = nil
        controller.podcast = podcast
        self.present(controller, animated: true, completion: nil)
        //self.navigationController!.pushViewController(controller, animated: true)
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       
        /*
        let podcast:Podcast = self.results[sender!.tag] as! Podcast
       
        
        if segue.identifier == "PodcastDetailsSegue" {
            
          
            if let controller = segue.destination as? ShowEpisodesViewController{
                controller.podcast = podcast
                
                print("-----------")
                print(podcast.artworkUrl100)
            }
        }
        
        
        let appDelegate:AppDelegate   = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.playerViewController?.podcast = podcast
        if(appDelegate.playerViewController?.player.rate != 1.0)
        {
            appDelegate.enterFullScreen()
        }
        else
        {
            appDelegate.exitFullScreen()
            
        }*/
    
        
    }
   
    @IBAction func about(_ sender: AnyObject) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        
        controller.podcast = self.results.object(at: sender.tag) as? Podcast
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //All objects and view are transparent

        self.present(controller, animated: false, completion: nil)
        
        
    }
    
    
    @IBAction func refresh(_ sender: AnyObject) {
        
        self.search()
        
    }
    
    /*
    func backButtonPressed(_ sender: AnyObject) {
      self.navigationController!.popViewController(animated: true)
      //self .dismiss(animated: false, completion: nil)
    }*/
    
    @IBAction func back(_ sender: AnyObject) {
        
        self.navigationController!.popViewController(animated: true)
    }

   
    @IBAction func showAll(sender: AnyObject) {
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ShowEpisodesViewController") as! ShowEpisodesViewController
        
        controller.podcast = self.results.object(at: sender.tag) as! Podcast
        self.navigationController!.pushViewController(controller, animated: true)*/
    }
}
