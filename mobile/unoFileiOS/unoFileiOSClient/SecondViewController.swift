//
//  SecondViewController.swift
//  unoFileiOSClient
//
//  Created by arvin zadeh on 3/19/15.
//  Copyright (c) 2015 PickledCucumbers. All rights reserved.
//

import UIKit
import MobileCoreServices

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let screenWidth  = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    var url = ""
    var code:String = ""
    var ip:String = ""
    var codeField:UITextField!
    var ipField:UITextField!
    var imageChosen = UIImage()
    var status = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var imageStatus = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var videoChosen = NSURL()
    var isVideo = false
    var isImage = false

    override func viewDidLoad() {
        
        //Adds Title Label
        var uploadLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        uploadLabel.text = "unoFile"
        uploadLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 64)
        uploadLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        uploadLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        uploadLabel.backgroundColor = UIColor(red: 112/255, green: 219/255, blue: 112/255, alpha: 1)
        uploadLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(uploadLabel)
        
        status = UILabel(frame: CGRect(x: 0, y: 350, width: screenWidth, height: 40))
        status.text = ""
        status.font = UIFont(name: "HelveticaNeue-UltraLight", size: 25)
        status.textAlignment = NSTextAlignment(rawValue: 1)!
        status.textColor = UIColor(red: 0, green: 153/255, blue: 255/255, alpha: 1)
        //status.backgroundColor = UIColor(red: 112/255, green: 219/255, blue: 112/255, alpha: 1)
        status.adjustsFontSizeToFitWidth = true
        self.view.addSubview(status)
        
        imageStatus = UILabel(frame: CGRect(x: 0, y: 200, width: screenWidth, height: 40))
        imageStatus.text = ""
        imageStatus.font = UIFont(name: "HelveticaNeue-UltraLight", size: 25)
        imageStatus.textAlignment = NSTextAlignment(rawValue: 1)!
        imageStatus.textColor = UIColor(red: 0, green: 153/255, blue: 255/255, alpha: 1)
        imageStatus.adjustsFontSizeToFitWidth = true
        self.view.addSubview(imageStatus)

        
        var uploadButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        uploadButton.frame = CGRectMake(screenWidth/2 - 100, 300, 200, 50)
        uploadButton.setTitle("Upload!", forState: UIControlState())
        uploadButton.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 255/255, alpha: 1)
        uploadButton.addTarget(self, action: "upload:", forControlEvents: UIControlEvents.TouchUpInside)
        uploadButton.setTitleColor(UIColor(red: 255, green: 255, blue: 255, alpha: 1), forState: UIControlState())
        self.view.addSubview(uploadButton)
        
        
        var pick = UIButton.buttonWithType(UIButtonType.System) as UIButton
        pick.frame = CGRectMake(screenWidth/2 - 100, 150, 200, 40)
        pick.setTitleColor(UIColor(red: 255, green: 255, blue: 255, alpha: 1), forState: UIControlState())
        pick.setTitle("Choose file", forState: UIControlState())
        pick.backgroundColor = UIColor(red: 0/255, green:       153/255, blue: 255/255, alpha: 1)
        pick.addTarget(self, action: "pickButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(pick)
        
        
        codeField = UITextField(frame: CGRect(x: screenWidth/2 - 100, y: 250, width: 200, height: 40))
        //green 70DB70
        //blue 0099FF
        codeField.placeholder = "Choose Code"
        codeField.textAlignment = NSTextAlignment(rawValue: 1)!
        codeField.backgroundColor = UIColor(red: 153, green: 153, blue: 153, alpha: 0.5)
        textFieldShouldReturn(codeField)
        self.view.addSubview(codeField)
        
        
        ipField = UITextField(frame: CGRect(x: screenWidth/2 - 100, y: 400, width: 200, height: 40))
        //green 70DB70
        //blue 0099FF
        ipField.placeholder = "URL/IP Address"
        ipField.textAlignment = NSTextAlignment(rawValue: 1)!
        ipField.backgroundColor = UIColor(red: 153, green: 153, blue: 153, alpha: 0.5)
        textFieldShouldReturn(ipField)
        self.view.addSubview(ipField)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func pickButton(sender: AnyObject) {
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(picker.sourceType)!
        self.presentViewController(picker, animated: true, completion: nil)
    }

    @IBAction func upload(sender: AnyObject) {
        var code = codeField.text.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
        ip = ipField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if (code != "" && ip != "" && imageStatus != ""){
            
            var response: NSURLResponse? = nil
            var error: NSError? = nil
            
            
            var urlExists = NSURL(string: "http://" + ip + "/exists?code=" + code + "")
            var requestExists = NSMutableURLRequest(URL: urlExists!)
            requestExists.HTTPMethod = "POST"
            let replyExists = NSURLConnection.sendSynchronousRequest(requestExists, returningResponse:&response, error:&error)
            let resultsExists = NSString(data:replyExists!, encoding:NSUTF8StringEncoding)
            println( "Exists: \(resultsExists) ")
            
            if (resultsExists == "false" && imageStatus != ""){
                
                if (isImage){
                    var imageData = UIImageJPEGRepresentation(imageChosen, 90)
                    
                    
                    var url = NSURL(string: "http://" + ip + "/upload?file=image.jpg&code=" + code + "")!
                    var request = NSMutableURLRequest(URL: url)
                    request.HTTPMethod = "POST"
                    request.HTTPBody = imageData

                    let reply =  NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
                    let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
                    println("uploaded \(results)")
                   
                    if (results == "3"){
                        status.text = "cannot use characters: \\/\"\'<>{}:%|?^+` \t"
                    }
                    else if (results == "2"){
                        status.text = "please enter a code"
                    }
                    else {
                        status.text = "uploaded " + code + ""
                        
                    }

                }
                else if (isVideo){
                    var videoData = NSData(contentsOfURL: videoChosen)
                    
                    var url = NSURL(string: "http://" + ip + "/upload?file=video.mov&code=" + code + "")!
                    var request = NSMutableURLRequest(URL: url)
                    request.HTTPMethod = "POST"
                    request.HTTPBody = videoData
                    
                    let reply =  NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
                    let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
                    println("uploaded \(results)")
                    if (results == "3"){
                        status.text = "cannot use characters: \\/\"\'<>{}:%|?^+` \t"
                    }
                    else if (results == "2"){
                        status.text = "please enter a code"
                    }
                    else {
                        status.text = "uploaded " + code + ""
                        
                    }

                }
        
            }
            else if(resultsExists == "true"){
                status.text = "already exists"
            }
            else {
                status.text = "code, URL, or file is missing"
            }

        }
        else{
            status.text = "code, URL, or file is missing"
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
       // imageChosen = info[UIImagePickerControllerOriginalImage] as UIImage!
        let  mediaType =  info[UIImagePickerControllerMediaType] as NSString
        if (mediaType.isEqualToString(kUTTypeImage as NSString)) {
            imageChosen = info[UIImagePickerControllerOriginalImage] as UIImage!
            imageStatus.text = "Image chosen"
            isImage = true
            isVideo = false
        }
        else if (mediaType.isEqualToString(kUTTypeMovie as NSString)){
            videoChosen = info[UIImagePickerControllerMediaURL] as NSURL!
            imageStatus.text = "Video chosen"
            isVideo = true
            isImage = false
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

