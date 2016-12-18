//
//  WelcomeViewController.swift
//  Stabl
//
//  Created by Mijin Cho on 21/09/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     override var prefersStatusBarHidden : Bool {
     return true
     }
     
     override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
     return UIStatusBarAnimation.slide
     }
     override var preferredStatusBarStyle : UIStatusBarStyle {
     return .lightContent
     }
    
    @IBAction func start(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SelectGenresViewController") as! SelectGenresViewController
       
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
