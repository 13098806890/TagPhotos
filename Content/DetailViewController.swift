//
//  DetailViewController.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/15.
//  Copyright © 2019 Teemo. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var model: ContentModel
    var collectionView: UICollectionView?
    var indexPath: IndexPath
    let swipeGestureDown = UISwipeGestureRecognizer()
    
    init(model: ContentModel, indexPath: IndexPath) {
        self.model = model
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageSize() -> CGSize {
        return CGSize(width: self.view.frame.width - 10, height: self.view.frame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButton(leftBarButtonItem(), animated: false)
        self.initializeGesture()
        self.view.backgroundColor = .black
        self.initializeCollectionView()
        self.view.addSubview(self.collectionView!)
        self.collectionView?.scrollToItem(at: self.indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
    
    func initializeCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = pageSize()
        collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isPagingEnabled = true
        collectionView?.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "DetailViewControllerCell")
        collectionView?.showsVerticalScrollIndicator = false
    }
    
    func leftBarButtonItem() -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem.init(title: "Album", style: .done, target: self, action: #selector(close))
        return barButtonItem
    }
    
    func initializeGesture() {
        self.swipeGestureDown.addTarget(self, action: #selector(close))
        self.swipeGestureDown.direction = .down
        self.view.addGestureRecognizer(swipeGestureDown)
    }
    
    func imageViewSize(asset: PHAsset) -> CGSize {
        let width = pageSize().width
        let height = CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth) * width
        
        return CGSize(width: width, height: height)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailViewControllerCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let asset = self.model.itemAtIndex(index: row)
        for view in cell.subviews {
            view.removeFromSuperview()
        }

        cell.addSubview(self.imageContainer(asset: asset))
    }
    
    func imageContainer(asset: PHAsset) -> UIView {
        let imageView = UIImageView.init()
        imageView.frame.size = imageViewSize(asset: asset)
        imageView.center = view.center
        AlbumManager.shared.requsetAssetData(asset: asset, size: self.view.frame.size) { (image, info) in
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
        
        return imageView
    }

}
