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
    
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var uptoLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var currentDuration :Int = 15
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
        
        self.title = "How much time do you have?"
        self.navigationController?.isNavigationBarHidden = false
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
        return false
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
    
    @IBAction func minusplusbuttonPressed(sender: UIButton) {
        
        minusBtn.setImage(UIImage(named:"group3-2"), for: .normal)
        plusBtn.setImage(UIImage(named:"group3-4"), for: .normal)
        if( sender.tag == 1){
            currentDuration = currentDuration + 15
            
           
            if( currentDuration >= 60){
                currentDuration = 60
                
                plusBtn.setImage(UIImage(named:"group3-3"), for: .normal)
            }
        }else{
            currentDuration = currentDuration - 15
            
            if( currentDuration <= 15){
                currentDuration = 15
                
                minusBtn.setImage(UIImage(named:"group3-1"), for: .normal)
                plusBtn.setImage(UIImage(named:"group3-4"), for: .normal)
            }
        }
        
        
        switch currentDuration {
        case 15:
            self.uptoLabel.text = "Up to"
            self.minutesLabel.text = "Minutes"
            self.durationLabel.text = "15"
            break
        case 30:
            
            self.uptoLabel.text = "Between"
            self.minutesLabel.text = "Minutes"
            self.durationLabel.text = "15-30"
            break
        case 45:
            
            self.uptoLabel.text = "Between"
            self.minutesLabel.text = "Minutes"
            self.durationLabel.text = "30-45"
            break
        case 60:
            
            self.uptoLabel.text = "Around"
            self.minutesLabel.text = "Hour"
            self.durationLabel.text = "1"
            break
        default: break
            
        }
        
    }
    
    
    @IBAction func searchRandomAudio(sender: UIButton) {
        
        let eventstr:String = "random"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        controller.genres = self.genres
        controller.min_duration = 0
        controller.max_duration = 0
        BITHockeyManager.shared().metricsManager.trackEvent(  withName:   eventstr)
        
        self.navigationController!.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        var eventstr:String = "random"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        controller.genres = self.genres
        
        switch currentDuration {
        case 15:
            controller.min_duration = 0
            controller.max_duration = 900
            eventstr = "15 mins"
            break
        case 30:
            controller.min_duration = 900
            controller.max_duration = 1800
              eventstr = "30 mins"
            break
        case 45:
            controller.min_duration = 1800
            controller.max_duration = 2700
            eventstr = "45 mins"
            break
        case 60:
            controller.min_duration = 3600
            controller.max_duration = 4500
            eventstr = "1 hour"
            break
        default:break
        }
        
        BITHockeyManager.shared().metricsManager.trackEvent(  withName:   eventstr)
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func feedback(_ sender: AnyObject) {
        
        
        BITHockeyManager.shared().feedbackManager.showFeedbackComposeView()
        
    }
  
}
