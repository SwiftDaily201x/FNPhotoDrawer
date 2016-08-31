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
        imageView.image = UIImage.init(named: "sreenshot0")
        imageView.userInteractionEnabled = true
        view.addSubview(imageView)
        
        let tap = UITapGestureRecognizer.init()
        tap.addTarget(self, action: #selector(tapped))
        imageView.addGestureRecognizer(tap)
    }
    
    func tapped() {
        let photoDrawer = FNPhotoDrawer.initPD()
        photoDrawer.resultRect = CGRect.init(x: 275, y: 87, width: 64, height: 64)
        photoDrawer.biong()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

