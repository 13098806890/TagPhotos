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
    func itemAtIndexPath(indexPath: IndexPath) -> PHAsset
    func count() -> NSInteger
    func itemAtIndex(index: NSInteger) -> PHAsset
}

class ContentModel: ContentModelProtocol {
    
    var fetchResult: PHFetchResult<PHAsset>
    
    init(album: PHFetchResult<PHAsset>) {
        fetchResult = album
    }
    
    
    func itemAtIndexPath(indexPath: IndexPath) -> PHAsset {
        return fetchResult.object(at: indexPath.row)
    }
    
    func numbersOfSection() -> NSInteger {
        return 1
    }
    
    func numberOfItemsForSection(section: NSInteger) -> NSInteger {
        return fetchResult.count
    }
    
    func count() -> NSInteger {
        return fetchResult.count
    }
    
    func itemAtIndex(index: NSInteger) -> PHAsset {
        return fetchResult.object(at: index)
    }
    

}
