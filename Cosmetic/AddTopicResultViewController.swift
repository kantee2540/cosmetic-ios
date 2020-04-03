//
//  AddTopicResultViewController.swift
//  Cosmetic
//
//  Created by Omp on 3/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class AddTopicResultViewController: UIViewController, DownloadTopicProtocol {
    
    func topicDownloaded(item: NSMutableArray) {
        topicList = item as! [TopicModel]
        removeSpinner()
    }
    
    func topicError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var topicCodeTextfield: UITextField!
    @IBOutlet weak var goBackButton: UIButton!
    
    var topicCode: String = ""
    private var topicList: [TopicModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner(onView: self.view)
        goBackButton.makeRoundedView()
        // Do any additional setup after loading the view.
        topicCodeTextfield.text = topicCode
        
        let downloadTopic = DownloadTopic()
        downloadTopic.delegate = self
        downloadTopic.getTopicId(code: topicCode)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func tapGoBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func tapSeeTopic(_ sender: Any) {
        let topicDetail = storyboard?.instantiateViewController(identifier: "TopTopic") as? TopTopicViewController
        let item = topicList[0]
        topicDetail?.topicId = item.topic_id
        self.present(topicDetail!, animated: true, completion: nil)
    }
    
}
