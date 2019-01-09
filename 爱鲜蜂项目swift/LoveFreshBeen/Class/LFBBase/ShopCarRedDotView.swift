//
//  ShopCarRedDotView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ShopCarRedDotView: UIView {
    
    fileprivate static let instance = ShopCarRedDotView()
    
    class var sharedRedDotView: ShopCarRedDotView {
        return instance
    }
    
    fileprivate var numberLabel: UILabel?
    fileprivate var redImageView: UIImageView?
    
    var buyNumber: Int = 0 {
        didSet {
            if 0 == buyNumber {
                numberLabel?.text = ""
                isHidden = true
            } else {
                if buyNumber > 99 {
                    numberLabel?.font = UIFont.systemFont(ofSize: 8)
                } else {
                    numberLabel?.font = UIFont.systemFont(ofSize: 10)
                }
                
                isHidden = false
                numberLabel?.text = "\(buyNumber)"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: 20, height: 20))
        backgroundColor = UIColor.clear
        
        redImageView = UIImageView(image: UIImage(named: "reddot"))
        addSubview(redImageView!)
        
        numberLabel = UILabel()
        numberLabel!.font = UIFont.systemFont(ofSize: 10)
        numberLabel!.textColor = UIColor.white
        numberLabel?.textAlignment = NSTextAlignment.center
        addSubview(numberLabel!)
        
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        redImageView?.frame = bounds
        numberLabel?.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func addProductToRedDotView(_ animation: Bool) {
        buyNumber = buyNumber + 1
        
        if animation {
            reddotAnimation()
        }
    }
    
    func reduceProductToRedDotView(_ animation: Bool) {
        if buyNumber > 0 {
            buyNumber = buyNumber - 1
        }
        
        if animation {
            reddotAnimation()
        }
    }
    
    fileprivate func reddotAnimation() {
        UIView.animate(withDuration: ShopCarRedDotAnimationDuration, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { (completion) -> Void in
                UIView.animate(withDuration: ShopCarRedDotAnimationDuration, animations: { () -> Void in
                    self.transform = CGAffineTransform.identity
                    }, completion: nil)
        })
    }
}
