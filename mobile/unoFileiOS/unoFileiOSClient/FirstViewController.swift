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
        url = "http://" + ip + "/f/" + code + ""
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

