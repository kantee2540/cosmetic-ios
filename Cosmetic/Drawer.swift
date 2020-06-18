//
//  AddDrawer.swift
//  Cosmetic
//
//  Created by Omp on 19/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol DrawerDelegate {
    func itemAddSuccess()
    func itemAddFailed()
}

class Drawer: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemAddSuccess()
        })
    }
    
    func downloadFailed(error: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemAddFailed()
        })
    }
    
    var delegate: DrawerDelegate?
    let getAddress = webAddress()
    
    func addDrawer(userid id: String, drawer_name name: String){
        let DB_URL = getAddress.getAddDrawerURL()
        let postParam = ["user_id": id, "drawer_name": name]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: postParam)
        
    }
    
    func deleteDrawer(userid id: String, drawer_id draw_id: String){
        let DB_URL = getAddress.getDeleteDrawerURL()
        let postParam = ["user_id": id, "drawer_id": draw_id]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: postParam)
    }
}
