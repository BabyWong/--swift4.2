//
//  OrderPayWayViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class OrderPayWayViewController: BaseViewController {

    fileprivate var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64 - 50))
    fileprivate var tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40 + 15 + 190 + 30))
    fileprivate let leftMargin: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildNavigationItem()
        
        buildScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        print(navigationController ?? <#default value#>)
    }

    // MARK: - Action
    fileprivate func buildNavigationItem() {
        navigationItem.title = "结算付款"
    }

    fileprivate func buildScrollView() {
        scrollView.contentSize = CGSize(width: ScreenWidth, height: 1000)
        scrollView.backgroundColor = UIColor.clear
        view.addSubview(scrollView)
        
        buildTableHeaderView()
        scrollView.addSubview(tableHeaderView)
    }
    
    fileprivate func buildTableHeaderView() {
        tableHeaderView.backgroundColor = UIColor.clear
        
        buildCouponView()
        
        buildPayView()
        
        buildCarefullyView()
    }
    
    fileprivate func buildCouponView() {
        let couponView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
        couponView.backgroundColor = UIColor.white
        tableHeaderView.addSubview(couponView)
        
        let couponImageView = UIImageView(image: UIImage(named: "v2_submit_Icon"))
        couponImageView.frame = CGRect(x: leftMargin, y: 10, width: 20, height: 20)
        couponView.addSubview(couponImageView)
        
        let couponLabel = UILabel(frame: CGRect(x: couponImageView.frame.maxX + 10, y: 0, width: ScreenWidth * 0.4, height: 40))
        couponLabel.text = "1张优惠劵"
        couponLabel.textColor = UIColor.red
        couponLabel.font = UIFont.systemFont(ofSize: 14)
        couponView.addSubview(couponLabel)
        
        let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView.frame = CGRect(x: ScreenWidth - 10 - 5, y: 15, width: 5, height: 10)
        couponView.addSubview(arrowImageView)
        
        let checkButton = UIButton(frame: CGRect(x: ScreenWidth - 60, y: 0, width: 40, height: 40))
        checkButton.setTitle("查看", for: UIControl.State())
        checkButton.setTitleColor(UIColor.black, for: UIControl.State())
        checkButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        couponView.addSubview(checkButton)
        
        buildLineView(couponView, lineFrame: CGRect(x: 0, y: 40 - 1, width: ScreenWidth, height: 1))
    }
    
    fileprivate func buildPayView() {
        let payView = UIView(frame: CGRect(x: 0, y: 55, width: ScreenWidth, height: 190))
        payView.backgroundColor = UIColor.white
        tableHeaderView.addSubview(payView)
        
        buildLabel(CGRect(x: leftMargin, y: 0, width: 150, height: 30), textColor: UIColor.lightGray, font: UIFont.systemFont(ofSize: 12), addView: payView, text: "选择支付方式")
        let payV = PayView(frame: CGRect(x: 0, y: 30, width: ScreenWidth, height: 160))
        payView.addSubview(payV)
        
        buildLineView(payView, lineFrame: CGRect(x: 0, y: 189, width: ScreenWidth, height: 1))
    }
    
    fileprivate func buildCarefullyView() {
        let carefullyView = UIView(frame: CGRect(x: 0, y: 40 + 15 + 190 + 15, width: ScreenWidth, height: 30))
        carefullyView.backgroundColor = UIColor.white
        tableHeaderView.addSubview(carefullyView)
        
        buildLabel(CGRect(x: leftMargin, y: 0, width: 150, height: 30), textColor: UIColor.lightGray, font: UIFont.systemFont(ofSize: 12), addView: carefullyView, text: "精选商品")
        
        let goodsView = ShopCartGoodsListView(frame: CGRect(x: 0, y: carefullyView.frame.maxY, width: ScreenWidth, height: 300))
        goodsView.frame.size.height = goodsView.goodsHeight
        scrollView.addSubview(goodsView)
        
        let costDetailView = CostDetailView(frame: CGRect(x: 0, y: goodsView.frame.maxY + 10, width: ScreenWidth, height: 135))
        scrollView.addSubview(costDetailView)
        
        scrollView.contentSize = CGSize(width: ScreenWidth, height: costDetailView.frame.maxY + 15)
        
        let bottomView = UIView(frame: CGRect(x: 0, y: ScreenHeight - 50 - 64, width: ScreenWidth, height: 50))
        bottomView.backgroundColor = UIColor.white
        buildLineView(bottomView, lineFrame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 1))
        view.addSubview(bottomView)
        
        buildLabel(CGRect(x: leftMargin, y: 0, width: 80, height: 50), textColor: UIColor.black, font: UIFont.systemFont(ofSize: 14), addView: bottomView, text: "实付金额:")
        var priceText = costDetailView.coupon == "0" ? UserShopCarTool.sharedUserShopCar.getAllProductsPrice() : "\((UserShopCarTool.sharedUserShopCar.getAllProductsPrice() as NSString).floatValue - 5)"
        if (priceText as NSString).floatValue < 30 {
            priceText = "\((priceText as NSString).floatValue + 8)".cleanDecimalPointZear()
        }
        buildLabel(CGRect(x: 85, y: 0, width: 150, height: 50), textColor: UIColor.red, font: UIFont.systemFont(ofSize: 14), addView: bottomView, text: "$" + priceText)
        
        let payButton = UIButton(frame: CGRect(x: ScreenWidth - 100, y: 1, width: 100, height: 49))
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        payButton.setTitle("确认付款", for: UIControl.State())
        payButton.backgroundColor = LFBNavigationYellowColor
        payButton.setTitleColor(UIColor.black, for: UIControl.State())
        bottomView.addSubview(payButton)
    }
    
    fileprivate func buildLineView(_ addView: UIView, lineFrame: CGRect) {
        let lineView = UIView(frame: lineFrame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        addView.addSubview(lineView)
    }
    
    fileprivate func buildLabel(_ labelFrame: CGRect, textColor: UIColor, font: UIFont, addView: UIView, text: String) {
        let label = UILabel(frame: labelFrame)
        label.textColor = textColor
        label.font = font
        label.text = text
        addView.addSubview(label)
    }
    
}

