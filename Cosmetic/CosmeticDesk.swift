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

class CosmeticDesk: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.onSuccess()
        })
    }
    
    func downloadFailed(error: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.onFailed()
        })
    }
    
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
        let network = Network()
        network.delegate = self
        network.downloadData(URL: DB_URL, param: postParameter)
    }
}
