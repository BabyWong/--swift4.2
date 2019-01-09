//
//  OrderDetailView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class OrderDetailView: UIView {
    
    var order: Order? {
        didSet {
            initLabel(orderNumberLabel, text: ("订  单  号    " + order!.order_no!))
            initLabel(consigneeLabel, text: ("收  货  码    " + order!.checknum!))
            initLabel(orderBuyTimeLabel, text: ("下单时间    " + order!.create_time!))
            initLabel(deliverTimeLabel, text: "配送时间    " + order!.accept_time!)
            initLabel(deliverWayLabel, text: "配送方式    送货上门")
            initLabel(payWayLabel, text: "支付方式    在线支付")
            if order?.postscript != nil {
                initLabel(remarksLabel, text: "备注信息    " + order!.postscript!)
            } else {
                initLabel(remarksLabel, text: "备注信息")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let orderNumberLabel = UILabel()
    let consigneeLabel = UILabel()
    let orderBuyTimeLabel = UILabel()
    let deliverTimeLabel = UILabel()
    let deliverWayLabel = UILabel()
    let payWayLabel = UILabel()
    let remarksLabel = UILabel()
    

    fileprivate func initLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = LFBTextBlackColor
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leftMargin: CGFloat = 10
        let labelWidth: CGFloat = width - 2 * leftMargin
        let labelHeight: CGFloat = 25
        
        orderNumberLabel.frame  = CGRect(x: leftMargin, y: 5, width: labelWidth, height: labelHeight)
        consigneeLabel.frame    = CGRect(x: leftMargin, y: orderNumberLabel.frame.maxY, width: labelWidth, height: labelHeight)
        orderBuyTimeLabel.frame = CGRect(x: leftMargin, y: consigneeLabel.frame.maxY, width: labelWidth, height: labelHeight)
        deliverTimeLabel.frame  = CGRect(x: leftMargin, y: orderBuyTimeLabel.frame.maxY, width: labelWidth, height: labelHeight)
        deliverWayLabel.frame   = CGRect(x: leftMargin, y: deliverTimeLabel.frame.maxY, width: labelWidth, height: labelHeight)
        payWayLabel.frame       = CGRect(x: leftMargin, y: deliverWayLabel.frame.maxY, width: labelWidth, height: labelHeight)
        remarksLabel.frame      = CGRect(x: leftMargin, y: payWayLabel.frame.maxY, width: labelWidth, height: labelHeight)
    }
}
