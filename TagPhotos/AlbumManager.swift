//
//  AlbumManager.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/14.
//  Copyright © 2019 Teemo. All rights reserved.
//

import Foundation
import Photos

class AlbumManager {
    static var shared = AlbumManager()
    var menuModel: MenuModel?
    lazy var allPhotoMoedel: ContentModel = {
        return ContentModel.init(album: self.allPhotos!)
    }()
    private var allPhotos: PHFetchResult<PHAsset>?
    private var smartAlbums: PHFetchResult<PHAssetCollection>?
    private var userCollections: PHFetchResult<PHCollection>?
    
    func authorizationPhotoStatus() -> PHAuthorizationStatus {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        return authStatus
    }
    
    func accessPhotos() {
        PHPhotoLibrary.requestAuthorization { (status) in
        }
    }
    
    func fetchAlbum() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        menuModel = MenuModel.init(allPhotos: allPhotos!, smartAlbums: smartAlbums!, userCollections: userCollections!)
        NSLog("done")
    }
    
    func requsetAssetData(asset: PHAsset, size: CGSize, handler: @escaping (UIImage?,[AnyHashable: Any]?) -> ()) {
        let requestOption = PHImageRequestOptions.init()
        requestOption.resizeMode = .fast
        requestOption.isNetworkAccessAllowed = true
        PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: requestOption) { (image, info) in
            handler(image, info)
        }
    }
}
