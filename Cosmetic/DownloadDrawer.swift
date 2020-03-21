//
//  DownloadDrawer.swift
//  Cosmetic
//
//  Created by Omp on 19/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol DownloadDrawerDelegate {
    func itemDrawerDownloaded(item: NSMutableArray)
    func itemDrawerFailed(error: String)
}

class DownloadDrawer: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        self.parseJSON(data)
    }
    
    func downloadFailed(error: String) {
        delegate?.itemDrawerFailed(error: error)
    }
    
    let getWebAddress = webAddress()
    var DB_URL: String!
    var delegate: DownloadDrawerDelegate?
    
    func downloadDrawer(userid id: String) {
        DB_URL = getWebAddress.getDrawerURL()
        let postParameter = ["user_id": id]
        
        let network = Network()
        network.delegate = self
        network.downloadData(URL: DB_URL, param: postParameter)
    }
    
    func parseJSON(_ data:Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }

        var jsonElement = NSDictionary()
        let drawers = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            let drawer = DrawerModel()
            
            if let drawer_id = jsonElement[ConstantDrawer.drawerId] as? String,
                let drawer_name = jsonElement[ConstantDrawer.drawerName] as? String,
                let user_id = jsonElement[ConstantDrawer.userId] as? String,
                let countitem = jsonElement[ConstantDrawer.countitem] as? String
            {
                drawer.drawer_id = drawer_id
                drawer.drawer_name = drawer_name
                drawer.user_id = user_id
                drawer.countitem = countitem
                
            }
            drawers.add(drawer)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemDrawerDownloaded(item: drawers)
        })
        
    }
}
