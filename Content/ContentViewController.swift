//
//  ContentViewController.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/14.
//  Copyright © 2019 Teemo. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    var collectionView: UICollectionView?
    weak var container: ContainerViewController?
    var model: ContentModel
    var queue = OperationQueue.init()
    
    
    init(model: ContentModel) {
        self.model = model

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func size() -> CGSize {
        let size: CGFloat = UIScreen.main.bounds.width / 6
        return CGSize(width: size, height: size)
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.itemSize = size()
        
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.view.addSubview(collectionView!)
        self.navigationItem.setLeftBarButton(leftBarButtonItem(), animated: false)
        self.navigationItem.setRightBarButton(rightBarButtonItem(), animated: false)
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout())
        collectionView?.frame = self.view.frame
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(UINib.init(nibName: "ContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ContentCollectionViewCell")
    }
    
    func rightBarButtonItem() -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem.init(title: "Select", style: .plain, target: self, action: #selector(rightBarButtonItemSelected))
        return barButtonItem
    }
    
    @objc func rightBarButtonItemSelected() {
        
    }
    
    func leftBarButtonItem() -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem.init(title: "Album", style: .done, target: self, action: #selector(leftBarButtonItemSelected))
        return barButtonItem
    }
    
    @objc func leftBarButtonItemSelected() {
        container?.perform(#selector(container?.openCloseMenu))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.numbersOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.numberOfItemsForSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell {
            return cell
            
        } else {
            let cell = ContentCollectionViewCell()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ContentCollectionViewCell {
            setupContentCollectionViewCell(cell: cell, at: indexPath)
        }
    }
    
    func setupContentCollectionViewCell(cell: ContentCollectionViewCell, at indexPath: IndexPath) {
        let asset = model.itemAtIndexPath(indexPath: indexPath)
        queue.addOperation {
            AlbumManager.shared.requsetAssetData(asset: asset, size: self.size()) { (image, info) in
                DispatchQueue.main.async {
                    if let image = image {
                        cell.imageView.image = image
                    }
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = DetailViewController.init(model: model, indexPath: indexPath)
        detailController.modalTransitionStyle = .coverVertical
        self.present(detailController, animated: true, completion: nil)
    }
    

}
