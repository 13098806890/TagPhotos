//
//  ContentModel.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/14.
//  Copyright © 2019 Teemo. All rights reserved.
//

import Foundation
import Photos

protocol ContentModelProtocol: ModelProtocol {
    func itemForIndexPath(indexPath: IndexPath) -> PHAsset
}

class ContentModel: ContentModelProtocol {
    
    var fetchResult: PHFetchResult<PHAsset>
    
    init(album: PHFetchResult<PHAsset>) {
        fetchResult = album
    }
    
    
    func itemForIndexPath(indexPath: IndexPath) -> PHAsset {
        return fetchResult.object(at: indexPath.row)
    }
    
    func numbersOfSection() -> NSInteger {
        return 1
    }
    
    func numberOfItemsForSection(section: NSInteger) -> NSInteger {
        return fetchResult.count
    }
    
    func getPreviousIndexPath(indexPath: IndexPath) -> IndexPath? {
        let row = indexPath.row
        if row - 1 >= 0 {
            return IndexPath.init(row: row - 1, section: indexPath.section)
        }
        return nil
    }
    
    func getNextIndexPath(indexPath: IndexPath) -> IndexPath? {
        let row = indexPath.row
        if row + 1 < self.fetchResult.count {
            return IndexPath.init(row: row + 1, section: indexPath.section)
        }
        return nil
    }
    

}
