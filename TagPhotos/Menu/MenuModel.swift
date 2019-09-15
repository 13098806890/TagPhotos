//
//  MenuModel.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/14.
//  Copyright © 2019 Teemo. All rights reserved.
//

import Foundation
import Photos

protocol MenuModelProtol: ModelProtocol{
    func menuItemForIndexPath(indexPath: IndexPath) ->(String, String, String)
}

class MenuModel: MenuModelProtol {
    var allPhotos: PHFetchResult<PHAsset>
    var smartAlbums: PHFetchResult<PHAssetCollection>
    var userCollections: PHFetchResult<PHCollection>
    
    init(allPhotos: PHFetchResult<PHAsset>, smartAlbums: PHFetchResult<PHAssetCollection>, userCollections: PHFetchResult<PHCollection>) {
        self.allPhotos = allPhotos
        self.smartAlbums = smartAlbums
        self.userCollections = userCollections
    }
    
    func numbersOfSection() -> NSInteger {
        return 3
    }
    
    func numberOfItemsForSection(section: NSInteger) -> NSInteger {
        switch section {
        case 0:
            return 1
        case 1:
            return smartAlbums.count
        case 2:
            return userCollections.count
        default:
            return 0
        }
    }
    
    func menuItemForIndexPath(indexPath: IndexPath) ->(String, String, String) {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            return ("", "All Photos", String(self.allPhotos.count))
        case 1:
            let album = smartAlbums[row]
            return ("", album.localizedTitle ?? "", String(album.photosCount))
        case 2:
            let album = userCollections[row]
            return ("", album.localizedTitle ?? "", "0")
        default:
            return ("", "", "0")
        }
    }
}
