//
//  UpdateFavorite.swift
//  Cosmetic
//
//  Created by Omp on 27/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol UpdateFavoriteDelegate {
    func updateFavoriteSuccess()
    func updateFavoriteFailed(error: String)
}

class UpdateFavorite: NSObject, NetworkDelegate {
    
    var delegate: UpdateFavoriteDelegate?
    let getAddress = webAddress()
    var DB_URL:String!
    
    func downloadSuccess(data: Data) {
        delegate?.updateFavoriteSuccess()
    }
    
    func downloadFailed(error: String) {
        delegate?.updateFavoriteFailed(error: error)
    }
    
    func setFavorite(setFavorite: Bool, desk_id: Int){
        DB_URL = getAddress.getUpdateFavoriteURL()
        var fav: Int?
        
        if setFavorite{
            fav = 1
        }else{
            fav = 0
        }
        
        let postParam = ["favorite": fav as Any, "desk_id": desk_id] as [String : Any]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: postParam, header: ["":""])
    }
}
