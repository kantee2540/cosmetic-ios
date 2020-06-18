//
//  LinkAccountTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 15/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class LinkAccountTableViewController: UITableViewController, GIDSignInDelegate {

    var LINK = "Link"
    var UNLINK = "Unlink"
    var CHANGE_PASSWORD = "Change Password"
    
    @IBOutlet weak var googleLinkButton: UIButton!
    @IBOutlet weak var facebookLinkButton: UIButton!
    @IBOutlet weak var setEmailButton: UIButton!
    private var loginManager: LoginManager!
    private var user: User!
    
    private var facebookisLinked: Bool = false
    private var googleisLinked: Bool = false
    private var emailisLinked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        
        //Google
        GIDSignIn.sharedInstance()?.delegate = self
        
        //Facebook
        loginManager = LoginManager()
        
        for provider in user.providerData{
            switch provider.providerID {
            case "facebook.com":
                facebookLinkButton.setTitle(UNLINK, for: .normal)
                facebookisLinked = true
            case "google.com":
                googleLinkButton.setTitle(UNLINK, for: .normal)
                googleisLinked = true
            case "password":
                setEmailButton.setTitle(CHANGE_PASSWORD, for: .normal)
                emailisLinked = true
            default:
                print("\(provider.providerID)")
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error{
            print(error.localizedDescription)
            return
            
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        self.user.link(with: credential, completion: {authResult, error in
            if let error = error{
                print(error)
                Library.displayAlert(targetVC: self, title: "error", message: error.localizedDescription)
                return
            }
            
            Library.displayAlert(targetVC: self, title: "Linked with Google", message: "Linked account with your Google successful! Now you can login this account from your Google")
            self.googleLinkButton.setTitle(self.UNLINK, for: .normal)
            self.googleisLinked = true
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    @IBAction func linkwithGoogle(_ sender: Any) {
        if googleisLinked{
            //Unlink Google
            let alert = UIAlertController(title: "Unlink from Google", message: "When you unlink no longer to sign in with Google from this account", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Unlink", style: .destructive, handler: {(action) -> Void in
                let providerID = GoogleAuthProviderID
                self.user.unlink(fromProvider: providerID, completion: {authResult, error in
                    if let error = error{
                        print(error)
                        Library.displayAlert(targetVC: self, title: "Error", message: error.localizedDescription)
                        return
                    }
                    
                    GIDSignIn.sharedInstance()?.signOut()
                    self.googleLinkButton.setTitle(self.LINK, for: .normal)
                    self.googleisLinked = false
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in }))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    @IBAction func linkwithFacebook(_ sender: Any) {
        
        if AccessToken.current != nil || facebookisLinked{
            let alert = UIAlertController(title: "Unlink from Facebook", message: "When you unlink no longer to sign in with Facebook from this account", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Unlink", style: .destructive, handler: {(action) -> Void in
                let providerID = FacebookAuthProviderID
                self.user?.unlink(fromProvider: providerID, completion: {user, error in
                    if let error = error{
                        Library.displayAlert(targetVC: self, title: "Error", message: error.localizedDescription)
                        return
                    }
                    self.facebookLinkButton.setTitle(self.LINK, for: .normal)
                    self.loginManager.logOut()
                    self.facebookisLinked = false
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in }))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            loginManager.logIn(permissions: ["email"], from: self){
                [weak self] (result, error) in
                guard error == nil else{
                    print(error?.localizedDescription as Any)
                    return
                }
                
                guard let result = result, !result.isCancelled else{ return }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: result.token!.tokenString)
                
                self!.user?.link(with: credential, completion: {authResult, error in
                    if let error = error{
                        print(error)
                        Library.displayAlert(targetVC: self!, title: "Error", message: error.localizedDescription)
                    }
                    Library.displayAlert(targetVC: self!, title: "Linked with Facebook", message: "Linked account with your facebook successful! Now you can login this account from your Facebook")
                    self!.facebookLinkButton.setTitle(self?.UNLINK, for: .normal)
                    self?.facebookisLinked = true
                })
                
            }
        }
    }
    @IBAction func tapLinkEmailPassword(_ sender: Any) {
        if emailisLinked{
            let vc = storyboard?.instantiateViewController(withIdentifier: "resetpassword")
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "setpassword")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}
