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

class CollectUserdata: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.insertDataSuccess()
        })
    }
    
    func downloadFailed(error: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.insertDataFailed()
        })
    }
    
    
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
        
        let network = Network()
        network.delegate = self
        network.downloadData(URL: DB_URL, param: postParameter)
    }
}
