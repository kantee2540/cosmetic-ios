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
            self.delegate?.insertDataSuccess()
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
    
    func collectUserdata(firstname: String, lastName: String, nickname: String, email: String, gender: String, birthday: String, uid: String){
        print("Insert")
        postParameter = ["first_name" : firstname,
                         "last_name" : lastName,
                         "nick_name" : nickname,
                         "email" : email,
                         "gender" : gender,
                         "birthday" : birthday,
                         "uid" : uid,
                         "option" : 0]
        insertData()
    }
    
    func updateUserdata(firstname: String, lastName: String, nickname: String, email: String, gender: String, birthday: String, uid: String){
        print("Update")
        postParameter = ["first_name" : firstname,
                         "last_name" : lastName,
                         "nick_name" : nickname,
                         "email" : email,
                         "gender" : gender,
                         "birthday" : birthday,
                         "uid" : uid,
                         "option" : 1]
        insertData()
    }
    
    func insertData(){
        DB_URL = getAddress.getCollectUserdata()
        
        let network = Network()
        network.delegate = self
        network.downloadData(URL: DB_URL, param: postParameter)
    }
    
    func updateProfilePicture(userId: String, image: UIImage?){
        let url = getAddress.getUpdateProfilepic()
        let manager = AFHTTPSessionManager()
        let param = ["user_id": userId]
        manager.responseSerializer = AFHTTPResponseSerializer()

        manager.post(url, parameters: param, headers: nil, constructingBodyWith: { (data:AFMultipartFormData!) -> Void in
            if image != nil{
                data.appendPart(withFileData: (image?.jpegData(compressionQuality: 0.75))!, name: "imageFile", fileName: userId, mimeType: "image/jpeg")
            }
        },progress: {(Progress) in}, success: {
            (operation: URLSessionDataTask, responseObject: Any) in
            DispatchQueue.main.async(execute: { () -> Void in
                var jsonResult = NSArray()
                var profileURL :String = ""
                let dataObj = responseObject as! Data
                
                do{
                    jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                }catch let error as NSError{
                    print(error)
                }

                var jsonElement = NSDictionary()
                
                jsonElement = jsonResult[0] as! NSDictionary
                if let imgUrl = jsonElement["profileURL"]{
                    profileURL = imgUrl as! String
                }
                
                self.delegate?.updateProfileSuccess(imageURL: profileURL)
            })
        }, failure: {
            (Operation, error) in
            print(error)
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate?.insertDataFailed()
            })
        })
    }
}
