//
//  CollectUserdata.swift
//  Cosmetic
//
//  Created by Omp on 29/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

protocol CollectUserdataDelegate {
    func insertDataSuccess()
    func insertDataFailed()
}

class CollectUserdata: NSObject {
    
    var delegate: CollectUserdataDelegate?
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: String = ""
    
    func collectUserdata(firstname: String, lastName: String, nickname: String, email: String, gender: String, birthday: String, uid: String){
        print("Insert")
        postParameter = "first_name=\(firstname)&" +
        "last_name=\(lastName)&" +
        "nick_name=\(nickname)&" +
        "email=\(email)&" +
        "gender=\(gender)&" +
        "birthday=\(birthday)&" +
        "uid=\(uid)&" +
        "option=0"
        print(postParameter)
        insertData()
    }
    
    func updateUserdata(firstname: String, lastName: String, nickname: String, email: String, gender: String, birthday: String, uid: String){
        print("Update")
        postParameter = "first_name=\(firstname)&" +
        "last_name=\(lastName)&" +
        "nick_name=\(nickname)&" +
        "email=\(email)&" +
        "gender=\(gender)&" +
        "birthday=\(birthday)&" +
        "uid=\(uid)&" +
        "option=1"
        insertData()
    }
    
    func insertData(){
        DB_URL = getAddress.getCollectUserdata()
        var request = URLRequest(url: URL(string: DB_URL)!)
        request.httpMethod = "POST"
        
        if postParameter != ""{
            request.httpBody = postParameter.data(using: .utf8)
        }
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("Failed to Download data")
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.insertDataFailed()
                })
                
            }else{
                print("Inserted user data")
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.insertDataSuccess()
                })
            }
            
        }
        task.resume()
    }
}
