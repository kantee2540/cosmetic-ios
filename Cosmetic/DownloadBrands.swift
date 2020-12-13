//
//  DownloadBrands.swift
//  Cosmetic
//
//  Created by Omp on 18/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

@objc protocol DownloadBrandProtocol: class {
    func itemDownloadedBrands(item: NSMutableArray)
}

@objc class DownloadBrands: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        self.parseJSON(data)
    }
    
    func downloadFailed(error: String) {
        
    }
    
    @objc weak var delegate: DownloadBrandProtocol?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    
    @objc func downloadItem(){
        DB_URL = getAddress.getBrandURL()
        
        let network = Network()
        network.delegate = self
        network.get(URL: DB_URL, param: [:])
    }
    
    @objc func parseJSON(_ data:Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        
        var jsonElement = NSDictionary()
        let brands = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            let brand = BrandModel()
            
            if let brand_id = jsonElement[ConstantBrand.brandId] as? Int,
                let brand_name = jsonElement[ConstantBrand.brandName] as? String
                
            {
                brand.brand_id = brand_id
                brand.brand_name = brand_name
            }
            
            brands.add(brand)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemDownloadedBrands(item: brands)
        })
        
    }
}
