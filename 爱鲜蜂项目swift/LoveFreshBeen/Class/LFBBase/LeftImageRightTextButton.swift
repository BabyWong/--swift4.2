//
//  LeftImageRightTextButton.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class LeftImageRightTextButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        imageView?.contentMode = UIView.ContentMode.center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRect(x: 0, y: (height - (imageView?.size.height)!) * 0.5, width: (imageView?.size.width)!, height: (imageView?.size.height)!)
        titleLabel?.frame = CGRect(x: (imageView?.size.width)! + 10, y: 0, width: width - (imageView?.size.width)! - 10, height: height)
    }
}
