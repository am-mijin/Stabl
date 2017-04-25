//
//  NotesViewController.swift
//  Stabl
//
//  Created by Mijin Cho on 02/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var collectionLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var notesLabel: UILabel!
    
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var textview: UITextView!
    
    var podcast : NewPodcast?
    var subtitle : String = ""
    var author : String = ""
    var notes : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.authorLabel.text = podcast?.artistName
        self.collectionLabel.text = subtitle
        self.notesView.clipsToBounds = true;
        self.notesView.layer.cornerRadius = 5;
        
        textview.text =   podcast?.desc
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
