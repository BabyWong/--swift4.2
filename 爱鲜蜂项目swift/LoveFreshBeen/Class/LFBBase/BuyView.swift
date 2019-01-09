//
//  BuyView.swift
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

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class BuyView: UIView {
    
    var clickAddShopCar: (() -> ())?
    var zearIsShow = false
    
    /// 添加按钮
    fileprivate lazy var addGoodsButton: UIButton = {
        let addGoodsButton = UIButton(type: .custom)
        addGoodsButton.setImage(UIImage(named: "v2_increase"), for: UIControl.State())
        addGoodsButton.addTarget(self, action: #selector(BuyView.addGoodsButtonClick), for: .touchUpInside)
        return addGoodsButton
        }()
    
    /// 删除按钮
    fileprivate lazy var reduceGoodsButton: UIButton = {
        let reduceGoodsButton = UIButton(type: .custom)
        reduceGoodsButton.setImage(UIImage(named: "v2_reduce")!, for: UIControl.State())
        reduceGoodsButton.addTarget(self, action: #selector(BuyView.reduceGoodsButtonClick), for: .touchUpInside)
        reduceGoodsButton.isHidden = false
        return reduceGoodsButton
        }()
    
    /// 购买数量
    fileprivate lazy var buyCountLabel: UILabel = {
        let buyCountLabel = UILabel()
        buyCountLabel.isHidden = false
        buyCountLabel.text = "0"
        buyCountLabel.textColor = UIColor.black
        buyCountLabel.textAlignment = NSTextAlignment.center
        buyCountLabel.font = HomeCollectionTextFont
        return buyCountLabel
        }()
    
    /// 补货中
    fileprivate lazy var supplementLabel: UILabel = {
        let supplementLabel = UILabel()
        supplementLabel.text = "补货中"
        supplementLabel.isHidden = true
        supplementLabel.textAlignment = NSTextAlignment.right
        supplementLabel.textColor = UIColor.red
        supplementLabel.font = HomeCollectionTextFont
        return supplementLabel
        }()
    
    fileprivate var buyNumber: Int = 0 {
        willSet {
            if newValue > 0 {
                reduceGoodsButton.isHidden = false
                buyCountLabel.text = "\(newValue)"
            } else {
                reduceGoodsButton.isHidden = true
                buyCountLabel.isHidden = false
                buyCountLabel.text = "\(newValue)"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(addGoodsButton)
        addSubview(reduceGoodsButton)
        addSubview(buyCountLabel)
        addSubview(supplementLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buyCountWidth: CGFloat = 25
        addGoodsButton.frame = CGRect(x: width - height - 2, y: 0, width: height, height: height)
        buyCountLabel.frame = CGRect(x: addGoodsButton.frame.minX - buyCountWidth, y: 0, width: buyCountWidth, height: height)
        reduceGoodsButton.frame = CGRect(x: buyCountLabel.frame.minX - height, y: 0, width: height, height: height)
        supplementLabel.frame = CGRect(x: reduceGoodsButton.frame.minX, y: 0, width: height + buyCountWidth + height, height: height)
    }
    
    /// 商品模型Set方法
    var goods: Goods? {
        didSet {
            buyNumber = goods!.userBuyNumber
            
            if goods?.number <= 0 {
                showSupplementLabel()
            } else {
                hideSupplementLabel()
            }
            if 0 == buyNumber {
                reduceGoodsButton.isHidden = true && !zearIsShow
                buyCountLabel.isHidden = true && !zearIsShow
            } else {
                reduceGoodsButton.isHidden = false
                buyCountLabel.isHidden = false
            }
        }
    }
    
    /// 显示补货中
    fileprivate func showSupplementLabel() {
        supplementLabel.isHidden = false
        addGoodsButton.isHidden = true
        reduceGoodsButton.isHidden = true
        buyCountLabel.isHidden = true
    }
    
    /// 隐藏补货中,显示添加按钮
    fileprivate func hideSupplementLabel() {
        supplementLabel.isHidden = true
        addGoodsButton.isHidden = false
        reduceGoodsButton.isHidden = false
        buyCountLabel.isHidden = false
    }
    
    // MARK: - Action
    @objc func addGoodsButtonClick() {
        
        if buyNumber >= goods?.number {
            NotificationCenter.default.post(name: Notification.Name(rawValue: HomeGoodsInventoryProblem), object: goods?.name)
            return
        }
        
        reduceGoodsButton.isHidden = false
        buyNumber += 1
        goods?.userBuyNumber = buyNumber
        buyCountLabel.text = "\(buyNumber)"
        buyCountLabel.isHidden = false
        
        if clickAddShopCar != nil {
            clickAddShopCar!()
        }
        
        ShopCarRedDotView.sharedRedDotView.addProductToRedDotView(true)
        UserShopCarTool.sharedUserShopCar.addSupermarkProductToShopCar(goods!)
        NotificationCenter.default.post(name: Notification.Name(rawValue: LFBShopCarBuyPriceDidChangeNotification), object: nil, userInfo: nil)
    }
    
    @objc func reduceGoodsButtonClick() {
        if buyNumber <= 0 {
            return
        }
        
        buyNumber -= 1
        goods?.userBuyNumber = buyNumber
        if buyNumber == 0 {
            reduceGoodsButton.isHidden = true && !zearIsShow
            buyCountLabel.isHidden = true && !zearIsShow
            buyCountLabel.text = zearIsShow ? "0" : ""
            UserShopCarTool.sharedUserShopCar.removeSupermarketProduct(goods!)
        } else {
            buyCountLabel.text = "\(buyNumber)"
        }
        
        ShopCarRedDotView.sharedRedDotView.reduceProductToRedDotView(true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: LFBShopCarBuyPriceDidChangeNotification), object: nil, userInfo: nil)
    }
}


