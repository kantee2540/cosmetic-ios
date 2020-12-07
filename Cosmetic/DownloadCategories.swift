//
//  DownloadCatagories.swift
//  Cosmetic
//
//  Created by Omp on 15/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

protocol DownloadCategoriesProtocol: class {
    func itemDownloadedCategories(item: NSMutableArray)
}

class DownloadCategories: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        self.parseJSON(data)
    }
    
    func downloadFailed(error: String) {
        
    }
    
    
    weak var delegate: DownloadCategoriesProtocol?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    
    func downloadItem(){
        DB_URL = getAddress.getCategoriesURL()
        
        let network = Network()
        network.delegate = self
        network.get(URL: DB_URL, param: [:])
    }
    
    func parseJSON(_ data:Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        
        var jsonElement = NSDictionary()
        let categories = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            let category = CategoriesModel()
            
            if  let categories_id = jsonElement[ConstantCategories.categoriesId] as? Int,
                let categories_name = jsonElement[ConstantCategories.categoriesName] as? String,
                let categories_type = jsonElement[ConstantCategories.categoriesType] as? String
            {
                category.categories_id = categories_id
                category.categories_name = categories_name
                category.categories_type = categories_type
            }
            
            categories.add(category)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemDownloadedCategories(item: categories)
        })
        
    }
}
