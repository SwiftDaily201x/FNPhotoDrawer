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
    var albumArray:NSMutableArray! = []
    var photoArray:NSMutableArray! = []
    var collectionViewArray:NSMutableArray! = []
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var albumNameLabel:UILabel!
    var singleImageView:FNPDShadowImageView!
    var scrollView:UIScrollView!
    var scrollViewShadow:UIView!
    var selectedCollectionView:UICollectionView!
    var resultAnimationView:FNPDPhotoQuire!
    var resultRect:CGRect! = CGRectZero
    var newWindow:UIWindow!
    
    class func initPD() -> FNPhotoDrawer {
        let pd = FNPhotoDrawer.init(frame: CGRectMake(0, (UIApplication.sharedApplication().keyWindow?.bounds.height)! - 440, (UIApplication.sharedApplication().keyWindow?.bounds.width)!, 440))
        return pd
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
        initView(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData() {
        albumArray = FNPDPhotoFetcher.init().fetchAlbum().mutableCopy() as! NSMutableArray
        for album in albumArray.copy() as! NSArray {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchOptions.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.Image.rawValue)
            
            let assetsFetchResults = PHAsset.fetchAssetsInAssetCollection(album as! PHAssetCollection, options: fetchOptions)
            if assetsFetchResults.count == 0 {
                albumArray.removeObject(album)
            }
        }
        for album in albumArray {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchOptions.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.Image.rawValue)
            
            let assetsFetchResults = PHAsset.fetchAssetsInAssetCollection(album as! PHAssetCollection, options: fetchOptions)
            photoArray.addObject(assetsFetchResults)
        }
    }
    
    func initView(frame: CGRect) {
        resultAnimationView = FNPDPhotoQuire.init(frame: CGRect.init(x: (frame.width - 60) * 0.5, y: 0, width: 60, height: 60))
        resultAnimationView.hidden = true
        addSubview(resultAnimationView)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)
        let cellWidth = 45
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        selectedCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: bounds.height - 44 - 60, width: bounds.width, height: 60), collectionViewLayout: flowLayout)
        selectedCollectionView.backgroundColor = UIColor.whiteColor()
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        selectedCollectionView.registerClass(FNPDPhotoCell.self, forCellWithReuseIdentifier:"FNPDPhotoCell")
        addSubview(selectedCollectionView)
        
        scrollViewShadow = UIView.init(frame: CGRect.init(x: 0, y: 60, width: bounds.width, height: bounds.height - 44 - 60))
        scrollViewShadow.backgroundColor = UIColor.init(white: 1.0, alpha: 1)
        scrollViewShadow.layer.shadowColor = UIColor.init(white: 0.7, alpha: 0.5).CGColor
        scrollViewShadow.layer.shadowOffset = CGSizeMake(0, 0)
        scrollViewShadow.layer.shadowOpacity = 1
        scrollViewShadow.layer.shadowRadius = 8
        addSubview(scrollViewShadow)
        
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 60, width: bounds.width, height: bounds.height - 44 - 60))
        scrollView.contentSize = CGSize.init(width: bounds.width * CGFloat(albumArray.count), height: scrollView.bounds.height)
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.bounces = false
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
            collectionView.bounces = false
            collectionViewArray.addObject(collectionView)
            scrollView.addSubview(collectionView)
        }
        
        singleImageView = FNPDShadowImageView.init(frame: CGRect.init(x: (frame.width - 50) / 2, y: frame.height - 44, width: 50, height: 50))
        addSubview(singleImageView)
        singleImageView.hidden = true
        
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: frame.height - 44, width: frame.width, height: 44))
        bgView.backgroundColor = UIColor.init(white: 1.0, alpha: 1.0)
        bgView.layer.shadowColor = UIColor.init(white: 0.85, alpha: 0.5).CGColor
        bgView.layer.shadowOffset = CGSizeMake(0, -4);
        bgView.layer.shadowOpacity = 1;
        bgView.layer.shadowRadius = 4;
        addSubview(bgView)
        
        albumNameLabel = UILabel.init(frame: CGRect.init(x: 12, y: frame.height - 44, width: frame.width / 3.0, height: 44))
        let collection:PHAssetCollection = albumArray[0] as! PHAssetCollection
        albumNameLabel.text = collection.localizedTitle!.uppercaseString
        albumNameLabel.textColor = UIColor.init(red: 94 / 255.0, green: 99 / 255.0, blue: 106 / 255.0, alpha: 1)
        albumNameLabel.font = UIFont.init(name: "CourierNewPS-BoldMT", size: 17)
        albumNameLabel.adjustsFontSizeToFitWidth = true
        addSubview(albumNameLabel)
        
        let okBtn = UIButton.init(frame: CGRect.init(x: frame.width - frame.width / 3.0 + 30, y: frame.height - 44, width: frame.width / 3.0, height: 44))
        okBtn.setTitle("OK", forState: .Normal)
        okBtn.setTitleColor(UIColor.init(red: 94 / 255.0, green: 99 / 255.0, blue: 106 / 255.0, alpha: 1), forState: .Normal)
        okBtn.titleLabel?.font = UIFont.init(name: "CourierNewPS-BoldMT", size: 17)
        okBtn.addTarget(self, action: #selector(okBtnClicked), forControlEvents: .TouchUpInside)
        addSubview(okBtn)        
    }
    
    func biong() {
        self.newWindow = UIWindow.init(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
        self.newWindow.windowLevel = UIWindowLevelStatusBar + 1
        let vc = UIViewController.init()
        vc.view.backgroundColor = UIColor.clearColor()
        self.newWindow.rootViewController = vc
        self.newWindow.makeKeyAndVisible()
        vc.view.addSubview(self)
        
        UIView.animateWithDuration(0.5) { 
            vc.view.backgroundColor = UIColor.init(white: 1, alpha: 0.4)
        }
    }
    
    func okBtnClicked() {
        resultAnimationView.hidden = false
        if selectedAssetArray.count == 0 {
            dismiss()
        }
        else if selectedAssetArray.count == 1 {
            
        }
        else {
            let asset = selectedAssetArray[0] as! PHAsset
            let targetSize = CGSize.init(width: 60 * UIScreen.mainScreen().scale, height: 60 * UIScreen.mainScreen().scale)
            imageManager.requestImageForAsset(asset,
                                              targetSize: targetSize,
                                              contentMode: .AspectFill,
                                              options: nil) { (image, info) -> Void in
                                                if nil != image {
                                                    self.resultAnimationView.firstImage = image
                                                }
            }
            resultAnimationView.imageNum = selectedAssetArray.count
            UIView.animateWithDuration(0.5, animations: { 
                self.resultAnimationView.frame = CGRect.init(x: self.resultAnimationView.frame.minX, y: -7.5, width: self.resultAnimationView.frame.width, height: self.resultAnimationView.frame.height)
                self.scrollViewShadow.frame = CGRect.init(x: 0, y: 60, width: self.bounds.width, height: self.bounds.height - 44 - 60)
                self.scrollView.frame = CGRect.init(x: 0, y: 60, width: self.bounds.width, height: self.bounds.height - 44 - 60)
                }, completion: { (fff) in
                    self.resultAnimationView.fold()
                    UIView.animateWithDuration(0.5, delay: 0.5, options: .CurveEaseInOut, animations: { 
                        self.resultAnimationView.frame = CGRect.init(x: self.resultRect.origin.x - (self.resultAnimationView.frame.width - self.resultAnimationView.frame.height) * 0.5 * (1.0 * self.resultRect.size.height / self.resultAnimationView.frame.height), y: self.resultRect.origin.y, width: self.resultRect.width, height: self.resultRect.height)
                        }, completion: { (fff) in
                            let i = 0
                    })
            })
        }
    }
    
    func dismiss() {
        
    }
    
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag < 100 {
            return selectedAssetArray.count
        }
        else {
            let tag = collectionView.tag
            let fetchResult:PHFetchResult = photoArray[tag - 100] as! PHFetchResult
            return fetchResult.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.tag < 100 {
            let cell: FNPDPhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("FNPDPhotoCell", forIndexPath: indexPath) as! FNPDPhotoCell
            cell.contentView.backgroundColor = UIColor.lightGrayColor()
            
            let asset = selectedAssetArray[indexPath.row] as! PHAsset
            let cellSize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
            let targetSize = CGSize.init(width: cellSize.width * UIScreen.mainScreen().scale, height: cellSize.height * UIScreen.mainScreen().scale)
            imageManager.requestImageForAsset(asset,
                                              targetSize: targetSize,
                                              contentMode: .AspectFill,
                                              options: nil) { (image, info) -> Void in
                                                if nil != image {
                                                    cell.loadData(image!)
                                                    cell.loadSelectedState(self.selectedAssetArray.containsObject(asset), animation: false)
                                                }
            }
            return cell
        }
        else {
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
                                                    cell.loadSelectedState(self.selectedAssetArray.containsObject(asset), animation: false)
                                                }
            }
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var isDelete = false
        var theAsset = PHAsset.init()
        if collectionView.tag < 100 {
            isDelete = true
            theAsset = selectedAssetArray[indexPath.row] as! PHAsset
            selectedAssetArray.removeObjectAtIndex(indexPath.row)
            selectedCollectionView.deleteItemsAtIndexPaths([indexPath])
        }
        else {
            let tag = collectionView.tag
            let fetchResult:PHFetchResult = photoArray[tag - 100] as! PHFetchResult
            let asset = fetchResult[indexPath.row] as! PHAsset
            theAsset = asset
            let cell: FNPDPhotoCell = collectionView.cellForItemAtIndexPath(indexPath) as! FNPDPhotoCell
            if selectedAssetArray.containsObject(asset) {
                let index = selectedAssetArray.indexOfObject(asset)
                isDelete = true
                selectedAssetArray.removeObject(asset)
                selectedCollectionView.deleteItemsAtIndexPaths([NSIndexPath.init(forRow: index, inSection: 0)])
                cell.loadSelectedState(false, animation: true)
            }
            else {
                if selectedAssetArray.count >= 7 {
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 2
                    animation.autoreverses = true
                    animation.fromValue = NSValue(CGPoint: CGPointMake(selectedCollectionView.center.x - 5, selectedCollectionView.center.y))
                    animation.toValue = NSValue(CGPoint: CGPointMake(selectedCollectionView.center.x + 5, selectedCollectionView.center.y))
                    selectedCollectionView.layer.addAnimation(animation, forKey: "position")
                    return
                }
                selectedAssetArray.addObject(asset)
                cell.loadSelectedState(true, animation: true)
                selectedCollectionView.insertItemsAtIndexPaths([NSIndexPath.init(forRow: selectedAssetArray.count - 1, inSection: 0)])
            }
        }
        if selectedAssetArray.count == 1 {
            singleImageView.hidden = false
            let cellSize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
            let targetSize = CGSize.init(width: cellSize.width * UIScreen.mainScreen().scale, height: cellSize.height * UIScreen.mainScreen().scale)
            imageManager.requestImageForAsset((selectedAssetArray[0] as! PHAsset),
                                              targetSize: targetSize,
                                              contentMode: .AspectFill,
                                              options: nil) { (image, info) -> Void in
                                                if nil != image {
                                                    self.singleImageView.image = image
                                                }
            }
            UIView.animateWithDuration(0.5, animations: {
                self.singleImageView.frame =  CGRect.init(x: (self.frame.width - 50) / 2, y: self.frame.height - 44 - 55, width: 50, height: 50)
            }) { (fff) in
                print("")
            }
        }
        else {
            UIView.animateWithDuration(0.5, animations: {
                self.singleImageView.frame =  CGRect.init(x: (self.frame.width - 50) / 2, y: self.frame.height - 44, width: 50, height: 50)
            }) { (fff) in
                self.singleImageView.hidden = true
            }
        }
        
        if selectedAssetArray.count >= 2 {
            UIView.animateWithDuration(0.5, animations: {
                self.scrollViewShadow.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - 44 - 60)
                self.scrollView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - 44 - 60)
                self.singleImageView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                }, completion: { (fff) in
                    print("")
            })
        }
        else {
            UIView.animateWithDuration(0.5, animations: {
                self.scrollViewShadow.frame = CGRect.init(x: 0, y: 60, width: self.bounds.width, height: self.bounds.height - 44 - 60)
                self.scrollView.frame = CGRect.init(x: 0, y: 60, width: self.bounds.width, height: self.bounds.height - 44 - 60)
                self.singleImageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.singleImageView.imageView.frame = self.singleImageView.bounds //for after scale to 0.9, then scale to 1.0, the content will not recover to original state, this will fix that.
                }, completion: { (fff) in
                    print("")
            })
        }
        for i in 0...photoArray.count - 1 {
            let fetchResult:PHFetchResult = photoArray[i] as! PHFetchResult
            let theCollectionView = collectionViewArray[i]
            if fetchResult.containsObject(theAsset) {
                let theIndex = fetchResult.indexOfObject(theAsset)
                if theIndex < fetchResult.count {
                    let theCell = theCollectionView.cellForItemAtIndexPath(NSIndexPath.init(forRow: theIndex, inSection: 0)) as? FNPDPhotoCell
                    theCell?.loadSelectedState(!isDelete, animation: false)
                }
            }
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
        albumNameLabel.text = collection.localizedTitle!.uppercaseString
    }
}