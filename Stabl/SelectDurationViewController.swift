//
//  SelectDurationViewController.swift
//  Stabl
//
//  Created by Mijin Cho on 18/09/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit

import HockeySDK
class SelectDurationViewController: BaseViewController {
    
    @IBOutlet weak var button: UIButton!
    
    var genres: NSArray = []
    
    var duration :Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.button.clipsToBounds = true;
        self.button.layer.cornerRadius = 75;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        self.navigationController?.isNavigationBarHidden = true
        if(Global.sharedInstance().isFirstTime  == true){
            Global.sharedInstance().isFirstTime = false
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let navigationController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as! UINavigationController
            let rootController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            navigationController.setViewControllers([rootController], animated: false)
            self.present(navigationController, animated: false, completion: nil)
        }
        
        
        genres = Global.sharedInstance().genres
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func selectGenres(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectGenresViewController") as! SelectGenresViewController
        
        self.present(vc, animated: false, completion: nil)
    }
    
    
    
    @IBAction func buttonPressed(sender: UIButton) {
        var eventstr:String = "random"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        controller.genres = self.genres
        
        switch sender.tag {
        case 0:
            controller.min_duration = 0
            controller.max_duration = 900
            eventstr = "15 mins"
            break
        case 1:
            controller.min_duration = 900
            controller.max_duration = 1800
              eventstr = "30 mins"
            break
        case 2:
            controller.min_duration = 1800
            controller.max_duration = 2700
            eventstr = "45 mins"
            break
        case 3:
            controller.min_duration = 3600
            controller.max_duration = 4500
            eventstr = "1 hour"
            break
        default:
            
            controller.min_duration = 0
            controller.max_duration = 0
        }
        
        BITHockeyManager.shared().metricsManager.trackEvent(  withName:   eventstr)
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func feedback(_ sender: AnyObject) {
        
        
        BITHockeyManager.shared().feedbackManager.showFeedbackComposeView()
        
    }
  
}
