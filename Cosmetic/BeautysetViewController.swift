//
//  BeautysetViewController.swift
//  Cosmetic
//
//  Created by Omp on 16/6/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

class BeautysetViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DownloadTopicProtocol, TopTopicDelegate, ShareBeautysetDelegate {
    func finishedCreateset() {
        let answerMessage = MDCSnackbarMessage()
        answerMessage.text = "Shared your beauty set to public"
        MDCSnackbarManager().show(answerMessage)
    }
    
    func topicGetItem(detail: TopicModel, packages: NSMutableArray) {
        
    }
    
    func dismissFromTopTopic() {
        let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
        self.navigationController?.pushViewController(accountVc!, animated: true)
    }
    
    func topicDownloaded(item: NSMutableArray) {
        beautyList = item as! [TopicModel]
        beautyCollection.reloadData()
        topicRefreshControl.endRefreshing()
        removeSpinner()
    }
    
    func topicError(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }

    private var beautyList: [TopicModel] = []
    @IBOutlet weak var beautysetScrollview: UIScrollView!
    @IBOutlet weak var beautyCollection: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topProfilepic: UIImageView!
    
    lazy var topicRefreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handlerRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    @objc private func handlerRefresh(_ refreshControl: UIRefreshControl){
        downloadTopic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner(onView: self.view)
        beautyCollection.delegate = self
        beautyCollection.dataSource = self
        
        setupTopview()
        downloadTopic()
        beautysetScrollview.addSubview(topicRefreshControl)
    }
    
    private func setupTopview(){
        topView.layer.cornerRadius = 8
        topView.layer.shadowColor =  UIColor.black.cgColor
        topView.layer.shadowOpacity = 0.15
        topView.layer.shadowRadius = 10
        topView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topProfilepic.makeRounded()
    }
    
    private func downloadTopic(){
        let downloadTopic = DownloadTopic()
        downloadTopic.delegate = self
        downloadTopic.downloadTopLimitTopic(limit: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Top Beauty Set"
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        if uid != nil{
            topView.visibility = .visible
            let profileurl = UserDefaults.standard.string(forKey: ConstantUser.profilepic)
            if profileurl != ""{
                
                topProfilepic.downloadImage(from: URL(string: profileurl!)!)
            }
        }else{
            topView.visibility = .gone
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seemore"{
            let destination = segue.destination as! TopTopicViewController
            let index = beautyCollection.indexPathsForSelectedItems?.first
            let item = beautyList[index!.row]
            destination.delegate = self
            destination.topicId = item.topic_id
        }else if segue.identifier == "shareset"{
            if let navigationController = segue.destination as? UINavigationController {
                if let firstvc = navigationController.viewControllers.first as? ShareBeautysetViewController {
                    firstvc.delegate = self
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beautyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beautyset", for: indexPath) as! BeautyCollectionViewCell
        
        let item = beautyList[indexPath.row]
        
        
        cell.title.text = item.topic_name
        cell.detail.text = item.topic_description
        
        if item.topic_img != ""{
            cell.beautysetImage.downloadImage(from: URL(string: item.topic_img!)!)
        }
        if item.userImg != ""{
            cell.profileImage.downloadImage(from: URL(string: item.userImg!)!)
        }
        cell.userlabel.text = item.nickname
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        collectionHeight.constant = beautyCollection.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
    }

}
