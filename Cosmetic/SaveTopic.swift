//
//  SaveTopic.swift
//  Cosmetic
//
//  Created by Omp on 15/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol SaveTopicDelegate {
    func saveTopicSuccess()
    func saveTopicFailed()
}

class SaveTopic: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        delegate?.saveTopicSuccess()
    }
    
    func downloadFailed(error: String) {
        delegate?.saveTopicFailed()
    }
    
    var delegate: SaveTopicDelegate?
    
    let getAddress = webAddress()
    var DB_URL: String?
    
    func saveTopic(topicId: Int){
        
        let DB_URL = getAddress.getInsertSaveTopicURL()
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        let param = ["topic_id": topicId]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param, header: ["Authorization": String(uid!)])
    }
        
    func deleteTopic(topicId: Int){
        let DB_URL = getAddress.getDeleteSaveTopicURL()
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        let param = ["topic_id": topicId]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param, header: ["Authorization": String(uid!)])
    }
}
