//
//  CategoriesModel.swift
//  Cosmetic
//
//  Created by Omp on 15/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class CategoriesModel: NSObject {
    var categories_id :String?
    var categories_name :String?
    var categories_type :String?
    
    override init() {
        
    }
    
    init(categories_id: String, categories_name: String, categories_type: String){
        
        self.categories_id = categories_id
        self.categories_name = categories_name
        self.categories_type = categories_type
    }
    
}
