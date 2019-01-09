//
//  NewCharacteristicsCell.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class GuideCell: UICollectionViewCell {
    
    fileprivate let newImageView = UIImageView(frame: ScreenBounds)
    fileprivate let nextButton = UIButton(frame: CGRect(x: (ScreenWidth - 100) * 0.5, y: ScreenHeight - 110, width: 100, height: 33))
    
    var newImage: UIImage? {
        didSet {
            newImageView.image = newImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        newImageView.contentMode = UIView.ContentMode.scaleAspectFill
        contentView.addSubview(newImageView)
        
        nextButton.setBackgroundImage(UIImage(named: "icon_next"), for: UIControl.State())
        nextButton.addTarget(self, action: #selector(GuideCell.nextButtonClick), for: UIControl.Event.touchUpInside)
        nextButton.isHidden = true
        contentView.addSubview(nextButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNextButtonHidden(_ hidden: Bool) {
        nextButton.isHidden = hidden
    }
    
    @objc func nextButtonClick() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: GuideViewControllerDidFinish), object: nil)
    }
}
