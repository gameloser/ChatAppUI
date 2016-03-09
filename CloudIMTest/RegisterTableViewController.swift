//
//  RegisterTableViewController.swift
//  CloudIMTest
//
//  Created by Uchiha Lulu on 16/2/16.
//  Copyright © 2016年 yingge. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController {

    @IBOutlet var MandatoryLoginField: [UITextField]!
    
    @IBOutlet var user: UITextBox!
    @IBOutlet var password: UITextBox!
    @IBOutlet var email: UITextBox!
    @IBOutlet var region: UITextBox!
    @IBOutlet var question: UITextBox!
    @IBOutlet var answer: UITextBox!
    
    var possibleInputs: Inputs = []
    
    var doneButton: UIBarButtonItem?
    
    func checkRequiredField() {
        
        for textField in MandatoryLoginField {
            if textField.text!.isEmpty {
                self.errorNotice("Mandatory field is empty")
            }
        }
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        guard predicate.evaluateWithObject(email.text) else{
            self.errorNotice("e-mail incorrect!")
            return
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false
        self.title = "Sign up"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonTap")
        
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        doneButton = self.navigationItem.rightBarButtonItem
        
        /* Check validation */
        
        // 1. Check Username
        
        let valid_userid = AJWValidator(type: .String)
        valid_userid.addValidationToEnsureMinimumLength(6, invalidMessage: "At least 6 characters")
        valid_userid.addValidationToEnsureMaximumLength(15, invalidMessage: "At most 15 characters")
        self.user.ajw_attachValidator(valid_userid)
        
        valid_userid.validatorStateChangedHandler = { (newState: AJWValidatorState) -> Void in
            switch newState {
                
            case .ValidationStateValid:
                self.user.highlightState = UITextBoxHighlightState.Default
                self.possibleInputs.unionInPlace(Inputs.username)
            default:
                let errorMsg = valid_userid.errorMessages.first as? String
                self.user.highlightState = UITextBoxHighlightState.Wrong(errorMsg!)
                self.possibleInputs.subtractInPlace(Inputs.username)
            }
            
            self.doneButton?.enabled = self.possibleInputs.boolValue
        }
        
        // 2. Check Passwords
        
        let valid_password = AJWValidator(type: .String)
        valid_password.addValidationToEnsureMinimumLength(6, invalidMessage: "At least 6 characters")
        valid_password.addValidationToEnsureMaximumLength(15, invalidMessage: "At most 15 characters")
        self.password.ajw_attachValidator(valid_password)
        
        valid_password.validatorStateChangedHandler = { (newState: AJWValidatorState) -> Void in
            switch newState {
                
            case .ValidationStateValid:
                self.password.highlightState = UITextBoxHighlightState.Default
                self.possibleInputs.unionInPlace(Inputs.password)
            default:
                let errorMsg = valid_password.errorMessages.first as? String
                self.password.highlightState = UITextBoxHighlightState.Wrong(errorMsg!)
                self.possibleInputs.subtractInPlace(Inputs.password)
            }
            
            self.doneButton?.enabled = self.possibleInputs.boolValue
        }
        
        // 3. Check e-mail
        
        let valid_email = AJWValidator(type: .String)
        valid_email.addValidationToEnsureValidEmailWithInvalidMessage("Incorrect e-mail format")
        self.email.ajw_attachValidator(valid_email)
        
        valid_email.validatorStateChangedHandler = { (newState: AJWValidatorState) -> Void in
            switch newState {
                
            case .ValidationStateValid:
                self.email.highlightState = UITextBoxHighlightState.Default
                self.possibleInputs.unionInPlace(Inputs.email)
            default:
                let errorMsg = valid_email.errorMessages.first as? String
                self.email.highlightState = UITextBoxHighlightState.Wrong(errorMsg!)
                self.possibleInputs.subtractInPlace(Inputs.email)
            }
            
            self.doneButton?.enabled = self.possibleInputs.boolValue
        }
        
    }
    
    // sign-up
    func doneButtonTap() {
        
        //loading
        self.pleaseWait()
        
        //new avobject
        let user = AVObject(className: "ZUser")
        
        //set value from textbox
        user["user"] = self.user.text
        user["password"] = self.password.text
        user["email"] = self.email.text
        user["region"] = self.region.text
        user["question"] = self.question.text
        user["answer"] = self.answer.text
        
        //query if this user has been registerd
        let query = AVQuery(className: "ZUser")
        query.whereKey("user", equalTo: self.user.text)
        
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            
            self.clearAllNotice()
            
            if object != nil {
                
                self.errorNotice("用户已注册")
                self.user.becomeFirstResponder()
                self.doneButton?.enabled = false
                
            } else {
                
                //sign-up
                user.saveInBackgroundWithBlock({ (succeed, error) -> Void in
                    
                    if succeed {
                        self.successNotice("注册成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        self.errorNotice(error.localizedDescription)
                    }
                })
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
