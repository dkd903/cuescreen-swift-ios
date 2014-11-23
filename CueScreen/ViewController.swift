//
//  ViewController.swift
//  CueScreen
//
//  Created by Debjit Saha on 11/19/14.
//  Copyright (c) 2014 com.cuescreen.app. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var votingInfoLabel: UILabel!
    @IBOutlet weak var votingWaitLabel: UILabel!
    
    var circleView1 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    var circleView2 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    var circleView3 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    var circleView4 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    var circleView5 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    var circleView6 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    
    var cellViewTracker = 1
    
    let radius : CGFloat = 30
    let yCoord : CGFloat = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("updateTimerCue"), userInfo: nil, repeats: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //self.navigationController?.setNavigationBarHidden(TRUE)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            
            self.performSegueWithIdentifier("toLoginScreen", sender: self)
            
        } else {
            
            ViewControllerUtils().showActivityIndicator(self.view)
            
            //self.userName.text = prefs.valueForKey("USERNAME") as NSString
            
            circleView1 = CircleViewGrey(frame: CGRectMake(25,yCoord, radius, radius))
            self.view.addSubview(circleView1)
            self.setLabelView(40, yCoord: yCoord, labelText: "1")
            
            circleView2 = CircleViewGrey(frame: CGRectMake(72,yCoord, radius, radius))
            self.view.addSubview(circleView2)
            self.setLabelView(87, yCoord: yCoord, labelText: "2")
            
            circleView3 = CircleViewGrey(frame: CGRectMake(120,yCoord, radius, radius))
            self.view.addSubview(circleView3)
            self.setLabelView(135, yCoord: yCoord, labelText: "3")
            
            circleView4 = CircleViewGrey(frame: CGRectMake(165,yCoord, radius, radius))
            self.view.addSubview(circleView4)
            self.setLabelView(180, yCoord: yCoord, labelText: "4")
            
            circleView5 = CircleViewGrey(frame: CGRectMake(210,yCoord, radius, radius))
            self.view.addSubview(circleView5)
            self.setLabelView(225, yCoord: yCoord, labelText: "5")
        
            circleView6 = CircleViewGrey(frame: CGRectMake(255,yCoord, radius, radius))
            self.view.addSubview(circleView6)
            self.setLabelView(270, yCoord: yCoord, labelText: "6")
            
            
        }
    }
    
    func setLabelView(xCoord : CGFloat, yCoord : CGFloat, labelText : String) {
        var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.textAlignment = NSTextAlignment.Center
        label.center = CGPointMake(xCoord, yCoord + 15)
        label.text = labelText
        self.view.addSubview(label)
    }

    @IBAction func goBtn(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("toLoginScreen", sender: self)
        
        NSLog("Logout")
        
    }

    @IBAction func viewChanger(sender: UIButton) {
        
        switch cellViewTracker {
            case 1:
                circleView1.removeFromSuperview()
                
                var circleViewg1 = CircleView(frame: CGRectMake(25,yCoord, radius, radius))
                self.view.addSubview(circleViewg1)
                self.view.sendSubviewToBack(circleViewg1)
                votingInfoLabel.text = "remaining in cell 1 voting"
            
            case 2:
                circleView2.removeFromSuperview()
                
                var circleViewg2 = CircleView(frame: CGRectMake(72,yCoord, radius, radius))
                self.view.addSubview(circleViewg2)
                self.view.sendSubviewToBack(circleViewg2)
                votingInfoLabel.text = "remaining in cell 2 voting"
            
            case 3:
                circleView3.removeFromSuperview()
                
                var circleViewg3 = CircleView(frame: CGRectMake(120,yCoord, radius, radius))
                self.view.addSubview(circleViewg3)
                self.view.sendSubviewToBack(circleViewg3)
                votingInfoLabel.text = "remaining in cell 3 voting"
            
            case 4:
                circleView4.removeFromSuperview()
                
                var circleViewg4 = CircleView(frame: CGRectMake(165,yCoord, radius, radius))
                self.view.addSubview(circleViewg4)
                self.view.sendSubviewToBack(circleViewg4)
                votingInfoLabel.text = "remaining in cell 4 voting"
            
            case 5:
                circleView5.removeFromSuperview()
                
                var circleViewg5 = CircleView(frame: CGRectMake(210,yCoord, radius, radius))
                self.view.addSubview(circleViewg5)
                self.view.sendSubviewToBack(circleViewg5)
                votingInfoLabel.text = "remaining in cell 5 voting"
            
            case 6:
                circleView6.removeFromSuperview()
                
                var circleViewg6 = CircleView(frame: CGRectMake(255,yCoord, radius, radius))
                self.view.addSubview(circleViewg6)
                self.view.sendSubviewToBack(circleViewg6)
                votingInfoLabel.text = "remaining in cell 6 voting"
            
            default:
                NSLog("CASE")
        }
        
        cellViewTracker += 1
        
    }
    
    func updateTimerCue() {
        
        //NSLog("ddd")
        
    }
}

