//
//  DownloadUser.swift
//  Cosmetic
//
//  Created by Omp on 29/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

@objc protocol DownloadUserProtocol: class {
    func itemDownloadUser(item: UserModel)
    func itemUserError(error: String)
}

class DownloadUser: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        self.parseJSON(data)
    }
    
    func downloadFailed(error: String) {
        delegate?.itemUserError(error: error)
    }
    
    var delegate: DownloadUserProtocol?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: [String: String] = [:]
    
    func getCurrentUserprofile(uid :String){
        postParameter["uid"] = uid
        downloadItem()
    }
    
    private func downloadItem(){
        DB_URL = getAddress.getUserURL()
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: postParameter)
    }
    
    @objc func parseJSON(_ data:Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let users = UserModel()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            
            if let userid = jsonElement[ConstantUser.userId] as? String,
                let firstName = jsonElement[ConstantUser.firstName] as? String,
                let lastName = jsonElement[ConstantUser.lastName] as? String,
                let nickName = jsonElement[ConstantUser.nickName] as? String,
                let email = jsonElement[ConstantUser.email] as? String,
                let profilepic = jsonElement[ConstantUser.profilepic] as? String?
            {
                users.userId = userid
                users.firstName = firstName
                users.lastName = lastName
                users.nickname = nickName
                users.email = email
                users.profilepic = profilepic
            }
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemDownloadUser(item: users)
        })
        
    }
}
