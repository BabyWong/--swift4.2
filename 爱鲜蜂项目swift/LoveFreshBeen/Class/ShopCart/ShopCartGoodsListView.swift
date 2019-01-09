//
//  ShopCartGoodsListView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ShopCartGoodsListView: UIView {
    
    var goodsHeight: CGFloat = 0

    fileprivate var lastViewY: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        let goodses = UserShopCarTool.sharedUserShopCar.getShopCarProducts()
        
        for i in 0..<goodses.count {
            let goods = goodses[i]
            
            buildLineView(CGRect(x: 15, y: lastViewY, width: ScreenWidth - 15, height: 0.5))
            
            if goods.pm_desc != "买一赠一" {
                let goodsDetailView = PayGoodsDetailView(frame: CGRect(x: 0, y: lastViewY + 10, width: ScreenWidth, height: 20))
                goodsDetailView.goods = goods
                addSubview(goodsDetailView)
                lastViewY += 40
                goodsHeight += 40
            } else {
                let goodsDetailView = PayGoodsDetailView(frame: CGRect(x: 0, y: lastViewY + 10, width: ScreenWidth, height: 20))
                goods.pm_desc = ""
                goodsDetailView.goods = goods
                addSubview(goodsDetailView)
                lastViewY += 30
                
                let giftView = PayGoodsDetailView(frame: CGRect(x: 0, y: lastViewY, width: ScreenWidth, height: 20))
                goods.pm_desc = "买一赠一"
                giftView.goods = goods
                addSubview(giftView)
                lastViewY += 30
                
                goodsHeight += 60
            }
        }
        
        let lineView = UIView(frame: CGRect(x: 15, y: lastViewY - 0.5, width: ScreenWidth - 15, height: 0.5))
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        addSubview(lineView)
        
        goodsHeight += 40
        
        let finePriceLabel = UILabel(frame: CGRect(x: 50, y: lastViewY, width: ScreenWidth - 60, height: 40))
        finePriceLabel.textAlignment = NSTextAlignment.right
        finePriceLabel.textColor = UIColor.red
        finePriceLabel.font = UIFont.systemFont(ofSize: 14)
        finePriceLabel.text = "合计:$" + UserShopCarTool.sharedUserShopCar.getAllProductsPrice()
        addSubview(finePriceLabel)
        
        let lineView1 = UIView(frame: CGRect(x: 0, y: goodsHeight - 1, width: ScreenWidth, height: 1))
        lineView1.backgroundColor = UIColor.black
        lineView1.alpha = 0.1
        addSubview(lineView1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    fileprivate func buildLineView(_ lineFrame: CGRect) {
        let lineView = UIView(frame: lineFrame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        
        addSubview(lineView)
    }
}


class PayGoodsDetailView: UIView {
    
    let titleLabel = UILabel()
    let numberLabel = UILabel()
    let priceLabel = UILabel()
    let giftImageView = UIImageView()
    
    var isShowImageView = false
    
    var goods: Goods? {
        didSet {
            if goods?.is_xf == 1 {
                titleLabel.text = "[精选]" + (goods?.name)!
            } else {
                titleLabel.text = goods?.name
            }
            
            numberLabel.text = "x" + "\(goods!.userBuyNumber)"
            priceLabel.text = "$" + (goods!.price)!.cleanDecimalPointZear()
            
            if !(goods!.pm_desc == "买一赠一") {
                giftImageView.isHidden = true
                isShowImageView = false
                layoutSubviews()
            } else  {
                giftImageView.isHidden = false
                isShowImageView = true
                priceLabel.isHidden = true
                titleLabel.text = "[精选]" + (goods?.name)! + "[赠]"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 20))
        
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.left
        addSubview(titleLabel)
        
        numberLabel.font = UIFont.systemFont(ofSize: 13)
        numberLabel.textColor = UIColor.black
        numberLabel.textAlignment = NSTextAlignment.left
        addSubview(numberLabel)
        
        priceLabel.font = UIFont.systemFont(ofSize: 13)
        priceLabel.textColor = UIColor.black
        priceLabel.textAlignment = NSTextAlignment.right
        addSubview(priceLabel)
        
        giftImageView.isHidden = true
        giftImageView.image = UIImage(named: "zengsong")
        addSubview(giftImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShowImageView {
            giftImageView.frame = CGRect(x: 15, y: (height - 20) * 0.5, width: 40, height: 20)
            titleLabel.frame = CGRect(x: giftImageView.frame.maxX + 5, y: 0, width: width * 0.5, height: height)
            numberLabel.frame = CGRect(x: ScreenWidth * 0.7, y: 0, width: 50, height: height)
        } else {
            titleLabel.frame = CGRect(x: 15, y: 0, width: width * 0.6, height: height)
            numberLabel.frame = CGRect(x: ScreenWidth * 0.7, y: 0, width: 50, height: height)
        }
        priceLabel.frame = CGRect(x: width - 60 - 10, y: 0, width: 60, height: 20)
    }
    
}
