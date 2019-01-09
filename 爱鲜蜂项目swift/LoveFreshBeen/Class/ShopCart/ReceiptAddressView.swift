//
//  ReceiptAddressView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ReceiptAddressView: UIView {
    
    fileprivate let topImageView = UIImageView(image: UIImage(named: "v2_shoprail"))
    fileprivate let bottomImageView = UIImageView(image: UIImage(named: "v2_shoprail"))
    fileprivate let consigneeLabel = UILabel()
    fileprivate let phoneNumLabel = UILabel()
    fileprivate let receiptAdressLabel = UILabel()
    fileprivate let consigneeTextLabel = UILabel()
    fileprivate let phoneNumTextLabel = UILabel()
    fileprivate let receiptAdressTextLabel = UILabel()
    fileprivate let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
    fileprivate let modifyButton = UIButton()
    var modifyButtonClickCallBack: (() -> ())?
    var adress: Adress? {
        didSet {
            if adress != nil{
                consigneeTextLabel.text = adress!.accept_name! + (adress!.gender! == "1" ? " 先生" : " 女士")
                phoneNumTextLabel.text = adress!.telphone
                receiptAdressTextLabel.text = adress!.address
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(topImageView)
        addSubview(bottomImageView)
        addSubview(arrowImageView)
        
        modifyButton.setTitle("修改", for: UIControl.State())
        modifyButton.setTitleColor(UIColor.red, for: UIControl.State())
        modifyButton.addTarget(self, action: #selector(ReceiptAddressView.modifyButtonClick), for: UIControl.Event.touchUpInside)
        modifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        addSubview(modifyButton)
        
        initLabel(consigneeLabel, text: "收  货  人  ")
        initLabel(phoneNumLabel, text:  "电       话  ")
        initLabel(receiptAdressLabel, text: "收货地址  ")
        initLabel(consigneeTextLabel, text: "")
        initLabel(phoneNumTextLabel, text: "")
        initLabel(receiptAdressTextLabel, text: "")
    }
    
    convenience init(frame: CGRect, modifyButtonClickCallBack:@escaping (() -> ())) {
        self.init(frame: frame)
        
        self.modifyButtonClickCallBack = modifyButtonClickCallBack
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leftMargin: CGFloat = 15
        
        topImageView.frame = CGRect(x: 0, y: 0, width: width, height: 2)
        bottomImageView.frame = CGRect(x: 0, y: height - 2, width: width, height: 2)
        consigneeLabel.frame = CGRect(x: leftMargin, y: 10, width: consigneeLabel.width, height: consigneeLabel.height)
        consigneeTextLabel.frame = CGRect(x: consigneeLabel.frame.maxX + 5, y: consigneeLabel.y, width: 150, height: consigneeLabel.height)
        phoneNumLabel.frame = CGRect(x: leftMargin, y: consigneeLabel.frame.maxY + 5, width: phoneNumLabel.width, height: phoneNumLabel.height)
        phoneNumTextLabel.frame = CGRect(x: consigneeTextLabel.x, y: phoneNumLabel.y, width: 150, height: phoneNumLabel.height)
        receiptAdressLabel.frame = CGRect(x: leftMargin, y: phoneNumTextLabel.frame.maxY + 5, width: receiptAdressLabel.width, height: receiptAdressLabel.height)
        receiptAdressTextLabel.frame = CGRect(x: consigneeTextLabel.x, y: receiptAdressLabel.y, width: 150, height: receiptAdressLabel.height)
        modifyButton.frame = CGRect(x: width - 60, y: 0, width: 30, height: height)
        arrowImageView.frame = CGRect(x: width - 15, y: (height - arrowImageView.height) * 0.5, width: arrowImageView.width, height: arrowImageView.height)
    }
    
    fileprivate func initLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.sizeToFit()
        addSubview(label)
    }
    
    @objc func modifyButtonClick() {
        if modifyButtonClickCallBack != nil {
            modifyButtonClickCallBack!()
        }
    }
}
