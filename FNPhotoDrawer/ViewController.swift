//
//  ViewController.swift
//  FNPhotoDrawer
//
//  Created by Fnoz on 16/7/18.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var albumArray:NSArray! = []
    var photoArray:NSMutableArray! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView.init(frame: view.bounds)
//        imageView.image = UIImage.init(named: "sreenshot0")
        view.addSubview(imageView)
        
        let photoDrawer = FNPhotoDrawer.init(frame: CGRectMake(0, view.bounds.height - 440, view.frame.size.width, 440))
        view.addSubview(photoDrawer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

