//
//  PayWayView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

enum PayWayType: Int {
    case weChat   = 0
    case qqPurse  = 1
    case aliPay   = 2
    case delivery = 3
}

class PayWayView: UIView {
    
    fileprivate var payType: PayWayType?
    fileprivate let payIconImageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 20, height: 20))
    fileprivate let payTitleLabel: UILabel = UILabel(frame: CGRect(x: 55, y: 0, width: 150, height: 40))
    fileprivate var selectedCallback: ((_ type: PayWayType) -> Void)?
    let selectedButton = UIButton(frame: CGRect(x: ScreenWidth - 10 - 16, y: (40 - 16) * 0.5, width: 16, height: 16))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        payIconImageView.contentMode = UIView.ContentMode.scaleAspectFill
        addSubview(payIconImageView)
        
        payTitleLabel.textColor = UIColor.black
        payTitleLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(payTitleLabel)
        
        selectedButton.setImage(UIImage(named: "v2_noselected"), for: UIControl.State())
        selectedButton.setImage(UIImage(named: "v2_selected"), for: UIControl.State.selected)
        selectedButton.isUserInteractionEnabled = false
        addSubview(selectedButton)
        
        let lineView = UIView(frame: CGRect(x: 15, y: 0, width: ScreenWidth - 15, height: 0.5))
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        addSubview(lineView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PayWayView.selectedPayView))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, payType: PayWayType, selectedCallBack: @escaping ((_ type: PayWayType) -> ())) {
        self.init(frame: frame)
        self.payType = payType
        
        switch payType {
        case .weChat:
            payIconImageView.image = UIImage(named: "v2_weixin")
            payTitleLabel.text = "微信支付"
            break
        case .qqPurse:
            payIconImageView.image = UIImage(named: "icon_qq")
            payTitleLabel.text = "QQ钱包"
            break
        case .aliPay:
            payIconImageView.image = UIImage(named: "zhifubaoA")
            payTitleLabel.text = "支付宝支付"
            break
        case .delivery:
            payIconImageView.image = UIImage(named: "v2_dao")
            payTitleLabel.text = "货到付款"
            break
        }
        
        self.selectedCallback = selectedCallBack
    }
    
    // MARK: Action
    @objc func selectedPayView() {
        selectedButton.isSelected = true
        if selectedCallback != nil && payType != nil {
            selectedCallback!(payType!)
        }
    }
    
}


class PayView: UIView {
    
    fileprivate var weChatView: PayWayView?
    fileprivate var qqPurseView: PayWayView?
    fileprivate var alipayView: PayWayView?
    fileprivate var deliveryView: PayWayView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        weak var tmpSelf = self
        weChatView = PayWayView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40), payType: .weChat, selectedCallBack: { (type) -> () in
            tmpSelf!.setSelectedPayView(type)
        })
        weChatView?.selectedButton.isSelected = true
        qqPurseView = PayWayView(frame: CGRect(x: 0, y: 40, width: ScreenWidth, height: 40), payType: .qqPurse, selectedCallBack: { (type) -> () in
            tmpSelf!.setSelectedPayView(type)
        })
        alipayView = PayWayView(frame: CGRect(x: 0, y: 80, width: ScreenWidth, height: 40), payType: .aliPay, selectedCallBack: { (type) -> () in
            tmpSelf!.setSelectedPayView(type)
        })
        deliveryView = PayWayView(frame: CGRect(x: 0, y: 120, width: ScreenWidth, height: 40), payType: .delivery, selectedCallBack: { (type) -> () in
            tmpSelf!.setSelectedPayView(type)
        })
        
        addSubview(weChatView!)
        addSubview(qqPurseView!)
        addSubview(alipayView!)
        addSubview(deliveryView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelectedPayView(_ type: PayWayType) {
        weChatView?.selectedButton.isSelected = type.rawValue == PayWayType.weChat.rawValue
        qqPurseView?.selectedButton.isSelected = type.rawValue == PayWayType.qqPurse.rawValue
        alipayView?.selectedButton.isSelected = type.rawValue == PayWayType.aliPay.rawValue
        deliveryView?.selectedButton.isSelected = type.rawValue == PayWayType.delivery.rawValue
    }
}





