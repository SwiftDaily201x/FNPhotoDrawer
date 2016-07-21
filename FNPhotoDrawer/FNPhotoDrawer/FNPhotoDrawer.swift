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
    var selectedAssetArray:NSMutableArray! = []
    var albumArray:NSArray! = []
    var photoArray:NSMutableArray! = []
    var collectionViewArray:NSMutableArray! = []
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var albumNameBtn:UIButton!
    var singleImageViewcontainer:UIView!
    var singleImageView:UIImageView!
    var multiImageTopShadow:UIView!
    var scrollView:UIScrollView!
    
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
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 60, width: bounds.width, height: bounds.height - 44 - 60))
        scrollView.contentSize = CGSize.init(width: bounds.width * CGFloat(albumArray.count), height: bounds.height)
        scrollView.backgroundColor = UIColor.init(white: 1.0, alpha: 1)
        scrollView.layer.shadowColor = UIColor.init(white: 0.7, alpha: 0.5).CGColor
        scrollView.layer.shadowOffset = CGSizeMake(0, 0)
        scrollView.layer.shadowOpacity = 1
        scrollView.layer.shadowRadius = 8
        scrollView.clipsToBounds = false
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        addSubview(scrollView)
        for i in 0...albumArray.count - 1 {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
            let cellWidth = floor((bounds.width - 8 * 5 - 10) / 5)
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)

            let collectionView = UICollectionView.init(frame: CGRectMake(CGFloat(i) * bounds.width + 5, 5, bounds.width - 10, scrollView.frame.height - 10), collectionViewLayout: flowLayout)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerClass(FNPDPhotoCell.self, forCellWithReuseIdentifier:"FNPDPhotoCell")
            collectionView.tag = 100 + i
            collectionView.backgroundColor = UIColor.clearColor()
            scrollView.addSubview(collectionView)
        }
        
        singleImageViewcontainer = UIView.init(frame: CGRect.init(x: (frame.width - 50) / 2, y: frame.height - 44, width: 50, height: 50))
        singleImageViewcontainer.backgroundColor = UIColor.init(white: 1.0, alpha: 1)
        singleImageViewcontainer.layer.shadowColor = UIColor.init(white: 0.7, alpha: 1).CGColor
        singleImageViewcontainer.layer.shadowOffset = CGSizeMake(0, 0);
        singleImageViewcontainer.layer.shadowOpacity = 1;
        singleImageViewcontainer.layer.shadowRadius = 10;
        addSubview(singleImageViewcontainer)
        singleImageViewcontainer.hidden = true
        
        singleImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: singleImageViewcontainer.frame.width, height: singleImageViewcontainer.frame.height))
        singleImageView.contentMode = .ScaleAspectFill
        singleImageView.layer.masksToBounds = true
        singleImageView.layer.borderColor = UIColor.init(red: 195 / 255.0, green: 222 / 255.0, blue: 234 / 255.0, alpha: 1).CGColor
        singleImageViewcontainer.addSubview(singleImageView)
        
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: frame.height - 44, width: frame.width, height: 44))
        bgView.backgroundColor = UIColor.init(white: 1.0, alpha: 1.0)
        bgView.layer.shadowColor = UIColor.init(white: 0.85, alpha: 0.5).CGColor
        bgView.layer.shadowOffset = CGSizeMake(0, -4);
        bgView.layer.shadowOpacity = 1;
        bgView.layer.shadowRadius = 4;
        addSubview(bgView)
        
        albumNameBtn = UIButton.init(frame: CGRect.init(x: 0, y: frame.height - 44, width: frame.width / 3.0, height: 44))
        let collection:PHAssetCollection = albumArray[0] as! PHAssetCollection
        albumNameBtn.setTitle(collection.localizedTitle!.uppercaseString, forState: .Normal)
        albumNameBtn.setTitleColor(UIColor.init(red: 94 / 255.0, green: 99 / 255.0, blue: 106 / 255.0, alpha: 1), forState: .Normal)
        albumNameBtn.titleLabel!.font = UIFont.init(name: "CourierNewPS-BoldMT", size: 17)
        albumNameBtn.titleLabel?.adjustsFontSizeToFitWidth
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
                                                cell.loadSelectedState(self.selectedAssetArray.containsObject(asset))
                                            }
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let tag = collectionView.tag
        let fetchResult:PHFetchResult = photoArray[tag - 100] as! PHFetchResult
        let asset = fetchResult[indexPath.row] as! PHAsset
        let cell: FNPDPhotoCell = collectionView.cellForItemAtIndexPath(indexPath) as! FNPDPhotoCell
        if selectedAssetArray.containsObject(asset) {
            selectedAssetArray.removeObject(asset)
            cell.loadSelectedState(false)
        }
        else {
            selectedAssetArray.addObject(asset)
            cell.loadSelectedState(true)
        }
        
        if selectedAssetArray.count >= 1 {
            singleImageViewcontainer.hidden = false
            singleImageView.image = cell.imageView.image
            UIView.animateWithDuration(0.5, animations: {
                self.singleImageViewcontainer.frame =  CGRect.init(x: (self.frame.width - 50) / 2, y: self.frame.height - 44 - 55, width: 50, height: 50)
            }) { (fff) in
                let a = 1
            }
        }
        else {
            UIView.animateWithDuration(0.5, animations: {
                self.singleImageViewcontainer.frame =  CGRect.init(x: (self.frame.width - 50) / 2, y: self.frame.height - 44, width: 50, height: 50)
            }) { (fff) in
                self.singleImageViewcontainer.hidden = true
            }
        }
        
        if selectedAssetArray.count >= 2 {
            UIView.animateWithDuration(0.5, animations: { 
                self.scrollView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - 44 - 60)
                }, completion: { (fff) in
                    let i = 0
            })
        }
        else {
            UIView.animateWithDuration(0.5, animations: {
                self.scrollView.frame = CGRect.init(x: 0, y: 60, width: self.bounds.width, height: self.bounds.height - 44 - 60)
                }, completion: { (fff) in
                    let i = 0
            })
        }
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
        albumNameBtn.titleLabel!.font = UIFont.init(name: "CourierNewPS-BoldMT", size: 17)
        albumNameBtn.titleLabel?.adjustsFontSizeToFitWidth
    }
}