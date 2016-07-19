//
//  FNPDPhotoFetcher.swift
//  FNPhotoDrawer
//
//  Created by Fnoz on 16/7/18.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

import Foundation
import Photos

class FNPDPhotoFetcher: NSObject {
    var albumArray:NSMutableArray = []
    func fetchAlbum() -> NSArray {
        let smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .Any, options: nil)
        let userAlbums = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: nil)
        let assetCollectionSubtypes:[PHAssetCollectionSubtype] = [.SmartAlbumUserLibrary,
                                   .SmartAlbumFavorites,
                                   .AlbumMyPhotoStream,
                                   .AlbumCloudShared,
                                   .AlbumRegular]
        smartAlbums.enumerateObjectsUsingBlock { [unowned self](assetCollection, index, stop) -> Void in
            guard let assetCollection = assetCollection as? PHAssetCollection else { return }
            if assetCollectionSubtypes.contains(assetCollection.assetCollectionSubtype) {
                self.albumArray.addObject(assetCollection)
            }
        }
        
        userAlbums.enumerateObjectsUsingBlock { (assetCollection, index, stop) -> Void in
            guard let assetCollection = assetCollection as? PHAssetCollection else { return }
            if assetCollectionSubtypes.contains(assetCollection.assetCollectionSubtype) {
                self.albumArray.addObject(assetCollection)
            }
        }
        
        return albumArray
    }
    
}
