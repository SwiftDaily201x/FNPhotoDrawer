//
//  FNPDShadowImageView.swift
//  FNPhotoDrawer
//
//  Created by Fnoz on 16/7/21.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

import UIKit

class FNPDShadowImageView: UIView {
    var imageView:UIImageView!
    var image:UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(frame: CGRect) {
        backgroundColor = UIColor.init(white: 1.0, alpha: 1)
        layer.shadowColor = UIColor.init(white: 0.7, alpha: 1).CGColor
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowOpacity = 1;
        layer.shadowRadius = 10;
        
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.init(red: 195 / 255.0, green: 222 / 255.0, blue: 234 / 255.0, alpha: 1).CGColor
        addSubview(imageView)
    }
}
