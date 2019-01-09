//
//  OrderStatusCell.swift
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


enum OrderStateType: Int {
    case top = 0
    case middle = 1
    case bottom = 2
}

class OrderStatusCell: UITableViewCell {

    fileprivate var timeLabel: UILabel?
    fileprivate var titleLabel: UILabel?
    fileprivate var subTitleLable: UILabel?
    fileprivate var circleButton: UIButton?
    fileprivate var topLineView: UIView?
    fileprivate var bottomLineView: UIView?

    fileprivate var lineView: UIView?
    
    var orderStatus: OrderStatus? {
        didSet {
            timeLabel?.text = orderStatus?.status_time
            subTitleLable?.text = orderStatus?.status_desc
            titleLabel?.text = orderStatus?.status_title
            if orderStatus?.status_desc?.count > 0 {
                let tmpStr = (orderStatus?.status_desc)! as NSString
                if tmpStr.length > 10 {
                    let str = tmpStr.substring(to: 5) as NSString
                    if str.isEqual(to: "下单成功，") {
                        let mutableStr = NSMutableString(string: tmpStr)
                        mutableStr.insert("\n ", at: 9)
                        subTitleLable?.text = mutableStr as String
                    }
                }
            }
        }
    }
    
    var orderStateType: OrderStateType? {
        didSet {
            switch orderStateType!.hashValue {
            case OrderStateType.top.hashValue:
                circleButton?.isSelected = true
                titleLabel?.textColor = UIColor.black
                bottomLineView?.isHidden = false
                topLineView?.isHidden = true
                lineView?.isHidden = false
                subTitleLable?.numberOfLines = 1
                break
            case OrderStateType.middle.hashValue:
                circleButton?.isSelected = false
                titleLabel?.textColor = UIColor.colorWithCustom(100, g: 100, b: 100)
                bottomLineView?.isHidden = false
                topLineView?.isHidden = false
                lineView?.isHidden = false
                subTitleLable?.numberOfLines = 1
                break
            case OrderStateType.bottom.hashValue:
                bottomLineView?.isHidden = true
                topLineView?.isHidden = false
                lineView?.isHidden = true
                titleLabel?.textColor = UIColor.colorWithCustom(100, g: 100, b: 100)
                circleButton?.isSelected = false
                subTitleLable?.numberOfLines = 0
                break
            default: break
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        let textColor = UIColor.colorWithCustom(100, g: 100, b: 100)
        
        timeLabel = UILabel()
        timeLabel?.textColor = textColor
        timeLabel?.textAlignment = NSTextAlignment.center
        timeLabel?.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(timeLabel!)
        
        circleButton = UIButton()
        circleButton?.isUserInteractionEnabled = false
        circleButton?.setBackgroundImage(UIImage(named: "order_grayMark"), for: UIControl.State())
        circleButton?.setBackgroundImage(UIImage(named: "order_yellowMark"), for: UIControl.State.selected)
        contentView.addSubview(circleButton!)
        
        topLineView = UIView()
        topLineView?.backgroundColor = textColor
        topLineView?.alpha = 0.3
        contentView.addSubview(topLineView!)
        
        bottomLineView = UIView()
        bottomLineView?.backgroundColor = textColor
        bottomLineView?.alpha = 0.3
        contentView.addSubview(bottomLineView!)
        
        titleLabel = UILabel()
        titleLabel?.textColor = textColor
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(titleLabel!)
        
        subTitleLable = UILabel()
        subTitleLable?.textColor = textColor
        subTitleLable?.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(subTitleLable!)
        
        lineView = UIView()
        lineView?.backgroundColor = textColor
        lineView?.alpha = 0.2
        contentView.addSubview(lineView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate static let identifier = "orderStatusCell"
    class func orderStatusCell(_ tableView: UITableView) -> OrderStatusCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? OrderStatusCell
        if cell == nil {
            cell = OrderStatusCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
        
        return cell!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 15
        timeLabel?.frame = CGRect(x: margin, y: 12, width: 35, height: 20)
        circleButton?.frame = CGRect(x: timeLabel!.frame.maxX + 10, y: 15, width: 15, height: 15)
        topLineView?.frame = CGRect(x: (circleButton?.center.x)! - 1, y: 0, width: 2, height: 15 )
        bottomLineView?.frame = CGRect(x: (circleButton?.center.x)! - 1, y: 15 + 15, width: 2, height: height - 15 - 15)
        titleLabel?.frame = CGRect(x: circleButton!.frame.maxX + 20, y: 12, width: width - circleButton!.frame.maxX - 20, height: 20)
        subTitleLable?.frame = CGRect(x: titleLabel!.x, y: titleLabel!.frame.maxY + 10, width: width - titleLabel!.frame.origin.x, height: 30)
        lineView?.frame = CGRect(x: titleLabel!.x, y: height - 1, width: width - titleLabel!.x, height: 1)
    }
    
}
