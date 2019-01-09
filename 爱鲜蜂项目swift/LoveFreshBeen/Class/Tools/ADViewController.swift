//
//  ADViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ADViewController: UIViewController {
    
    fileprivate lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.frame = ScreenBounds
        return backImageView
        }()
    
    var imageName: String? {
        didSet {
            var placeholderImageName: String?
            switch UIDevice.currentDeviceScreenMeasurement() {
            case 3.5:
                placeholderImageName = "iphone4"
            case 4.0:
                placeholderImageName = "iphone5"
            case 4.7:
                placeholderImageName = "iphone6"
            default:
                placeholderImageName = "iphone6s"
            }
            
            backImageView.sd_setImage(with: URL(string: imageName!), placeholderImage: UIImage(named: placeholderImageName!)) { (image, error, _, _) -> Void in
                if error != nil {
                    //加载广告失败
                    print("加载广告失败")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: ADImageLoadFail), object: nil)
                }
                
                if image != nil {
                    let time = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time, execute: { () -> Void in
                        
                        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
                        
                        let time1 = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time1, execute: { () -> Void in
                            NotificationCenter.default.post(name: Notification.Name(rawValue: ADImageLoadSecussed), object: image)
                        })
                        
                    })
                } else {
                    //加载广告失败
                    print("加载广告失败")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: ADImageLoadFail), object: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backImageView)
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
    }
}
