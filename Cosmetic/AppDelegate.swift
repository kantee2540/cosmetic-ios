//
//  AppDelegate.swift
//  Cosmetic
//
//  Created by Omp on 22/3/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, DownloadUserProtocol{
    
    var window: UIWindow?
    
    //MARK: - Sign in with Google
    func itemDownloadUser(item: UserModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = window?.rootViewController as? UINavigationController
        
        if item.firstName != nil{
            UserDefaults.standard.set(item.userId ?? nil, forKey: ConstantUser.userId)
            UserDefaults.standard.set(item.firstName ?? nil, forKey: ConstantUser.firstName)
            UserDefaults.standard.set(item.lastName ?? nil, forKey: ConstantUser.lastName)
            UserDefaults.standard.set(item.nickname ?? nil, forKey: ConstantUser.nickName)
            UserDefaults.standard.set(item.email ?? nil, forKey: ConstantUser.email)
            UserDefaults.standard.set(item.gender ?? nil, forKey: ConstantUser.gender)
            UserDefaults.standard.set(item.birthday ?? nil, forKey: ConstantUser.birthday)
            UserDefaults.standard.set(item.profilepic ?? "", forKey: ConstantUser.profilepic)
            nav?.popToRootViewController(animated: true)
        }else{
            let vc = storyboard.instantiateViewController(withIdentifier: "profile")
            nav?.pushViewController(vc, animated: true)
        }
    }
    
    func itemUserError(error: String) {
        let nav = window?.rootViewController as? UINavigationController
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            nav?.popToRootViewController(animated: true)
        }))
        nav!.present(alert, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let nav = window?.rootViewController as? UINavigationController
        if let error = error{
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential){
            (authResult, error) in
            if let error = error{
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                    nav?.popToRootViewController(animated: true)
                }))
                nav!.present(alert, animated: true, completion: nil)
            }
            
            let downloadUser = DownloadUser()
            downloadUser.delegate = self
            downloadUser.getCurrentUserprofile(uid: (authResult?.user.uid)!)
        }
        
    }

    //MARK: - Application has start
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        if let url = launchOptions?[.url] as? URL{
            print(url)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.hom
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Tapic touch shortcut
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        //3DTouch Shortcut
        if shortcutItem.type == "cameraAction" {
            guard let navC = window?.rootViewController as? UINavigationController else { return }
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "cameraViewController")
            navC.present(vc, animated: true, completion: nil)
        }
       
    }
    
    //MARK: - Deep link feature
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let nav = window?.rootViewController as? UINavigationController
        
        if url.host == "cosmetic"{
            var param: [String: String] = [:]
            
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach{
                param[$0.name] = $0.value
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "productdetail") as? CosmeticDetailViewController
            vc?.productId = param["id"]
            nav?.present(vc!, animated: true, completion: nil)
            
        }else if url.host == "topic"{
            var param: [String: String] = [:]
            
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach{
                param[$0.name] = $0.value
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TopTopic") as? TopTopicViewController
            vc?.topicId = param["id"]
            nav?.present(vc!, animated: true, completion: nil)
            
        }
        return (GIDSignIn.sharedInstance()?.handle(url))!
    }

}

