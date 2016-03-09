//
//  LoginViewController.swift
//  CloudIMTest
//
//  Created by Uchiha Lulu on 16/2/15.
//  Copyright © 2016年 yingge. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, JSAnimatedImagesViewDataSource {
    
    @IBOutlet var user: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var WallPaperImageView: JSAnimatedImagesView!
    
    @IBAction func LoginButton(sender: AnyObject) {
        loginButtonPressed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.WallPaperImageView.dataSource = self
        
        self.navigationController?.navigationBarHidden = true
    }
    
    func animatedImagesNumberOfImages(animatedImagesView: JSAnimatedImagesView!) -> UInt {
        return 4
    }
    
    func animatedImagesView(animatedImagesView: JSAnimatedImagesView!, imageAtIndex index: UInt) -> UIImage! {
        return UIImage(named: "bg\(index + 1)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginButtonPressed() {
        
        //loading
        self.pleaseWait()
        
        //new avobject
        let user = AVObject(className: "ZUser")
        
        //set data from textbox
        user["user"] = self.user.text
        user["password"] = self.password.text
        
        //query if has been registered
        let query = AVQuery(className: "ZUser")
        query.whereKey("user", equalTo: self.user.text)
        query.whereKey("password", equalTo: self.password.text)
        
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            
            self.clearAllNotice()
            
            if object != nil {
                
                //manually change view controller
                self.pleaseWait()
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let barController = sb.instantiateViewControllerWithIdentifier("UITabBarController-fs4-Z5-0Tn")
                self.presentViewController(barController, animated: true, completion: nil)
                
                self.clearAllNotice()
                
            } else {
                
                //No such user
                self.errorNotice("Invalid ID")
                
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
