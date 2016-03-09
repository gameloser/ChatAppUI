//
//  ConversationListViewController.swift
//  CloudIMTest
//
//  Created by Uchiha Lulu on 15/12/25.
//  Copyright © 2015年 yingge. All rights reserved.
//

import UIKit

class ConversationListViewController: RCConversationListViewController {

    @IBAction func showMemu(sender: AnyObject) {
        
        //popMenu
        let items = [
            MenuItem(title: "Server", iconName: "017", glowColor: UIColor.redColor(), index: 0),
            MenuItem(title: "Chat with Jerry", iconName: "chat2", glowColor: UIColor.blueColor(), index: 1),
            MenuItem(title: "Friends", iconName: "users", glowColor: UIColor.yellowColor(), index: 2),
            MenuItem(title: "About", iconName: "025", glowColor: UIColor.grayColor(), index: 3)
        ]
        
        let menu = PopMenu(frame: self.view.bounds, items: items)
        
        menu.menuAnimationType = .Sina
        
        if menu.isShowed {
            return
        }
        
        menu.didSelectedItemCompletion = { (selectedItem:MenuItem!) -> Void in
            
            switch selectedItem.index{
            case 1:
                self.ClickMenu2()
            default:
                print(selectedItem.title)
            }
            
        }
        
        menu.showMenuAtView(self.view)
        
    }
    
    func ClickMenu1() {
        print("chat with server")
    }
    
    func ClickMenu2() {
        
        //jump to conversation page
        let conVC = RCConversationViewController()

        conVC.targetId = "yingge"
        conVC.conversationType = RCConversationType.ConversationType_PRIVATE
        conVC.title = "Jerry"

        self.navigationController?.pushViewController(conVC, animated: true)
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    let conVC = RCConversationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        appDelegate?.connectServer({ () -> Void in
            self.setDisplayConversationTypes([
                RCConversationType.ConversationType_APPSERVICE.rawValue,
                RCConversationType.ConversationType_CHATROOM.rawValue,
                RCConversationType.ConversationType_CUSTOMERSERVICE.rawValue,
                RCConversationType.ConversationType_DISCUSSION.rawValue,
                RCConversationType.ConversationType_GROUP.rawValue,
                RCConversationType.ConversationType_PRIVATE.rawValue,
                RCConversationType.ConversationType_PUSHSERVICE.rawValue,
                RCConversationType.ConversationType_SYSTEM.rawValue
                
                ])
            self.refreshConversationTableViewIfNeeded()
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destVC = segue.destinationViewController as? RCConversationViewController
        
        destVC?.targetId = self.conVC.targetId
        destVC?.conversationType = self.conVC.conversationType
        destVC?.title = conVC.title
        
        
        
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        
        conVC.targetId = model.targetId
        conVC.conversationType = RCConversationType.ConversationType_PRIVATE
        conVC.title = model.conversationTitle
        self.performSegueWithIdentifier("tapOnCell", sender: self)
    }
    

}
