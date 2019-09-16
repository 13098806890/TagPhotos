//
//  DetailViewController.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/15.
//  Copyright © 2019 Teemo. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController {
    var model: ContentModel
    var indexPath: IndexPath
    var imageView: UIImageView = UIImageView.init(frame: CGRect.zero)
    var previousImageView: UIImageView = UIImageView.init(frame: CGRect.zero)
    var nextImageView: UIImageView = UIImageView.init(frame: CGRect.zero)
    var loopView: LoopView?
    let swipeGestureDown = UISwipeGestureRecognizer()
    
    init(model: ContentModel, indexPath: IndexPath) {
        self.model = model
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButton(leftBarButtonItem(), animated: false)
        self.initializeGesture()
        self.loopView = LoopView.init(size: view.frame.size, contents: imageViews())
        self.view.backgroundColor = .black
        self.view.addSubview(self.loopView!)
        
    }
    
    func imageViews() -> [UIImageView] {
        var views = [UIImageView]()
        if let previousIndexPath = model.getPreviousIndexPath(indexPath: self.indexPath) {
            let asset = model.itemForIndexPath(indexPath: previousIndexPath)
            previousImageView.frame.size = imageViewSize(asset: asset)
            previousImageView.center = view.center
            AlbumManager.shared.requsetAssetData(asset: asset, size: self.view.frame.size) { (image, info) in
                DispatchQueue.main.async {
                    self.previousImageView.image = image
                }
            }
            views.append(previousImageView)
        }
        let asset = self.model.itemForIndexPath(indexPath: self.indexPath)
        imageView.frame.size = imageViewSize(asset: asset)
        imageView.center = view.center
        AlbumManager.shared.requsetAssetData(asset: asset, size: self.view.frame.size) { (image, info) in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        views.append(imageView)
        if let nextIndexPath = model.getPreviousIndexPath(indexPath: self.indexPath) {
            let asset = model.itemForIndexPath(indexPath: nextIndexPath)
            nextImageView.frame.size = imageViewSize(asset: asset)
            nextImageView.center = view.center
            AlbumManager.shared.requsetAssetData(asset: asset, size: self.view.frame.size) { (image, info) in
                DispatchQueue.main.async {
                    self.nextImageView.image = image
                }
            }
            views.append(nextImageView)
        }
        
        return views
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
        let width = self.view.frame.width
        let height = CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth) * width
        
        return CGSize(width: width, height: height)
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }

}
