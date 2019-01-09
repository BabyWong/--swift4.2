//
//  OrderGoodsListView.swift
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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class OrderGoodsListView: UIView {
    
    fileprivate let costLabel = UILabel()
    fileprivate let goodsListView = OrderGoodsView()
    fileprivate let feeListView = FeeListView()
    fileprivate let lineView1 = UIView()
    fileprivate let payMoneyLabel = UILabel()
    fileprivate let payLabel = UILabel()
    fileprivate let backView = UIView()
    weak var delegate: OrderGoodsListViewDelegate?
    
    var orderGoodsViewHeight: CGFloat = 0 {
        didSet  {
            layoutSubviews()
        }
    }
    
    var feeListViewHeight: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }
    
    var order: Order? {
        didSet {
            goodsListView.order_goods = order!.order_goods
            orderGoodsViewHeight = goodsListView.orderGoodsViewHeight
            feeListView.fee_list = order!.fee_list
            feeListViewHeight = feeListView.feeListViewHeight
            payMoneyLabel.text = "$" + (order?.real_amount)!
            payLabel.text = "实付"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        costLabel.textColor = UIColor.lightGray
        costLabel.font = UIFont.systemFont(ofSize: 12)
        costLabel.text = "费用明细"
        addSubview(costLabel)
        
        addSubview(goodsListView)
        
        lineView1.alpha = 0.1
        lineView1.backgroundColor = UIColor.lightGray
        addSubview(lineView1)
        
        addSubview(feeListView)
        
        backView.backgroundColor = UIColor.white
        addSubview(backView)
        
        payMoneyLabel.textColor = UIColor.red
        payMoneyLabel.font = UIFont.systemFont(ofSize: 14)
        payMoneyLabel.textAlignment = NSTextAlignment.right
        addSubview(payMoneyLabel)
        
        payLabel.textAlignment = NSTextAlignment.right
        payLabel.textColor = LFBTextBlackColor
        payLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(payLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leftMargin: CGFloat = 10
        costLabel.frame = CGRect(x: leftMargin, y: 0, width: width - leftMargin, height: 30)
        lineView1.frame = CGRect(x: leftMargin, y: costLabel.frame.maxY, width: width - leftMargin, height: 1)
        goodsListView.frame = CGRect(x: 0, y: costLabel.frame.maxY, width: width, height: orderGoodsViewHeight)
        feeListView.frame = CGRect(x: 0, y: goodsListView.frame.maxY, width: width, height: feeListViewHeight)
        payMoneyLabel.frame = CGRect(x: width - 100 - 10, y: feeListView.frame.maxY, width: 100, height: 40)
        payLabel.frame = CGRect(x: payMoneyLabel.frame.minX - 60, y: feeListView.frame.maxY, width: 60, height: 40)
        backView.frame = CGRect(x: 0, y: feeListView.frame.maxY, width: width, height: 40)
        
        if delegate != nil {
            delegate!.orderGoodsListViewHeightDidChange(backView.frame.maxY)
        }
    }
    
}

protocol OrderGoodsListViewDelegate: NSObjectProtocol {
    func orderGoodsListViewHeightDidChange(_ height: CGFloat);
}

class OrderGoodsView: UIView {
    
    var orderGoodsViewHeight: CGFloat = 0
    
    fileprivate var lastViewY: CGFloat = 0
    
    var order_goods: [[OrderGoods]]? {
        didSet {
            for i in 0..<order_goods!.count {
                let array = order_goods![i]
                if array.count == 1 {
                    let goodsView = GoodsView(frame: CGRect(x: 0, y: lastViewY + 10, width: ScreenWidth, height: 20))
                    orderGoodsViewHeight += 40
                    goodsView.orderGoods = array[0]
                    lastViewY = goodsView.frame.maxY + 10
                    addSubview(goodsView)
                } else if array.count > 1 {
                    orderGoodsViewHeight = orderGoodsViewHeight + CGFloat(array.count) * 20 + 20
                    for i in 0..<array.count {
                        let goodsView = GoodsView()
                        if i == 0 {
                            goodsView.frame = CGRect(x: 0, y: lastViewY + 10, width: ScreenWidth, height: 20)
                            lastViewY = goodsView.frame.maxY
                        } else {
                            goodsView.frame = CGRect(x: 0, y: lastViewY, width: ScreenWidth, height: 20)
                            lastViewY = goodsView.frame.maxY + 10
                        }
                        goodsView.orderGoods = array[i]
                        addSubview(goodsView)
                    }
                }
                let lineView = UIView()
                lineView.alpha = 0.1
                lineView.backgroundColor = UIColor.lightGray
                lineView.frame = CGRect(x: 10, y: orderGoodsViewHeight, width: ScreenWidth - 10, height: 1)
                addSubview(lineView)
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
    
}


class GoodsView: UIView {
    
    let titleLabel = UILabel()
    let numberLabel = UILabel()
    let priceLabel = UILabel()
    let giftImageView = UIImageView()
    
    var isShowImageView = false
    
    var orderGoods: OrderGoods? {
        didSet {
            titleLabel.text = orderGoods?.name
            numberLabel.text = "x" + (orderGoods?.goods_nums)!
            priceLabel.text = "$" + (orderGoods?.goods_price)!.cleanDecimalPointZear()
            if orderGoods?.is_gift != -1 {
                if orderGoods!.is_gift == 0 {
                    giftImageView.isHidden = true
                    isShowImageView = false
                    layoutSubviews()
                } else if orderGoods!.is_gift == 1 {
                    giftImageView.isHidden = false
                    isShowImageView = true
                    priceLabel.isHidden = true
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 20))

        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = LFBTextBlackColor
        addSubview(titleLabel)
        
        numberLabel.font = UIFont.systemFont(ofSize: 14)
        numberLabel.textColor = LFBTextBlackColor
        addSubview(numberLabel)
        
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = LFBTextBlackColor
        priceLabel.textAlignment = NSTextAlignment.right
        addSubview(priceLabel)
        
        giftImageView.isHidden = true
        giftImageView.image = UIImage(named: "jingxuan.png")
        addSubview(giftImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShowImageView {
            giftImageView.frame = CGRect(x: 10, y: (height - 15) * 0.5, width: 40, height: 15)
            titleLabel.frame = CGRect(x: giftImageView.frame.maxX + 5, y: 0, width: width * 0.6, height: height)
            numberLabel.frame = CGRect(x: titleLabel.frame.maxX + 10 - 45, y: 0, width: 30, height: height)
        } else {
            titleLabel.frame = CGRect(x: 10, y: 0, width: width * 0.6, height: height)
            numberLabel.frame = CGRect(x: titleLabel.frame.maxX + 10, y: 0, width: 30, height: height)
        }
        priceLabel.frame = CGRect(x: width - 60 - 10, y: 0, width: 60, height: 20)
    }
    
}

class FeeListView: UIView {
    
    let lineView1 = UIView()
    let lineView2 = UIView()
    
    var feeListViewHeight: CGFloat = 20
    var fee_list: [OrderFeeList]? {
        didSet {
            if fee_list?.count > 1 {
                for i in 0..<fee_list!.count {
                    let feelView = FeeView(frame: CGRect(x: 0, y: 10 + CGFloat(i) * 25, width: ScreenWidth, height: 25), fee: fee_list![i])
                    feeListViewHeight += 25
                    addSubview(feelView)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        lineView1.alpha = 0.1
        lineView1.backgroundColor = UIColor.lightGray
        addSubview(lineView1)
        
        lineView2.alpha = 0.1
        lineView2.backgroundColor = UIColor.lightGray
        addSubview(lineView2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineView1.frame = CGRect(x: 10, y: 0, width: width - 10, height: 1)
        lineView2.frame = CGRect(x: 10, y: feeListViewHeight - 1, width: width - 10, height: 1)
    }
}

class FeeView: UIView {
    
    fileprivate let titleLabel = UILabel()
    fileprivate let prictLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        titleLabel.textColor = LFBTextBlackColor
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLabel)
        
        prictLabel.textColor = LFBTextBlackColor
        prictLabel.textAlignment = NSTextAlignment.right
        prictLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(prictLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, fee: OrderFeeList) {
        self.init(frame: frame)
        titleLabel.text = fee.text
        prictLabel.text = "$" + (fee.value?.cleanDecimalPointZear())!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 10, y: 0, width: width - 100, height: 25)
        prictLabel.frame = CGRect(x: width - 150, y: 0, width: 140, height: 25)
    }
}








