//
//  LoadProgressAnimationView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class LoadProgressAnimationView: UIView {
    
    var viewWidth: CGFloat = 0
    override var frame: CGRect {
        willSet {
            if frame.size.width == viewWidth {
                self.isHidden = true
            }
            super.frame = frame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.size.width
        backgroundColor = LFBNavigationYellowColor
        self.frame.size.width = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoadProgressAnimation() {
        self.frame.size.width = 0
        isHidden = false
        weak var tmpSelf = self
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            tmpSelf?.frame.size.width = tmpSelf?.viewWidth ?? ScreenWidth * 0.6
            
            }, completion: { (finish) -> Void in
                
                let time = DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: { () -> Void in
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        tmpSelf?.frame.size.width = tmpSelf?.viewWidth ?? ScreenWidth * 0.8
                    })
                })
        }) 
        
    }
    
    func endLoadProgressAnimation() {
        weak var tmpSelf = self
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            tmpSelf?.frame.size.width = tmpSelf?.viewWidth ?? ScreenWidth
            }, completion: { (finish) -> Void in
                tmpSelf?.isHidden = true
        }) 
    }
}
