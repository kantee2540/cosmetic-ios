//
//  DeleteUser.swift
//  Cosmetic
//
//  Created by Omp on 21/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

protocol DeleteUserDelegate {
    func deleteUserSuccess()
    func deleteUserFailed(error: String)
}

class DeleteUser: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        delegate?.deleteUserSuccess()
    }
    
    func downloadFailed(error: String) {
        delegate?.deleteUserFailed(error: error)
    }
    
    var delegate: DeleteUserDelegate?
    let getAddress = webAddress()
    
    func deleteUser(userId: String){
        let DB_URL = getAddress.getDeleteUserURL()
        let param = ["user_id": userId]
        let loginManager = LoginManager()
        
        let user = Auth.auth().currentUser
        user?.delete(completion: { error in
            if let error = error{
                print(error)
                self.delegate?.deleteUserFailed(error: error.localizedDescription)
            }else{
                loginManager.logOut()
                let network = Network()
                network.delegate = self
                network.downloadData(URL: DB_URL, param: param)
                self.removeUserData()
            }
        })
    }
    
    private func removeUserData(){
        UserDefaults.standard.removeObject(forKey: ConstantUser.userId)
        UserDefaults.standard.removeObject(forKey: ConstantUser.firstName)
        UserDefaults.standard.removeObject(forKey: ConstantUser.lastName)
        UserDefaults.standard.removeObject(forKey: ConstantUser.nickName)
        UserDefaults.standard.removeObject(forKey: ConstantUser.email)
        UserDefaults.standard.removeObject(forKey: ConstantUser.gender)
        UserDefaults.standard.removeObject(forKey: ConstantUser.birthday)
    }
}
