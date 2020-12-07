//
//  CollectUserdata.swift
//  Cosmetic
//
//  Created by Omp on 29/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import AFNetworking

protocol CollectUserdataDelegate {
    func insertDataSuccess()
    func insertDataFailed()
    func updateProfileSuccess(imageURL: String)
}

class CollectUserdata: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        DispatchQueue.main.async(execute: { () -> Void in
            var jsonResult = NSDictionary()
            let dataObj = data
            
            do{
                jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            }catch let error as NSError{
                print(error)
            }
            
            let error = jsonResult["error"] as! Bool
            if !error{
                self.delegate?.insertDataSuccess()
            }else{
                self.delegate?.insertDataFailed()
            }
        })
    }
    
    func downloadFailed(error: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.insertDataFailed()
        })
    }
    
    
    var delegate: CollectUserdataDelegate?
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: [String: Any] = [:]
    
    func collectUserdata(firstname: String, lastName: String, nickname: String, email: String, uid: String){
        DB_URL = getAddress.getCreateUserURL()
        postParameter = ["first_name" : firstname,
                         "last_name" : lastName,
                         "nickname" : nickname,
                         "email" : email,
                         "uid" : uid]
        insertData()
    }
    
    func updateUserdata(firstname: String, lastName: String, nickname: String, email: String, uid: String){
        DB_URL = getAddress.getUpdateUserURL()
        postParameter = ["first_name" : firstname,
                         "last_name" : lastName,
                         "nickname" : nickname,
                         "email" : email,
                         "uid" : uid]
        insertData()
    }
    
    func insertData(){
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: postParameter, header: ["":""])
    }
    
    func updateProfilePicture(image: UIImage?){
        let url = getAddress.getUpdateProfilepic()
        let manager = AFHTTPSessionManager()
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        manager.responseSerializer = AFHTTPResponseSerializer()

        manager.post(url, parameters: [:], headers: ["Authorization": String(uid!)], constructingBodyWith: { (data:AFMultipartFormData!) -> Void in
            if image != nil{
                data.appendPart(withFileData: (image?.jpegData(compressionQuality: 0.75))!, name: "image", fileName: uid!+".jpg", mimeType: "image/jpeg")
                
            }
        },progress: {(Progress) in}, success: {
            (operation: URLSessionDataTask, responseObject: Any) in
            DispatchQueue.main.async(execute: { () -> Void in
                var jsonResult = NSDictionary()
                var profileURL :String = ""
                let dataObj = responseObject as! Data
                
                do{
                    jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                }catch let error as NSError{
                    print(error)
                }
                print(jsonResult)
                if let imgUrl = jsonResult["profile_url"],
                   let error = jsonResult["error"] as? Bool{
                    profileURL = imgUrl as! String
                    if !error{
                        self.delegate?.updateProfileSuccess(imageURL: profileURL)
                    }else{
                        self.delegate?.insertDataFailed()
                    }
                    
                }else{
                    self.delegate?.insertDataFailed()
                }
                
                
            })
        }, failure: {
            (Operation, error) in
            print("Error : " + error.localizedDescription)
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate?.insertDataFailed()
            })
        })
    }
}
