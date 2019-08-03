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

@objc class DownloadBrands: NSObject {
    @objc weak var delegate: DownloadBrandProtocol!
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    
    @objc func downloadItem(){
        DB_URL = getAddress.getBrandURL()
        
        //Get data from database
        var request = URLRequest(url: URL(string: DB_URL)!)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("Failed to Download data")
                
            }else{
                print("Data downloaded - Brands")
                self.parseJSON(data!)
            }
            
        }
        task.resume()
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
            
            if let brand_id = jsonElement["brand_id"] as? String,
                let brand_name = jsonElement["brand_name"] as? String,
                let brand_logo = jsonElement["brand_logo"] as? String
                
            {
                brand.brand_id = brand_id
                brand.brand_name = brand_name
                brand.brand_logo = brand_logo
            }
            
            brands.add(brand)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemDownloadedBrands(item: brands)
        })
        
    }
}
