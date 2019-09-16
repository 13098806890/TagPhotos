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
    var asset: PHAsset
    var imageView: UIImageView = UIImageView.init(frame: CGRect.zero)
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()
    let swipeGestureDown = UISwipeGestureRecognizer()
    
    init(asset: PHAsset) {
        self.asset = asset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButton(leftBarButtonItem(), animated: false)
        self.initializeGesture()
        self.imageView.frame.size = imageViewSize()
        self.imageView.center = self.view.center
        self.view.backgroundColor = .black
        self.view.addSubview(self.imageView)
        AlbumManager.shared.requsetAssetData(asset: asset, size: self.view.frame.size) { (image, info) in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    func leftBarButtonItem() -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem.init(title: "Album", style: .done, target: self, action: #selector(close))
        return barButtonItem
    }
    
    func initializeGesture() {
        self.swipeGestureLeft.addTarget(self, action: #selector(moveToNextAsset))
        self.swipeGestureLeft.direction = .left
        self.swipeGestureDown.addTarget(self, action: #selector(close))
        self.swipeGestureDown.direction = .down
        self.swipeGestureRight.addTarget(self, action: #selector(moveToPreviousAsset))
        self.swipeGestureRight.direction = .right
        self.view.addGestureRecognizer(swipeGestureLeft)
        self.view.addGestureRecognizer(swipeGestureRight)
        self.view.addGestureRecognizer(swipeGestureDown)
    }
    
    func imageViewSize() -> CGSize {
        let width = self.view.frame.width
        let height = CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth) * width
        
        return CGSize(width: width, height: height)
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moveToPreviousAsset() {
        
    }
    
    @objc func moveToNextAsset() {
        
    }

}
