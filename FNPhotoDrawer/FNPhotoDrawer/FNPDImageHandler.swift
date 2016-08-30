//
//  FNPDImageHandler.swift
//  FNPhotoDrawer
//
//  Created by Fnoz on 16/8/30.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

import UIKit

class FNPDImageHandler: NSObject {
    class func reSizeImage(image:UIImage,reSize:CGSize)->UIImage
    {
        UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
        image.drawInRect(CGRectMake(0, 0, reSize.width, reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }

}
