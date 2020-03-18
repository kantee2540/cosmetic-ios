//
//  InsertItemToDesk.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import AFNetworking

protocol CosmeticDeskDelegate {
    func onSuccess()
    func onFailed()
}

class CosmeticDesk: NSObject {
    var delegate: CosmeticDeskDelegate?
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: [String: String] = [:]
    
    func insertToDesk(productId: String, userId: String){
        DB_URL = getAddress.getInsertItemToDesk()
        postParameter = ["user_id": userId, "product_id": productId]
        processing()
    }
    
    func deleteFromDesk(productId: String, userId: String) {
        DB_URL = getAddress.getDeleteItemFromDesk()
        postParameter = ["user_id" : userId, "product_id": productId]
        processing()
    }
    
    private func processing(){
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        manager.post(DB_URL, parameters: postParameter, success: {
            (operation: AFHTTPRequestOperation, responseObject: Any) in
            if self.DB_URL == self.getAddress.getInsertItemToDesk(){
                print("Saved cosmetic to list!")
            }else{
                print("Deleted cosmetic from list!")
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate?.onSuccess()
            })
            
        }, failure: {
            (opefation: AFHTTPRequestOperation?, error: Error) in
            print("Error = \(error)")
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate?.onFailed()
            })
        })
    }
}
