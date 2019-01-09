//
//  BindingCouponView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class BindingCouponView: UIView {

    var bindingButtonClickBack:((_ couponTextFiled: UITextField) -> ())?
    
    fileprivate lazy var couponTextFiled: UITextField = {
        let couponTextFiled = UITextField()

        couponTextFiled.keyboardType = UIKeyboardType.numberPad
        couponTextFiled.borderStyle = UITextField.BorderStyle.roundedRect
        couponTextFiled.autocorrectionType = UITextAutocorrectionType.no
        couponTextFiled.font = UIFont.systemFont(ofSize: 14)
        let placeholder = NSAttributedString(string: "请输入优惠劵号码", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(red: 50 / 255.0, green: 50 / 255.0, blue: 50 / 255.0, alpha: 0.8)])
        
        couponTextFiled.attributedPlaceholder = placeholder
        
        return couponTextFiled
    }()

    fileprivate lazy var bindingButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.backgroundColor = LFBNavigationYellowColor
        btn.setTitle("绑定", for: UIControl.State())
        btn.setTitleColor(UIColor.black, for: UIControl.State())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(BindingCouponView.bindingButtonClick), for: UIControl.Event.touchUpInside)

        return btn
        }()
    
    fileprivate lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.2
        
        return lineView
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(couponTextFiled)
        addSubview(bindingButton)
        addSubview(lineView)
    }

    convenience init(frame: CGRect, bindingButtonClickBack:@escaping ((_ couponTextFiled: UITextField) -> ())) {
        self.init(frame: frame)
        
        self.bindingButtonClickBack = bindingButtonClickBack
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topBottomMargin: CGFloat = 10
        let bingdingButtonWidth: CGFloat = 60
        couponTextFiled.frame = CGRect(x: CouponViewControllerMargin, y: topBottomMargin, width: width - 2 * CouponViewControllerMargin - bingdingButtonWidth - 10, height: height - 2 * topBottomMargin)
        bindingButton.frame = CGRect(x: width - CouponViewControllerMargin - bingdingButtonWidth, y: topBottomMargin, width: bingdingButtonWidth, height: couponTextFiled.height)
        lineView.frame = CGRect(x: 0, y: height - 0.5, width: width, height: 0.5)
    }
    
// MARK: Action 
    @objc func bindingButtonClick() {
        if bindingButtonClickBack != nil {
            bindingButtonClickBack!(couponTextFiled)
        }
    }
}
