//
//  DetailViewController.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/15.
//  Copyright © 2019 Teemo. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController, LoopViewDelegate {
    var model: ContentModel
    var indexPath: IndexPath
    var imageView: UIImageView?
    var previousImageView: UIImageView?
    var nextImageView: UIImageView?
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
        self.initializeImageViews()
        self.loopView = LoopView.init(size: view.frame.size, loopViewDelegate: self)
        self.view.backgroundColor = .black
        self.view.addSubview(self.loopView!)
        
    }
    
    func initializeImageViews() {
        if let previousIndexPath = model.getPreviousIndexPath(indexPath: self.indexPath) {
            let asset = model.itemForIndexPath(indexPath: previousIndexPath)
            previousImageView = UIImageView.init()
            previousImageView?.frame.size = imageViewSize(asset: asset)
            previousImageView?.center = view.center
            AlbumManager.shared.requsetAssetData(asset: asset, size: self.view.frame.size) { (image, info) in
                DispatchQueue.main.async {
                    self.previousImageView?.image = image
                }
            }
        }
        let asset = self.model.itemForIndexPath(indexPath: self.indexPath)
        imageView = UIImageView.init()
        imageView?.frame.size = imageViewSize(asset: asset)
        imageView?.center = view.center
        AlbumManager.shared.requsetAssetData(asset: asset, size: self.view.frame.size) { (image, info) in
            DispatchQueue.main.async {
                self.imageView?.image = image
            }
        }
        if let nextIndexPath = model.getNextIndexPath(indexPath: self.indexPath) {
            let asset = model.itemForIndexPath(indexPath: nextIndexPath)
            nextImageView = UIImageView.init()
            nextImageView?.frame.size = imageViewSize(asset: asset)
            nextImageView?.center = view.center
            AlbumManager.shared.requsetAssetData(asset: asset, size: self.view.frame.size) { (image, info) in
                DispatchQueue.main.async {
                    self.nextImageView?.image = image
                }
            }
        }
        
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
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func canMoveToNext() -> Bool {
        return nextImageView != nil
    }
    
    func canMoveToPreview() -> Bool {
        return previousImageView != nil
    }
    
    func contents() -> [UIView] {
        var contents = [UIView]()
        if let previousImageView = previousImageView {
            contents.append(previousImageView)
        }
        if let imageView = imageView {
            contents.append(imageView)
        }
        if let nextImageView = nextImageView {
            contents.append(nextImageView)
        }
        
        return contents
    }

}
