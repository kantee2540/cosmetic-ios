//
//  CollectUserdata.swift
//  Cosmetic
//
//  Created by Omp on 29/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import AFNetworking

protocol CollectUserdataDelegate {
    func insertDataSuccess()
    func insertDataFailed()
}

class CollectUserdata: NSObject {
    
    var delegate: CollectUserdataDelegate?
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: [String: Any] = [:]
    
    func collectUserdata(firstname: String, lastName: String, nickname: String, email: String, gender: String, birthday: String, uid: String){
        print("Insert")
        postParameter = ["first_name" : firstname,
                         "last_name" : lastName,
                         "nick_name" : nickname,
                         "email" : email,
                         "gender" : gender,
                         "birthday" : birthday,
                         "uid" : uid,
                         "option" : 0]
        insertData()
    }
    
    func updateUserdata(firstname: String, lastName: String, nickname: String, email: String, gender: String, birthday: String, uid: String){
        print("Update")
        postParameter = ["first_name" : firstname,
                         "last_name" : lastName,
                         "nick_name" : nickname,
                         "email" : email,
                         "gender" : gender,
                         "birthday" : birthday,
                         "uid" : uid,
                         "option" : 1]
        insertData()
    }
    
    func insertData(){
        DB_URL = getAddress.getCollectUserdata()
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        manager.post(DB_URL, parameters: postParameter, success: {
            (operation: AFHTTPRequestOperation, responseObject: Any) in
            print("Inserted Product")
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate?.insertDataSuccess()
            })
        }, failure: {
            (opefation: AFHTTPRequestOperation?, error: Error) in
            print("Error = \(error)")
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate?.insertDataFailed()
            })
            
        })
    }
}
