//
//  LoginVC.swift
//  CueScreen
//
//  Created by Debjit Saha on 11/19/14.
//  Copyright (c) 2014 com.cuescreen.app. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userEmailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rgbValue = 0xF7FAF1
        let r = Float((rgbValue & 0xFF0000) >> 16)/255.0
        let g = Float((rgbValue & 0xFF00) >> 8)/255.0
        let b = Float((rgbValue & 0xFF))/255.0
        var color: UIColor = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(1.0))
        self.view.backgroundColor = color
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (userNameField.canBecomeFirstResponder()) {
            userNameField.becomeFirstResponder()
        }
        
    }

    @IBAction func goBtnClicked(sender: UIButton) {
        
        var username:NSString = userNameField.text
        var email:NSString = userEmailField.text
        
        if ( username.isEqualToString("") || email.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and E-Mail"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else {
            
            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setObject(email, forKey: "USERNAME")
            prefs.setInteger(1, forKey: "ISLOGGEDIN")
            prefs.synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
            
            var request = NSMutableURLRequest(URL: NSURL(string: "http://rewar.ds/cmapi/login.php")!)
            var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            var params = ["userDevice":"iOS", "userInfo":email] as Dictionary<String, String>
            
            var err: NSError?
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                println("Response: \(response)")
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Body: \(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                
                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                if(err != nil) {
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    NSLog("Error could not parse JSON: '\(jsonStr)'")
                }
                else {
                    // The JSONObjectWithData constructor didn't return an error. But, we should still
                    // check and make sure that json has a value using optional binding.
                    if let parseJSON = json {
                        // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                        var success = parseJSON["userId"] as? String
                        prefs.setObject(success, forKey: "USERID")
                        NSLog("Succes: \(success)")
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        NSLog("Error could not parse JSON: \(jsonStr)")
                    }
                }
            })
            
            task.resume()
            
        }
        
    }
}
