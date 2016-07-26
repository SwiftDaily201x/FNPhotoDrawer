//
//  FNPDPhotoCell.swift
//  FNPhotoDrawer
//
//  Created by Fnoz on 16/7/19.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

import UIKit

class FNPDPhotoCell: UICollectionViewCell {
    var imageView:UIImageView!
    var currentState:Bool = false
    
    func loadData(image:UIImage) {
        if nil == imageView {
            imageView = UIImageView.init(frame: contentView.bounds)
            imageView.contentMode = .ScaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.layer.borderColor = UIColor.init(red: 195 / 255.0, green: 222 / 255.0, blue: 234 / 255.0, alpha: 1).CGColor
            contentView.addSubview(imageView)
        }
        imageView.image = image
    }
    
    func loadSelectedState(state:Bool, animation:Bool) {
        if animation {
            if currentState == state {
                return
            }
            currentState = state
            let tmpImageView = UIImageView.init(frame: imageView.bounds)
            tmpImageView.image = imageView.image
            tmpImageView.contentMode = .ScaleAspectFill
            tmpImageView.layer.masksToBounds = true
            contentView.addSubview(tmpImageView)
            
            if state {
                UIView.animateWithDuration(0.5, animations: {
                    tmpImageView.alpha = 0
                    self.imageView?.layer.borderWidth = 4
                }) { (fff) in
                    tmpImageView.removeFromSuperview()
                }
            }
            else {
                tmpImageView.alpha = 0
                UIView.animateWithDuration(0.5, animations: {
                    tmpImageView.alpha = 1
                }) { (fff) in
                    self.imageView?.layer.borderWidth = 0
                    tmpImageView.removeFromSuperview()
                }
            }
        }
        else {
            if state {
                self.imageView?.layer.borderWidth = 4
            }
            else {
                self.imageView?.layer.borderWidth = 0
            }
        }
    }
}
