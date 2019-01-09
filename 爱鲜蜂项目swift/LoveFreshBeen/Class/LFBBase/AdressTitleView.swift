//
//  AdressTitleView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AdressTitleView: UIView {

    fileprivate let playLabel = UILabel()
    fileprivate let titleLabel = UILabel()
    fileprivate let arrowImageView = UIImageView(image: UIImage(named: "allowBlack"))
    var adressWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        playLabel.text = "配送至"
        playLabel.textColor = UIColor.black
        playLabel.backgroundColor = UIColor.clear
        playLabel.layer.borderWidth = 0.5
        playLabel.layer.borderColor = UIColor.black.cgColor
        playLabel.font = UIFont.systemFont(ofSize: 10)
        playLabel.sizeToFit()
        playLabel.textAlignment = NSTextAlignment.center
        playLabel.frame = CGRect(x: 0, y: (frame.size.height - playLabel.height - 2) * 0.5, width: playLabel.frame.size.width + 6, height: playLabel.frame.size.height + 2)
        addSubview(playLabel)

        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        if let adress = UserInfo.sharedUserInfo.defaultAdress() {
            if adress.address?.count > 0 {
                let adressStr = adress.address! as NSString
                if adressStr.components(separatedBy: " ").count > 1 {
                    titleLabel.text = adressStr.components(separatedBy: " ")[0]
                } else {
                    titleLabel.text = adressStr as String
                }

            } else {
                titleLabel.text = "你在哪里呀"
            }
            
        } else {
            titleLabel.text = "你在哪里呀"
        }
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: playLabel.frame.maxX + 4, y: 0, width: titleLabel.width, height: frame.height)
        addSubview(titleLabel)
        
        arrowImageView.frame = CGRect(x: titleLabel.frame.maxX + 4, y: (frame.size.height - 6) * 0.5, width: 10, height: 6)
        addSubview(arrowImageView)
        
        adressWidth = arrowImageView.frame.maxX
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ text: String) {
        let adressStr = text as NSString
        if adressStr.components(separatedBy: " ").count > 1 {
            titleLabel.text = adressStr.components(separatedBy: " ")[0]
        } else {
            titleLabel.text = adressStr as String
        }
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: playLabel.frame.maxX + 4, y: 0, width: titleLabel.width, height: frame.height)
        arrowImageView.frame = CGRect(x: titleLabel.frame.maxX + 4, y: (frame.size.height - arrowImageView.height) * 0.5, width: arrowImageView.width, height: arrowImageView.height)
        adressWidth = arrowImageView.frame.maxX
    }
}
