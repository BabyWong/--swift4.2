//
//  ShopCartSupermarketTableFooterView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ShopCartSupermarketTableFooterView: UIView {
    
    fileprivate let titleLabel      = UILabel()
    let priceLabel              = UILabel()
    fileprivate let determineButton = UIButton()
    fileprivate let backView        = UIView()
    weak var delegate: ShopCartSupermarketTableFooterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ShopCartRowHeight)
        backView.backgroundColor = UIColor.white
        addSubview(backView)
        
        titleLabel.text = "共$ "
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.sizeToFit()
        titleLabel.textColor = UIColor.red
        titleLabel.frame = CGRect(x: 15, y: 0, width: titleLabel.width, height: ShopCartRowHeight)
        addSubview(titleLabel)
        
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = UIColor.red
        priceLabel.frame = CGRect(x: titleLabel.frame.maxX, y: 0, width: ScreenWidth * 0.5, height: ShopCartRowHeight)
        priceLabel.text = UserShopCarTool.sharedUserShopCar.getAllProductsPrice()
        addSubview(priceLabel)
        
        determineButton.frame = CGRect(x: ScreenWidth - 90, y: 0, width: 90, height: ShopCartRowHeight)
        determineButton.backgroundColor = LFBNavigationYellowColor
        determineButton.setTitle("选好了", for: UIControl.State())
        determineButton.setTitleColor(UIColor.black, for: UIControl.State())
        determineButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        determineButton.addTarget(self, action: #selector(ShopCartSupermarketTableFooterView.determineButtonClick), for: .touchUpInside)
        addSubview(determineButton)
        
        addSubview(lineView(CGRect(x: 0, y: ShopCartRowHeight - 0.5, width: ScreenWidth, height: 0.5)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPriceLabel(_ price: Double) {
        priceLabel.text = "\(price)".cleanDecimalPointZear()
    }
    
    fileprivate func lineView(_ frame: CGRect) -> UIView {
        let lineView = UIView(frame: frame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        return lineView
    }
    
    @objc func determineButtonClick() {
        delegate?.supermarketTableFooterDetermineButtonClick()
    }
}

protocol ShopCartSupermarketTableFooterViewDelegate: NSObjectProtocol {
    
    func supermarketTableFooterDetermineButtonClick();
}
