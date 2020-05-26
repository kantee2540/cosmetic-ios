//
//  PackageModel.swift
//  Cosmetic
//
//  Created by Omp on 1/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class PackageModel: NSObject {
    var product_id: String?
    var product_name: String?
    var product_description: String?
    var product_price: Int?
    var product_img: String?
    
    var topic_id: String?
    var topic_name: String?
    var topic_description: String?
    var topic_code: String?
    
    var categories_id: String?
    var categories_name: String?
    
    override init() {
        
    }
}
