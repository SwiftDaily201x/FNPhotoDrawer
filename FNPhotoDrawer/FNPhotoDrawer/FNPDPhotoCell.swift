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
    
    func loadData(image:UIImage) {
        if nil == imageView {
            imageView = UIImageView.init(frame: contentView.bounds)
            imageView.contentMode = .ScaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 4
            imageView.layer.borderColor = UIColor.init(red: 195 / 255.0, green: 222 / 255.0, blue: 234 / 255.0, alpha: 1).CGColor
            contentView.addSubview(imageView)
        }
        imageView.image = image
    }
}
