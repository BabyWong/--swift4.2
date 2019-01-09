//
//  MineHeadView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class MineHeadView: UIImageView {
    
    let setUpBtn: UIButton = UIButton(type: .custom)
    let iconView: IconView = IconView()
    var buttonClick:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage(named: "v2_my_avatar_bg")
        setUpBtn.setImage(UIImage(named: "v2_my_settings_icon"), for: UIControl.State())
        setUpBtn.addTarget(self, action: #selector(setUpButtonClick), for: .touchUpInside)
        addSubview(setUpBtn)
        addSubview(iconView)
        self.isUserInteractionEnabled = true
    }
    
    convenience init(frame: CGRect, settingButtonClick:@escaping (() -> Void)) {
        self.init(frame: frame)
        buttonClick = settingButtonClick
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconViewWH: CGFloat = 150
        iconView.frame = CGRect(x: (width - 150) * 0.5, y: 30, width: iconViewWH, height: iconViewWH)
        
        setUpBtn.frame = CGRect(x: width - 50, y: 10, width: 50, height: 50)
    }
    
    @objc func setUpButtonClick() {
        buttonClick?()
    }
}


class IconView: UIView {
    
    var iconImageView: UIImageView!
    var phoneNum: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconImageView = UIImageView(image: UIImage(named: "v2_my_avatar"))
        addSubview(iconImageView)
        
        phoneNum = UILabel()
        phoneNum.text = "18612348765"
        phoneNum.font = UIFont.boldSystemFont(ofSize: 18)
        phoneNum.textColor = UIColor.white
        phoneNum.textAlignment = .center
        addSubview(phoneNum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(x: (width - iconImageView.size.width) * 0.5, y: 0, width: iconImageView.size.width, height: iconImageView.size.height)
        phoneNum.frame = CGRect(x: 0, y: iconImageView.frame.maxY + 5, width: width, height: 30)
    }
}
