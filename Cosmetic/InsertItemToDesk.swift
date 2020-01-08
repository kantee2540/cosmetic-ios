//
//  InsertItemToDesk.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol InsertItemToDeskDelegate {
    func insertDataSuccess()
    func insertDataFailed()
}

class InsertItemToDesk: NSObject {
    var delegate: InsertItemToDeskDelegate?
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: String = ""
    
    func insertToDesk(productId: String, userId: String){
        postParameter = "user_id=\(userId)&product_id=\(productId)"
        insertData()
    }
    
    private func insertData(){
        DB_URL = getAddress.getInsertItemToDesk()
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
