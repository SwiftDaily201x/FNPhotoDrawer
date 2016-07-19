//
//  FNPhotoDrawer.swift
//  FNPhotoDrawer
//
//  Created by Fnoz on 16/7/18.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

import UIKit
import Photos

class FNPhotoDrawer: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    var albumArray:NSArray! = []
    var photoArray:NSMutableArray! = []
    var collectionViewArray:NSMutableArray! = []
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var albumNameBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
        initView(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData() {
        albumArray = FNPDPhotoFetcher.init().fetchAlbum()
        for album in albumArray {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchOptions.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.Image.rawValue)
            
            let assetsFetchResults = PHAsset.fetchAssetsInAssetCollection(album as! PHAssetCollection, options: fetchOptions)
            photoArray.addObject(assetsFetchResults)
        }
    }
    
    func initView(frame: CGRect) {
        backgroundColor = UIColor.init(white: 1.0, alpha: 1)
        layer.shadowColor = UIColor.init(white: 0.85, alpha: 1).CGColor
        layer.shadowOffset = CGSizeMake(0, -4);
        layer.shadowOpacity = 1;
        layer.shadowRadius = 4;
        
        let scrollView = UIScrollView.init(frame: bounds)
        scrollView.contentSize = CGSize.init(width: bounds.width * CGFloat(albumArray.count), height: bounds.height)
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        addSubview(scrollView)
        for i in 0...albumArray.count - 1 {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
            let cellWidth = floor((bounds.width - 8 * 5 - 10) / 5)
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)

            let collectionView = UICollectionView.init(frame: CGRectMake(CGFloat(i) * bounds.width + 5, 5, bounds.width - 10, bounds.height - 10 - 44), collectionViewLayout: flowLayout)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerClass(FNPDPhotoCell.self, forCellWithReuseIdentifier:"FNPDPhotoCell")
            collectionView.tag = 100 + i
            collectionView.backgroundColor = UIColor.clearColor()
            scrollView.addSubview(collectionView)
        }
        
        albumNameBtn = UIButton.init(frame: CGRect.init(x: 0, y: frame.height - 44, width: frame.width / 3.0, height: 44))
        let collection:PHAssetCollection = albumArray[0] as! PHAssetCollection
        albumNameBtn.setTitle(collection.localizedTitle.uppercaseString, forState: .Normal)
        albumNameBtn.setTitleColor(UIColor.init(red: 94 / 255.0, green: 99 / 255.0, blue: 106 / 255.0, alpha: 1), forState: .Normal)
        addSubview(albumNameBtn)
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tag = collectionView.tag
        let fetchResult:PHFetchResult = photoArray[tag - 100] as! PHFetchResult
        return fetchResult.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FNPDPhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("FNPDPhotoCell", forIndexPath: indexPath) as! FNPDPhotoCell
        cell.contentView.backgroundColor = UIColor.lightGrayColor()
        
        let tag = collectionView.tag
        let fetchResult:PHFetchResult = photoArray[tag - 100] as! PHFetchResult
        let asset = fetchResult[indexPath.row] as! PHAsset
        let cellSize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        let targetSize = CGSize.init(width: cellSize.width * UIScreen.mainScreen().scale, height: cellSize.height * UIScreen.mainScreen().scale)
        imageManager.requestImageForAsset(asset,
                                          targetSize: targetSize,
                                          contentMode: .AspectFill,
                                          options: nil) { (image, info) -> Void in
                                            if nil != image {
                                                cell.loadData(image!)
                                            }
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5;
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = (scrollView.contentOffset.x + bounds.width / 2) / bounds.width
        let collection:PHAssetCollection = albumArray[Int(index)] as! PHAssetCollection
        albumNameBtn.setTitle(collection.localizedTitle?.uppercaseString, forState: .Normal)
    }
}