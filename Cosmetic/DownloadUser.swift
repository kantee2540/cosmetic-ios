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
}

class DownloadUser: NSObject {
    var delegate: DownloadUserProtocol?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: String = ""
    
    func getCurrentUserprofile(uid :String){
        postParameter = "uid=\(uid)"
        downloadItem()
    }
    
    private func downloadItem(){
        DB_URL = getAddress.getUserURL()
        
        //Get data from database
        var request = URLRequest(url: URL(string: DB_URL)!)
        request.httpMethod = "POST"
        
        if postParameter != ""{
            request.httpBody = postParameter.data(using: .utf8)
        }
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("Failed to Download data")
                
            }else{
                print("Data downloaded - users")
                self.parseJSON(data!)
            }
            
        }
        task.resume()
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
                let gender = jsonElement[ConstantUser.gender] as? String,
                let birthday = jsonElement[ConstantUser.birthday] as? String
            {
                users.userId = userid
                users.firstName = firstName
                users.lastName = lastName
                users.nickname = nickName
                users.email = email
                users.gender = gender
                users.birthday = birthday
            }
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemDownloadUser(item: users)
        })
        
    }
}
