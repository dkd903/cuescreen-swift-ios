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
    @IBOutlet weak var votingOver: UILabel!
    
    @IBOutlet weak var voteBtn1: UIButton!
    @IBOutlet weak var voteBtn2: UIButton!
    @IBOutlet weak var voteBtn3: UIButton!
    @IBOutlet weak var voteBtn4: UIButton!
    @IBOutlet weak var voteBtn5: UIButton!
    @IBOutlet weak var voteBtn6: UIButton!
    
    var circleView1 = CircleView(frame: CGRectMake(0,0, 0, 0))
    var circleView2 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    var circleView3 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    var circleView4 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    var circleView5 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    var circleView6 = CircleViewGrey(frame: CGRectMake(0,0, 0, 0))
    
    var checkedImage: UIImage = UIImage(named: "checkedButton.jpeg")!
    var uncheckedImage: UIImage = UIImage(named: "normalButton.jpeg")!
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //which cell number to show for the voting
    var cellViewTracker = 1
    var cellDuration = 10
    var cellDurationTracker = 0
    
    var timer : NSTimer!
    var cellDetectTimer : NSTimer!
    
    var showVotingBlockScreen = 1
    
    let radius : CGFloat = 30
    let yCoord : CGFloat = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rgbValue = 0xF7FAF1
        let r = Float((rgbValue & 0xFF0000) >> 16)/255.0
        let g = Float((rgbValue & 0xFF00) >> 8)/255.0
        let b = Float((rgbValue & 0xFF))/255.0
        var color: UIColor = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(1.0))
        self.view.backgroundColor = color
        
        self.voteBtn1.setImage(checkedImage, forState:UIControlState.Selected)
        self.voteBtn1.setImage(uncheckedImage, forState:UIControlState.Normal)
        self.voteBtn2.setImage(checkedImage, forState:UIControlState.Selected)
        self.voteBtn2.setImage(uncheckedImage, forState:UIControlState.Normal)
        self.voteBtn3.setImage(checkedImage, forState:UIControlState.Selected)
        self.voteBtn3.setImage(uncheckedImage, forState:UIControlState.Normal)
        self.voteBtn4.setImage(checkedImage, forState:UIControlState.Selected)
        self.voteBtn4.setImage(uncheckedImage, forState:UIControlState.Normal)
        self.voteBtn5.setImage(checkedImage, forState:UIControlState.Selected)
        self.voteBtn5.setImage(uncheckedImage, forState:UIControlState.Normal)
        self.voteBtn6.setImage(checkedImage, forState:UIControlState.Selected)
        self.voteBtn6.setImage(uncheckedImage, forState:UIControlState.Normal)
        
        self.timerLabel.text = "00:" + String(self.cellDuration)
        
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
            
            //check if voting is allowed
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("isVotingPermitted"), userInfo: nil, repeats: true)
            
            ViewControllerUtils().showActivityIndicator(self.view, container: container, loadingView: loadingView, activityIndicator: activityIndicator)
            
            //self.userName.text = prefs.valueForKey("USERNAME") as NSString
            
            circleView1 = CircleView(frame: CGRectMake(25,yCoord, radius, radius))
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
        
    }
    
    func isVotingPermitted() {
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://rewar.ds/cmapi/isvotingallowed.php")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var userId = prefs.valueForKey("USERID") as NSString
        var params = ["userDevice":"iOS", "userId":userId] as Dictionary<String, String>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            //println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                //NSLog("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var isVotingEnabled = parseJSON["voting"] as? String
                    var nextCell = parseJSON["cellNumber"] as? String
                    NSLog("cellViewTracker: \(self.cellViewTracker)")
                    NSLog("nextCell: \(nextCell)")
                    if (isVotingEnabled == "yes" && String(self.cellViewTracker) == nextCell) {
                        if (self.showVotingBlockScreen == 0) {
                            
                        } else {

                            self.showVotingBlockScreen = 0
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Show the alert
                                //alert.show()
                                self.votingWaitLabel.hidden = true
                                
                                ViewControllerUtils().hideActivityIndicator(self.view, container: self.container, loadingView: self.loadingView, activityIndicator: self.activityIndicator)
                                
                                //self.timer.invalidate()
                                
                                self.cellDetectTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("votingStarted"), userInfo: nil, repeats: true)
                                
                            })
                            
                            //var cellNumber = parseJSON["cellNumber"] as? String
                            //self.cellViewTracker = cellNumber.toInt()
                            
                        }
                    } else {
                        if (self.showVotingBlockScreen == 0) {
                            self.showVotingBlockScreen = 1
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Show the alert
                                //alert.show()
                                self.votingWaitLabel.hidden = false
                                ViewControllerUtils().showActivityIndicator(self.view, container: self.container, loadingView: self.loadingView, activityIndicator: self.activityIndicator)
                                
                            })
                            
                        } else {
                            
                        }
                    }
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    //NSLog("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
        
    }
    
    func votingStarted() {
        
        if (self.cellDurationTracker < cellDuration) {
            self.cellDurationTracker += 1
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                var separa = (self.cellDuration - self.cellDurationTracker < 10) ? "00:0" : "00:"
                self.timerLabel.text = separa + String(self.cellDuration - self.cellDurationTracker)
                
            })
            
            
        } else if (self.cellDurationTracker == cellDuration) {
            self.cellDurationTracker = 0
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.timerLabel.text = "00:" + String(self.cellDuration - self.cellDurationTracker)
                
            })
            
            self.updateVoteUIElements()
            self.resetVotes()
            
            self.cellDetectTimer.invalidate()
            ViewControllerUtils().showActivityIndicator(self.view, container: container, loadingView: loadingView, activityIndicator: activityIndicator)
            
        }
        
        
    }
    
    @IBAction func voteBtn1Clicked(sender: UIButton) {
        self.voteBtn1.selected = !self.voteBtn1.selected
        self.voteBtn1.userInteractionEnabled = false
        self.postVote(1)
    }
    
    @IBAction func voteBtn2Clicked(sender: UIButton) {
        self.voteBtn2.selected = !self.voteBtn2.selected
        self.voteBtn2.userInteractionEnabled = false
        self.postVote(2)
    }
    
    @IBAction func voteBtn3Clicked(sender: UIButton) {
        self.voteBtn3.selected = !self.voteBtn3.selected
        self.voteBtn3.userInteractionEnabled = false
        self.postVote(3)
    }
    
    @IBAction func voteBtn4Clicked(sender: UIButton) {
        self.voteBtn4.selected = !self.voteBtn4.selected
        self.voteBtn4.userInteractionEnabled = false
        self.postVote(4)
    }
    
    @IBAction func voteBtn5Clicked(sender: UIButton) {
        self.voteBtn5.selected = !self.voteBtn5.selected
        self.voteBtn5.userInteractionEnabled = false
        self.postVote(5)
    }
    
    @IBAction func voteBtn6Clicked(sender: UIButton) {
        self.voteBtn6.selected = !self.voteBtn6.selected
        self.voteBtn6.userInteractionEnabled = false
        self.postVote(6)
    }
    
    func postVote(musicianId: Int) {
        var request = NSMutableURLRequest(URL: NSURL(string: "https://luxojr.cs.rit.edu:9000/soundExchange/sendVotes")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var userId = prefs.valueForKey("USERID") as NSString
        var params = ["userId":userId, "musicianId":String(musicianId), "sessionId":"1"] as Dictionary<String, String>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            //println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                NSLog("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                if let parseJSON = json {
                    var success = parseJSON["status"] as? String
                    NSLog("Succes: \(success)")
                    
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    NSLog("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }
    
    func resetVotes() {
        self.voteBtn1.selected = false
        self.voteBtn1.userInteractionEnabled = true
        self.voteBtn2.selected = false
        self.voteBtn2.userInteractionEnabled = true
        self.voteBtn3.selected = false
        self.voteBtn3.userInteractionEnabled = true
        self.voteBtn4.selected = false
        self.voteBtn4.userInteractionEnabled = true
        self.voteBtn5.selected = false
        self.voteBtn5.userInteractionEnabled = true
        self.voteBtn6.selected = false
        self.voteBtn6.userInteractionEnabled = true
    }
    
    func updateVoteUIElements() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            switch self.cellViewTracker {
                
            case 2:
                self.circleView2.removeFromSuperview()
                
                var circleViewg2 = CircleView(frame: CGRectMake(72,self.yCoord, self.radius, self.radius))
                self.view.addSubview(circleViewg2)
                self.view.sendSubviewToBack(circleViewg2)
                self.votingInfoLabel.text = "remaining in cell 2 voting"
                
            case 3:
                self.circleView3.removeFromSuperview()
                
                var circleViewg3 = CircleView(frame: CGRectMake(120,self.yCoord, self.radius, self.radius))
                self.view.addSubview(circleViewg3)
                self.view.sendSubviewToBack(circleViewg3)
                self.votingInfoLabel.text = "remaining in cell 3 voting"
                
            case 4:
                self.circleView4.removeFromSuperview()
                
                var circleViewg4 = CircleView(frame: CGRectMake(165,self.yCoord, self.radius, self.radius))
                self.view.addSubview(circleViewg4)
                self.view.sendSubviewToBack(circleViewg4)
                self.votingInfoLabel.text = "remaining in cell 4 voting"
                
            case 5:
                self.circleView5.removeFromSuperview()
                
                var circleViewg5 = CircleView(frame: CGRectMake(210,self.yCoord, self.radius, self.radius))
                self.view.addSubview(circleViewg5)
                self.view.sendSubviewToBack(circleViewg5)
                self.votingInfoLabel.text = "remaining in cell 5 voting"
                
            case 6:
                self.circleView6.removeFromSuperview()
                
                var circleViewg6 = CircleView(frame: CGRectMake(255,self.yCoord, self.radius, self.radius))
                self.view.addSubview(circleViewg6)
                self.view.sendSubviewToBack(circleViewg6)
                self.votingInfoLabel.text = "remaining in cell 6 voting"
                
            default:
                NSLog("CASE")
                self.cellDetectTimer.invalidate()
                self.votingOver.hidden = false
                self.timerLabel.text = "00:00"
            }
            
        })
        
        self.cellViewTracker += 1
    }
    
}

