//
//  InsertItemToDesk.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol CosmeticDeskDelegate {
    func onSuccess()
    func onFailed()
}

class CosmeticDesk: NSObject {
    var delegate: CosmeticDeskDelegate?
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: String = ""
    
    func insertToDesk(productId: String, userId: String){
        DB_URL = getAddress.getInsertItemToDesk()
        postParameter = "user_id=\(userId)&product_id=\(productId)"
        processing()
    }
    
    func deleteFromDesk(productId: String, userId: String) {
        DB_URL = getAddress.getDeleteItemFromDesk()
        postParameter = "user_id=\(userId)&product_id=\(productId)"
        processing()
    }
    
    private func processing(){
        
        var request = URLRequest(url: URL(string: DB_URL)!)
        request.httpMethod = "POST"
        
        if postParameter != ""{
            request.httpBody = postParameter.data(using: .utf8)
        }
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("Failed to Save or remove cosmetic")
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.onFailed()
                })
                
            }else{
                if self.DB_URL == self.getAddress.getInsertItemToDesk(){
                    print("Saved cosmetic to list!")
                }else{
                    print("Deleted cosmetic from list!")
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.onSuccess()
                })
            }
            
        }
        task.resume()
    }
}
