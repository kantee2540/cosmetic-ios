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
        let webFile = getrootURL() + "product"
        return webFile
    }
    
    func getCategoriesURL() -> String {
        let webFile = getrootURL() + "categories"
        return webFile
    }
    
    
    func getBrandURL() -> String{
        let webFile = getrootURL() + "brand"
        return webFile
        
    }
    
    func getTopicURL() -> String{
        let webFile = getrootURL() + "beautyset"
        return webFile
    }
    
    func getMytopicURL() -> String{
        let webFile = getrootURL() + "beautyset/my_set"
        return webFile
    }
    
    func getCreateUserURL() -> String{
        let webFile = getrootURL() + "user/create"
        return webFile
    }
    
    func getUpdateUserURL() -> String{
        let webFile = getrootURL() + "user/update"
        return webFile
    }
    
    func getUserURL() -> String{
        let webFile = getrootURL() + "user"
        return webFile
    }
    
    func getDeleteUserURL() -> String{
        let webFile = getrootURL() + "user/delete"
        return webFile
    }
    
    func getNotificationURL() -> String{
        let webFile = getrootURL() + "getNotification.php"
        return webFile
    }
    
    func getCheckItem() -> String{
        let webFile = getrootURL() + "cosmetic_desk/check"
        return webFile
    }
    
    func getInsertItemToDesk() -> String{
        let webFile = getrootURL() + "cosmetic_desk/add"
        return webFile
    }
    
    func getDeleteItemFromDesk() -> String{
        let webFile = getrootURL() + "cosmetic_desk/delete"
        return webFile
    }
    
    func getCosmeticDeskList() -> String{
        let webFile = getrootURL() + "cosmetic_desk/list"
        return webFile
    }
    
    func getCosmeticDeskFavoriteList() -> String{
        let webFile = getrootURL() + "cosmetic_desk/favorite"
        return webFile
    }
    
    func getUpdateFavoriteURL() -> String{
        let webFile = getrootURL() + "cosmetic_desk/update_favorite"
        return webFile
    }
    
    func getInsertTopicURL() -> String{
        let webFile = getrootURL() + "beautyset/add"
        return webFile
    }
    
    func editTopicURL() -> String{
        let webFile = getrootURL() + "beautyset/edit"
        return webFile
    }
    
    func removeTopicURL() -> String{
        let webFile = getrootURL() + "beautyset/delete"
        return webFile
    }
    
    func getSaveTopicURL() -> String {
        let webFile = getrootURL() + "beautyset/my_set/saved_set"
        return webFile
    }
    
    func getInsertSaveTopicURL() -> String{
        let webFile = getrootURL() + "beautyset/my_set/save"
        return webFile
    }
    
    func getDeleteSaveTopicURL() -> String{
        let webFile = getrootURL() + "beautyset/my_set/delete"
        return webFile
    }
    
    func getUpdateProfilepic() -> String{
        let webFile = getrootURL() + "user/upload_profile"
        return webFile
    }
    
    func getSetLike() -> String{
        let webFile = getrootURL() + "beautyset/my_set/set_like"
        return webFile
    }
    
    func getSetunlike() -> String{
        let webFile = getrootURL() + "beautyset/my_set/set_unlike"
        return webFile
    }
    
    func getCheckLikeURL() -> String{
        let webFile = getrootURL() + "beautyset/my_set/is_liked"
        return webFile
    }
    
}
