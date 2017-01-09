//
//  NotesViewController.swift
//  
//
//  Created by Mijin Cho on 30/12/2016.
//
//

import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var collectionLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var notesLabel: UILabel!
    
    @IBOutlet weak var notesView: UIView!
    
    var podcast : Podcast?
    var collection : String = ""
    
    var author : String = ""
    var notes : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.notesLabel.text =  podcast?.desc
        self.authorLabel.text = podcast?.artistName
        self.collectionLabel.text = podcast?.collectionName
        self.notesView.clipsToBounds = true;
        self.notesView.layer.cornerRadius = 5;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func back(_ sender: AnyObject) {
        
        self.dismiss(animated: false, completion: {})
    }
}
