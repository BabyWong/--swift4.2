//
//  ProgressHUDManager.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit


class ProgressHUDManager {
    
    class func setBackgroundColor(_ color: UIColor) {
        SVProgressHUD.setBackgroundColor(color)
    }
    
    class func setForegroundColor(_ color: UIColor) {
        SVProgressHUD.setForegroundColor(color)
    }
    
    class func setSuccessImage(_ image: UIImage) {
        SVProgressHUD.setSuccessImage(image)
    }
    
    class func setErrorImage(_ image: UIImage) {
        SVProgressHUD.setErrorImage(image)
    }
    
    class func setFont(_ font: UIFont) {
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16))
    }

    class func showImage(_ image: UIImage, status: String) {
        SVProgressHUD.show(image, status: status)
    }
    
    class func show() {
        SVProgressHUD.show()
    }
    
    class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    class func showWithStatus(_ status: String) {
        SVProgressHUD.show(withStatus: status)
    }
    
    class func isVisible() -> Bool {
       return SVProgressHUD.isVisible()
    }
    
    class func showSuccessWithStatus(_ string: String) {
        SVProgressHUD.showSuccess(withStatus: string)
    }
}
