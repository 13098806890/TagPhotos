//
//  LoopView.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/16.
//  Copyright © 2019 Teemo. All rights reserved.
//

import UIKit

protocol LoopViewDelegate: NSObject {
    func canMoveToNext() -> Bool
    func canMoveToPreview() -> Bool
    func contents() -> [UIView]
    func reloadContent()
}

class LoopView: UIScrollView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    weak var loopViewDelegate: LoopViewDelegate?
    private var size: CGSize
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()
    
    init(size: CGSize, loopViewDelegate: LoopViewDelegate) {
        self.size = size
        self.loopViewDelegate = loopViewDelegate
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = size
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        initialize()
        initializeGesture()
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
        if contents().count > 0 {
            self.isPagingEnabled = true
            self.isScrollEnabled = false
            if contents().count == 3 {
                self.scrollToItem(at: IndexPath(row: 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }
    
    func initializeGesture() {
        self.swipeGestureLeft.addTarget(self, action: #selector(swipeLeft))
        self.swipeGestureLeft.direction = .left
        self.swipeGestureRight.addTarget(self, action: #selector(swipeRight))
        self.swipeGestureRight.direction = .right
        self.addGestureRecognizer(swipeGestureRight)
        self.addGestureRecognizer(swipeGestureLeft)
    }
    
    func contents() -> [UIView] {
        return self.loopViewDelegate?.contents() ?? [UIView]()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if contents().count >= 3 {
            return 3
        } else {
            return contents().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoopViewCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let row = indexPath.row
        cell.addSubview(contents()[row])
    }
    
    override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
    }
    
    @objc func swipeLeft() {
        if self.loopViewDelegate?.canMoveToNext() ?? false {
            scrollToItem(at: IndexPath(row: 2, section: 0), at: UICollectionView.ScrollPosition.init(), animated: true)
        }
    }
    
    @objc func swipeRight() {
        if self.loopViewDelegate?.canMoveToPreview() ?? false {
            scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionView.ScrollPosition.init(), animated: true)
        }
    }
    

}
