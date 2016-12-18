//
//  SelectGenresViewController.swift
//  Stabl
//
//  Created by Mijin Cho on 13/09/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit

class SelectGenresViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBtn: UIButton!
    let images: NSArray = ["100x100bb-1","100x100bb-2","100x100bb-3","100x100bb-3","100x100bb-3","100x100bb-3","100x100bb-3","100x100bb-3","100x100bb-3","100x100bb-3","100x100bb-3","100x100bb-3"]
    
    let genres: NSArray = ["Comedy","Society & Culture","History","Arts","Sport","Literature" ,"Science & Medicine" ,"News & Politics" ,"Business","Technology" ,"Education","TV & Film"]
    
    
    var array: NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = true
        
        self.array = Global.sharedInstance().genres
        
        if(self.array.count > 0){
            doneBtn.isEnabled = true
        }else{
            
            doneBtn.isEnabled = false
        }
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
      
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
     
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier = "CustomCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        
        var index:Int = (indexPath as NSIndexPath).row
        
        if( (indexPath as NSIndexPath).row > 0){
            index = index + (indexPath as NSIndexPath).row
        }
        cell.imageView1.image = UIImage(named:images.object(at: index ) as! String)
        cell.imageView2.image = UIImage(named:images.object(at: index + 1) as! String)
        cell.label1.text = genres.object(at: index ) as? String
        cell.label2.text = genres.object(at: index + 1) as? String
        cell.button1.tag = index
        cell.button2.tag = index + 1
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        for string  in Global.sharedInstance().genres{
            
            let genre:String = string as! String
            if(genre.caseInsensitiveCompare(cell.label1.text!)  == .orderedSame){
                cell.button1.isSelected = true
            }
            if(genre.caseInsensitiveCompare(cell.label2.text!)  == .orderedSame){
                cell.button2.isSelected = true
            }
        }
        
        return cell
    }
    
    @IBAction func add(_ sender: AnyObject) {
        
        let button:UIButton = sender as! UIButton
        button.isSelected = !button.isSelected
        
        //let view = button.superview!
        //let cell = view.superview as! CustomCell
        
        //let indexPath = self.tableView.indexPathForCell(cell)
      
        if( button.isSelected ){
            array.add( self.genres.object(at: button.tag))
            
        }else{
            array.remove(self.genres.object(at: button.tag))
        }
        if(self.array.count > 0){
            doneBtn.isEnabled = true
        }else{
            
            doneBtn.isEnabled = false
        }
        
        print(array)
    }
    
    @IBAction func done(sender: AnyObject) {
        
        Global.sharedInstance().genres = self.array
        
        
        self.dismiss(animated: false, completion: {
        
            
            let appDelegate:AppDelegate   = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.save()})
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SelectDurationViewController") as! SelectDurationViewController
        controller.genres = self.array
        
        self.navigationController!.pushViewController(controller, animated: true)*/
    }
    

}
