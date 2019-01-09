//
//  MyOrderCell.swift
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

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class MyOrderCell: UITableViewCell {
    
    fileprivate var timeLabel: UILabel?
    fileprivate var statusTextLabel: UILabel?
    fileprivate var lineView1: UIView?
    fileprivate var goodsImageViews: OrderImageViews?
    fileprivate var lineView2: UIView?
    fileprivate var productNumsLabel: UILabel?
    fileprivate var productsPriceLabel: UILabel?
    fileprivate var payLabel: UILabel?
    fileprivate var lineView3: UIView?
    fileprivate var buttons: OrderButtons?
    fileprivate var indexPath: IndexPath?
    
    weak var delegate: MyOrderCellDelegate?
    
    var order: Order? {
        didSet {
            timeLabel?.text = order?.create_time
            statusTextLabel?.text = order?.textStatus
            goodsImageViews?.order_goods = order?.order_goods
            productNumsLabel?.text = "共" + "\(order!.buy_num)" + "件商品"
            productsPriceLabel?.text = "$" + (order!.user_pay_amount)!
            buttons?.buttons = order?.buttons
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCell.SelectionStyle.none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.white
        
        timeLabel = UILabel()
        timeLabel?.font = UIFont.systemFont(ofSize: 13)
        timeLabel?.textColor = UIColor.black
        contentView.addSubview(timeLabel!)
    
        statusTextLabel = UILabel()
        statusTextLabel?.textAlignment = NSTextAlignment.right
        statusTextLabel?.font = timeLabel?.font
        statusTextLabel?.textColor = UIColor.red
        contentView.addSubview(statusTextLabel!)
        
        goodsImageViews = OrderImageViews()
        contentView.addSubview(goodsImageViews!)
        
        productNumsLabel = UILabel()
        productNumsLabel?.textColor = UIColor.gray
        productNumsLabel?.textAlignment = NSTextAlignment.right
        productNumsLabel?.font = timeLabel?.font
        contentView.addSubview(productNumsLabel!)
        
        payLabel = UILabel()
        payLabel?.text = "实付:"
        payLabel?.textColor = UIColor.gray
        payLabel?.font = productNumsLabel?.font
        contentView.addSubview(payLabel!)
        
        productsPriceLabel = UILabel()
        productsPriceLabel?.textColor = UIColor.black
        productsPriceLabel?.textAlignment = NSTextAlignment.right
        productsPriceLabel?.font = payLabel?.font
        productsPriceLabel?.textColor = UIColor.gray
        contentView.addSubview(productsPriceLabel!)
        
        weak var tmpSelf = self
        buttons = OrderButtons(frame: CGRect.zero, buttonClickCallBack: { (type) -> () in
            if tmpSelf?.delegate != nil {
                if tmpSelf!.delegate!.responds(to: #selector(MyOrderCellDelegate.orderCellButtonDidClick(_:buttonType:))) {
                    tmpSelf!.delegate!.orderCellButtonDidClick!(tmpSelf!.indexPath!, buttonType: type)
                }
            }
        })
        buttons?.backgroundColor = UIColor.white
        contentView.addSubview(buttons!)
        
        lineView1 = UIView()
        lineView1?.backgroundColor = UIColor.lightGray
        lineView1?.alpha = 0.1
        contentView.addSubview(lineView1!)
        
        lineView2 = UIView()
        lineView2?.backgroundColor = UIColor.lightGray
        lineView2?.alpha = 0.1
        contentView.addSubview(lineView2!)
        
        lineView3 = UIView()
        lineView3?.backgroundColor = UIColor.lightGray
        lineView3?.alpha = 0.1
        contentView.addSubview(lineView3!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static fileprivate let identifier = "OrderCell"
    class func myOrderCell(_ tableView: UITableView, indexPath: IndexPath) -> MyOrderCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyOrderCell
        
        if cell == nil {
            cell = MyOrderCell(style: .default, reuseIdentifier: identifier)
        }
        
        cell?.indexPath = indexPath
        
        return cell!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 10
        let topViewHeight: CGFloat = 30
        contentView.frame = CGRect(x: 0, y: 0, width: width, height: height - 20)
        timeLabel?.frame = CGRect(x: margin, y: 0, width: ScreenWidth, height: topViewHeight)
        statusTextLabel?.frame = CGRect(x: ScreenWidth - 150, y: 0, width: 140, height: topViewHeight)
        lineView1?.frame = CGRect(x: margin, y: topViewHeight, width: ScreenWidth - margin, height: 1)
        goodsImageViews?.frame = CGRect(x: 0, y: topViewHeight, width: width, height: 65)
        lineView2?.frame = CGRect(x: margin, y: goodsImageViews!.frame.maxY, width: width - margin, height: 1)
        productsPriceLabel?.frame = CGRect(x: width - margin - 60, y: goodsImageViews!.frame.maxY, width: 60, height: topViewHeight)
        payLabel?.frame = CGRect(x: width - 70 - 20, y: productsPriceLabel!.y, width: 40, height: topViewHeight)
        productNumsLabel?.frame = CGRect(x: width - 220, y: productsPriceLabel!.y, width: 100, height: topViewHeight)
        lineView3?.frame = CGRect(x: margin, y: payLabel!.frame.maxY, width: width - margin, height: 1)
        buttons?.frame = CGRect(x: 0, y: productNumsLabel!.frame.maxY, width: width, height: 40)
    }
}

@objc protocol MyOrderCellDelegate: NSObjectProtocol {
    @objc optional func orderCellButtonDidClick(_ indexPath: IndexPath, buttonType: Int)
}

class OrderImageViews: UIView {
    
    var imageViews: UIView?
    var arrowImageView: UIImageView?
    var order_goods: [[OrderGoods]]? {
        didSet {
            let imageViewsSubViews = imageViews?.subviews
            for i in 0..<order_goods!.count {
                if i < 4 {
                    let subImageView = imageViewsSubViews![i] as! UIImageView
                    subImageView.isHidden = false
                    subImageView.sd_setImage(with: URL(string: order_goods![i][0].img!), placeholderImage: UIImage(named: "author"))
                }
            }
            
//            for subImageView in imageViewsSubViews! {
//                subImageView.isHidden = true
//            }
            
            
//            for var i = order_goods!.count; i < 4; i++ {
//                let subImageView = imageViewsSubViews![i]
//                subImageView.isHidden = true
//            }
            
            if order_goods?.count >= 5 {
                let subImageView = imageViewsSubViews![4]
                subImageView.isHidden = false
            } else {
                let subImageView = imageViewsSubViews![4]
                subImageView.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageViews = UIView(frame: CGRect(x: 0, y: 5, width: ScreenWidth, height: 55))
        for i in 0...4 {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(i) * 60 + 10, y: 0, width: 55, height: 55))
            if 4 == i {
                imageView.image = UIImage(named: "v2_goodmore")
            }
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView.isHidden = true
            imageViews?.addSubview(imageView)
        }
        
        arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView?.frame = CGRect(x: ScreenWidth - 15, y: (65 - arrowImageView!.bounds.size.height) * 0.5, width: arrowImageView!.bounds.size.width, height: arrowImageView!.bounds.size.height)
        imageViews?.addSubview(arrowImageView!)
        addSubview(imageViews!)
    }
    
    convenience init(frame: CGRect ,order_goods: [[OrderGoods]]) {
        self.init(frame: frame)
        self.order_goods = order_goods
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OrderButtons: UIView {
    
    var buttonClickCallBack: ((_ type: Int) -> ())?
    
    var buttons: [OrderButton]? {
        didSet {
            for subBtnView in self.subviews {
                subBtnView.removeFromSuperview()
            }
//            for var i = subviews.count; i > 0; i-- {
//                let subBtnView = self.subviews[i-1]
//                subBtnView.removeFromSuperview()
//            }
            
            let btnW: CGFloat = 60
            let btnH: CGFloat = 26
            
            for i in 0..<buttons!.count {
                let btn = UIButton(frame: CGRect(x: ScreenWidth - CGFloat(i + 1) * (btnW + 10) - 5, y: (self.height - btnH) * 0.5, width: btnW, height: btnH))
                btn.tag = i
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                btn.setTitleColor(UIColor.black, for: UIControl.State())
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = 5
                btn.backgroundColor = LFBNavigationYellowColor
                btn.setTitle(buttons![i].text, for: UIControl.State())
                btn.addTarget(self, action: #selector(orderButtonClick(_:)), for: UIControl.Event.touchUpInside)
                addSubview(btn)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, buttonClickCallBack:@escaping (_ type: Int) -> ()) {
        self.init(frame: frame)
        self.buttonClickCallBack = buttonClickCallBack
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for i in 0..<subviews.count {
            let subBtnView = subviews[i]
            subBtnView.frame.origin.y = (self.height - 26) * 0.5
        }
    }
    
    @objc func orderButtonClick(_ sender: UIButton) {
        if buttonClickCallBack != nil {
            buttonClickCallBack!(buttons![sender.tag].type)
        }
    }
}
