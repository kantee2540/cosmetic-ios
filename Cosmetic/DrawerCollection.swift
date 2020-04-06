//
//  DrawerCollection.swift
//  Cosmetic
//
//  Created by Omp on 20/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol DrawerCollectionDelegate {
    func onSuccess()
}

class DrawerCollection: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        delegate?.onSuccess()
    }
    
    func downloadFailed(error: String) {
        
    }
    
    var delegate: DrawerCollectionDelegate?
    let getAddress = webAddress()
    
    func deleteFromCollection(collection_id: String){
        let DB_URL = getAddress.getDeleteCollectionURL()
        let param = ["drawer_collection_id": collection_id]
        
        let network = Network()
        network.delegate = self
        network.downloadData(URL: DB_URL, param: param)
        
    }
    
    func addToOneCollection(drawerId: String, deskId: String){
        let DB_URL = getAddress.getAddCollectionURL()
        let param = ["desk_id": deskId, "drawer_id": drawerId]
        let network = Network()
        network.delegate = self
        network.downloadData(URL: DB_URL, param: param)
    }
    
    func addToCollection(drawerId: String, deskIdSet: [String]){
        let DB_URL = getAddress.getAddCollectionURL()
        let deskSet = convertToJson(object: deskIdSet)
        let param = ["desk_set": deskSet, "drawer_id": drawerId]
        
        let network = Network()
        network.delegate = self
        network.downloadData(URL: DB_URL, param: param as [String : Any])
    }
    
    func convertToJson(object: [String]) -> String?{
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else{
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
