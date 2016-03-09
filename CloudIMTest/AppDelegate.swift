//
//  AppDelegate.swift
//  CloudIMTest
//
//  Created by Uchiha Lulu on 15/12/24.
//  Copyright © 2015年 yingge. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RCIMUserInfoDataSource {

    var window: UIWindow?
    
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        
        let userInfo = RCUserInfo()
        userInfo.userId = userId
        
        switch userId {
            case "yingge3":
                userInfo.name = "Ted"
                userInfo.portraitUri = "http://b.hiphotos.baidu.com/shitu/pic/item/7aec54e736d12f2e8858d14848c2d562853568bc.jpg"
            case "yingge":
                userInfo.name = "Jerry"
                userInfo.portraitUri = "http://b.hiphotos.baidu.com/shitu/pic/item/728da9773912b31b7105b9008118367adab4e1aa.jpg"
            case "lulu":
                userInfo.name = "Mike"
                userInfo.portraitUri = "http://h.hiphotos.baidu.com/image/pic/item/b03533fa828ba61ef756b6064634970a304e595a.jpg"
            default:
                print("No user")
        }
        
        
        return completion(userInfo)
    }
    
    func connectServer(completion:()->Void) {
        
        //search the token saved
        NSUserDefaults.standardUserDefaults().objectForKey("kDeviceToken") as? String
        
        //initialize appkey
        RCIM.sharedRCIM().initWithAppKey("cpj2xarljgwpn")
        
        //use token to test connection
        RCIM.sharedRCIM().connectWithToken("yHoqTZAJn0UdaIMqOQ2Lx8qUpVFZdXMhsmpCZP+5KZGk2ut4icmznQB+5Gzu4uyYi/h9utxPRulzN6ZNkz1Vrw==", success: { (_) -> Void in
            
            
            //let currentUser = RCUserInfo(userId: "yingge3", name: "Ted", portrait:nil)
            let currentUser = RCUserInfo(userId: "lulu", name: "Mike", portrait:"http://h.hiphotos.baidu.com/image/pic/item/b03533fa828ba61ef756b6064634970a304e595a.jpg")
            RCIMClient.sharedRCIMClient().currentUserInfo = currentUser
            
            print("connection success")
            
            //asynchronized execution
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion()
            })
            
            
            }, error: { (code:RCConnectErrorCode) -> Void in
                print("connection failed !\(code)")
            }) { () -> Void in
                print("invalid token!")
        }


    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //set user info provider is self /AppDelegate
        RCIM.sharedRCIM().userInfoDataSource = self
        
        //get LeanCloud authorization
        AVOSCloud.setApplicationId("SsWSqs3P89F7NESRr5qNFp2N-gzGzoHsz", clientKey: "irufbmCaEcSCCahGpSC0HVpm")
        
        //American site:
        //[AVOSCloud useAVCloudUS]
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

