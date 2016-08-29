//
//  FNPDPhotoQuire.swift
//  FNPhotoDrawer
//
//  Created by Fnoz on 16/8/29.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

import UIKit

class FNPDPhotoQuire: UIView {
    var rightLines:NSMutableArray! = []
    var firstImageView:UIImageView!
    var firstImage:UIImage! {
        didSet {
            firstImageView.image = firstImage
        }
    }
    
    var imageNum:NSInteger = 0 {
        didSet {
            for line in rightLines {
                (line as! UIView).removeFromSuperview()
            }
            rightLines.removeAllObjects()
            if imageNum > 1 {
                for i in 0...imageNum - 2 {
                    let lineRect = CGRect.init(x: firstImageView.frame.maxX + CGFloat((i + 1) * 7) - 2, y: 0.5 * frame.height * CGFloat(1 - pow(0.9, Double(i + 1))), width: 2, height: frame.height * CGFloat(pow(0.9, Double(i + 1))))
                    let line = UIView.init(frame: lineRect)
                    line.backgroundColor = UIColor.init(white: 0.6, alpha: pow(0.8, CGFloat(i + 1)))
                    line.layer.cornerRadius = 1
                    rightLines.addObject(line)
                    addSubview(line)
                }
            }
            
            let oriCenter = center
            frame = CGRect.init(x: 0, y: 0, width: frame.height + 8.0 * CGFloat(imageNum - 1), height: frame.height)
            center = oriCenter
            
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
        firstImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(firstImageView)
    }
}
