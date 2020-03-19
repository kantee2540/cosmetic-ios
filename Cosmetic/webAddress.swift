//
//  getURL.swift
//  Cosmetic
//
//  Created by Omp on 28/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class webAddress {
    
    func getInfoDictionary() -> [String: AnyObject]? {
        guard let infoDictPath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            return nil
        }
        return NSDictionary(contentsOfFile: infoDictPath) as? [String : AnyObject]
    }
    
    func getrootURL() -> String{
        guard let rootURLString = getInfoDictionary()?["Server_URL"] else {
            return "!"
        }
        return rootURLString as! String
    }
    
    func getProductURL() -> String{
        let webFile = getrootURL() + "getProduct.php"
        return webFile
    }
    func getProductOnSearchURL() -> String {
        let webFile = getrootURL() + "getProductOnSearch.php"
        return webFile
    }
    
    func getCategoriesURL() -> String {
        let webFile = getrootURL() + "getCategories.php"
        return webFile
    }
    
    func getBrandURL() -> String{
        let webFile = getrootURL() + "getBrand.php"
        return webFile
        
    }
    
    func getPackageURL() -> String{
        let webFile = getrootURL() + "getPackage.php"
        return webFile
    }
    
    func getTopicURL() -> String{
        let webFile = getrootURL() + "getTopic.php"
        return webFile
    }
    
    func getCollectUserdata() -> String{
        let webFile = getrootURL() + "collectUserData.php"
        return webFile
    }
    
    func getUserURL() -> String{
        let webFile = getrootURL() + "getUser.php"
        return webFile
    }
    
    func getNotificationURL() -> String{
        let webFile = getrootURL() + "getNotification.php"
        return webFile
    }
    
    func getInsertItemToDesk() -> String{
        let webFile = getrootURL() + "insertCosmeticDesk.php"
        return webFile
    }
    
    func getDeleteItemFromDesk() -> String{
        let webFile = getrootURL() + "deleteCosmeticDesk.php"
        return webFile
    }
    
    func getCosmeticDeskList() -> String{
        let webFile = getrootURL() + "getCosmeticDeskList.php"
        return webFile
    }
    
    func getDrawerURL() -> String{
        let webFile = getrootURL() + "getDrawer.php"
        return webFile
    }
    
    func getAddDrawerURL() -> String{
        let webFile = getrootURL() + "insertDrawer.php"
        return webFile
    }
}
