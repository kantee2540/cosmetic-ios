//
//  getURL.swift
//  Cosmetic
//
//  Created by Omp on 28/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class webAddress {
    
    //Change server must be change this string
    //var prefixString: String = "http://192.168.1.175:8080/webService/" //FOR internal Test
    var prefixString: String = "https://cococosmetic.000webhostapp.com/"
    
    func getProductURL() -> String{
        let webFile = prefixString + "getProduct.php"
        return webFile
    }
    func getProductOnSearchURL() -> String {
        let webFile = prefixString + "getProductOnSearch.php"
        return webFile
    }
    
    func getCategoriesURL() -> String {
        let webFile = prefixString + "getCategories.php"
        return webFile
    }
    
    func getBrandURL() -> String{
        let webFile = prefixString + "getBrand.php"
        return webFile
        
    }
    
    func getPackageURL() -> String{
        let webFile = prefixString + "getPackage.php"
        return webFile
    }
    
    func getTopicURL() -> String{
        let webFile = prefixString + "getTopic.php"
        return webFile
    }
    
    func getCollectUserdata() -> String{
        let webFile = prefixString + "collectUserData.php"
        return webFile
    }
    
    func getUserURL() -> String{
        let webFile = prefixString + "getUser.php"
        return webFile
    }
    
    func getNotificationURL() -> String{
        let webFile = prefixString + "getNotification.php"
        return webFile
    }
    
    func getInsertItemToDesk() -> String{
        let webFile = prefixString + "insertCosmeticDesk.php"
        return webFile
    }
    
    func getDeleteItemFromDesk() -> String{
        let webFile = prefixString + "deleteCosmeticDesk.php"
        return webFile
    }
    
    func getCosmeticDeskList() -> String{
        let webFile = prefixString + "getCosmeticDeskList.php"
        return webFile
    }
}
