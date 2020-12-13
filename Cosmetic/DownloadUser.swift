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
        network.post(URL: DB_URL, param: postParameter, header: nil)
    }
    
    @objc func parseJSON(_ data:Data){
        
        do{
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
            let user = UserModel()
            user.firstName = jsonResult[ConstantUser.firstName] as? String
            user.lastName = jsonResult[ConstantUser.lastName] as? String
            user.email = jsonResult[ConstantUser.email] as? String
            user.nickname = jsonResult[ConstantUser.nickName] as? String
            user.profilepic = jsonResult[ConstantUser.profilepic] as? String
            UserDefaults.standard.set(jsonResult[ConstantUser.uid] as? String, forKey: ConstantUser.uid)
            
            self.delegate?.itemDownloadUser(item: user)
            
        }catch let error as NSError{
            print(error)
        }
        
    }
}
