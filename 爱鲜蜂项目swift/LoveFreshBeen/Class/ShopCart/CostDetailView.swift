//
//  CostDetailView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class CostDetailView: UIView {
    
    var coupon: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        buildLabel(CGRect(x: 15, y: 0, width: 150, height: 30), text: "费用明细", font: UIFont.systemFont(ofSize: 12), textColor: UIColor.lightGray, textAlignment: NSTextAlignment.left)
        
        let lineView1 = UIView(frame: CGRect(x: 15, y: 30 - 0.5, width: ScreenWidth - 15, height: 0.5))
        lineView1.backgroundColor = UIColor.black
        lineView1.alpha = 0.1
        addSubview(lineView1)
        
        buildLabel(CGRect(x: 15, y: 35, width: 100, height: 20), text: "商品总额", font: UIFont.systemFont(ofSize: 14), textColor: UIColor.black, textAlignment: NSTextAlignment.left)
        buildLabel(CGRect(x: 100, y: 35, width: ScreenWidth - 110, height: 20), text: "$" + UserShopCarTool.sharedUserShopCar.getAllProductsPrice(), font: UIFont.systemFont(ofSize: 14), textColor: UIColor.black, textAlignment: NSTextAlignment.right)
        buildLabel(CGRect(x: 15, y: 60, width: 100, height: 20), text: "配送费", font: UIFont.systemFont(ofSize: 14), textColor: UIColor.black, textAlignment: NSTextAlignment.left)
        
        var distribution: String?
        
        if (UserShopCarTool.sharedUserShopCar.getAllProductsPrice() as NSString).floatValue >= 30 {
            distribution = "0"
            coupon = "5"
        } else {
            distribution = "8"
            coupon = "0"
        }
        
        buildLabel(CGRect(x: 100, y: 60, width: ScreenWidth - 110, height: 20), text: "$" + distribution!, font: UIFont.systemFont(ofSize: 14), textColor: UIColor.black, textAlignment: NSTextAlignment.right)
        buildLabel(CGRect(x: 15, y: 85, width: 100, height: 20), text: "服务费", font: UIFont.systemFont(ofSize: 14), textColor: UIColor.black, textAlignment: NSTextAlignment.left)
        buildLabel(CGRect(x: 100, y: 85, width: ScreenWidth - 110, height: 20), text: "$0", font: UIFont.systemFont(ofSize: 14), textColor: UIColor.black, textAlignment: NSTextAlignment.right)
        buildLabel(CGRect(x: 15, y: 110, width: 100, height: 20), text: "优惠劵", font: UIFont.systemFont(ofSize: 14), textColor: UIColor.black, textAlignment: NSTextAlignment.left)
        buildLabel(CGRect(x: 100, y: 110, width: ScreenWidth - 110, height: 20), text: "$" + coupon!, font: UIFont.systemFont(ofSize: 14), textColor: UIColor.black, textAlignment: NSTextAlignment.right)
        
        let lineView2 = UIView(frame: CGRect(x: 0, y: 135 - 1, width: ScreenWidth, height: 1))
        lineView2.backgroundColor = UIColor.black
        lineView2.alpha = 0.1
        addSubview(lineView2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildLabel(_ labelFrame: CGRect, text: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
        let label = UILabel(frame: labelFrame)
        label.text = text
        label.textAlignment = textAlignment
        label.font = font
        label.textColor = textColor
        addSubview(label)
    }
    
    
}
