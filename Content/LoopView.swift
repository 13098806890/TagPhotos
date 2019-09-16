//
//  LoopView.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/16.
//  Copyright © 2019 Teemo. All rights reserved.
//

import UIKit

class LoopView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var contents: [UIView]
    private var size: CGSize
    
    init(size: CGSize, contents: [UIView]) {
        self.size = size
        self.contents = contents
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = size
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.delegate = self
        self.dataSource = self
        self.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "LoopViewCell")
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        if contents.count == 3 {
            self.scrollToItem(at: IndexPath(row: 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if contents.count >= 3 {
            return 3
        } else {
            return contents.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoopViewCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let row = indexPath.row
        cell.addSubview(contents[row])
    }
    
    

}
