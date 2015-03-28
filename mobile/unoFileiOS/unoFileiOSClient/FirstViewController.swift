//
//  FirstViewController.swift
//  unoFileiOSClient
//
//  Created by arvin zadeh on 3/19/15.
//  Copyright (c) 2015 PickledCucumbers. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    let screenWidth  = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    var url = ""
    var code:String = ""
    var ip:String = ""
    var codeField:UITextField!
    var ipField:UITextField!
    var codeExists = false
    var status = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    override func viewDidLoad() {
        
        //Adds Title Label
        var downloadLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        downloadLabel.text = "unoFile"
        downloadLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 64)
        downloadLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        downloadLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        downloadLabel.backgroundColor = UIColor(red: 112/255, green: 219/255, blue: 112/255, alpha: 1)
        downloadLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(downloadLabel)
        
        //Adds Text Box for Download Code
        codeField = UITextField(frame: CGRect(x: screenWidth/2 - 100, y: 150, width: 200, height: 40))
        //green 70DB70
        //blue 0099FF
        codeField.placeholder = "Enter Code"
        codeField.textAlignment = NSTextAlignment(rawValue: 1)!
        codeField.backgroundColor = UIColor(red: 153, green: 153, blue: 153, alpha: 0.5)
        textFieldShouldReturn(codeField)
        self.view.addSubview(codeField)
        
        
        status = UILabel(frame: CGRect(x: 0, y: 250, width: screenWidth, height: 40))
        status.text = ""
        status.font = UIFont(name: "HelveticaNeue-UltraLight", size: 25)
        status.textAlignment = NSTextAlignment(rawValue: 1)!
        status.textColor = UIColor(red: 0, green: 153/255, blue: 255/255, alpha: 1)
        //status.backgroundColor = UIColor(red: 112/255, green: 219/255, blue: 112/255, alpha: 1)
        status.adjustsFontSizeToFitWidth = true
        self.view.addSubview(status)
        
        //Adds IP Address Field
        ipField = UITextField(frame: CGRect(x: screenWidth/2 - 100, y: 300, width: 200, height: 40))
        //green 70DB70
        //blue 0099FF
        ipField.placeholder = "URL/IP Address"
        ipField.textAlignment = NSTextAlignment(rawValue: 1)!
        ipField.backgroundColor = UIColor(red: 153, green: 153, blue: 153, alpha: 0.5)
        textFieldShouldReturn(ipField)
        self.view.addSubview(ipField)
        
        //Adds Download Button
        var downloadButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        downloadButton.frame = CGRectMake(screenWidth/2 - 100, 200, 200, 50)
        downloadButton.setTitle("Download!", forState: UIControlState())
        downloadButton.backgroundColor = UIColor(red: 0/255, green:       153/255, blue: 255/255, alpha: 1)
        downloadButton.addTarget(self, action: "downloadButton:", forControlEvents: UIControlEvents.TouchUpInside)
        downloadButton.setTitleColor(UIColor(red: 255, green: 255, blue: 255, alpha: 1), forState: UIControlState())
        self.view.addSubview(downloadButton)
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func MainTimer(){
        
    }
    
   func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func downloadButton(sender: AnyObject) {
        code = codeField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        ip = ipField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var response: NSURLResponse? = nil
        var error: NSError? = nil
        var urlExistsU = NSURL(string: "http://" + ip + "/ping")
        var requestExistsU = NSMutableURLRequest(URL: urlExistsU!)
        requestExistsU.HTTPMethod = "POST"
        let replyExistsU = NSURLConnection.sendSynchronousRequest(requestExistsU, returningResponse:&response, error:&error)
        let resultsExistsU = NSString(data:replyExistsU!, encoding:NSUTF8StringEncoding)
        println( "Exists: \(resultsExistsU) ")
        
        if (resultsExistsU == "pong"){
            if (code != "" && ip != ""){
                var response: NSURLResponse? = nil
                var error: NSError? = nil
                var urlExists = NSURL(string: "http://" + ip + "/exists?code=" + code + "")
                var requestExists = NSMutableURLRequest(URL: urlExists!)
                requestExists.HTTPMethod = "POST"
                let replyExists = NSURLConnection.sendSynchronousRequest(requestExists, returningResponse:&response, error:&error)
                let resultsExists = NSString(data:replyExists!, encoding:NSUTF8StringEncoding)
                println( "Exists: \(resultsExists) ")
                
                if (resultsExists == "true"){
                    url = "http://" + ip + "/f/" + code + ""
                    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                }
                else {
                    status.text = "file doesn't exist"
                }
            }
            else {
                status.text = "code or URL is missing"
            }
        }
        else {
            status.text = "server does not exist"
        }
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

