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
        
        let photoDrawer = FNPhotoDrawer.init(frame: CGRectMake(0, view.bounds.height - 400, view.frame.size.width, 400))
        view.addSubview(photoDrawer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

