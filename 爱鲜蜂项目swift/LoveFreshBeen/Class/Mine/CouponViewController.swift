//
//  CouponViewController.swift
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


class CouponViewController: BaseViewController {
    
    fileprivate var bindingCouponView: BindingCouponView?
    fileprivate var couponTableView: LFBTableView?
    
    fileprivate var useCoupons: [Coupon] = [Coupon]()
    fileprivate var unUseCoupons: [Coupon] = [Coupon]()
    
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setNavigationItem()
        
        buildBindingCouponView()
        
        bulidCouponTableView()
        
        loadCouponData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: bulidUI
    fileprivate func setNavigationItem() {
        navigationItem.title = "优惠劵"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton("使用规则", titleColor: UIColor.colorWithCustom(100, g: 100, b: 100), target: self, action: #selector(rightItemClick))
    }
    
    func buildBindingCouponView() {
        bindingCouponView = BindingCouponView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50), bindingButtonClickBack: { (couponTextFiled) -> () in
            if couponTextFiled.text != nil && !(couponTextFiled.text!.isEmpty) {
                ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: "请输入正确的优惠劵")
            } else {
                let alert = UIAlertView(title: nil, message: "请输入优惠码!", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
        })
        view.addSubview(bindingCouponView!)
    }
    
    fileprivate func bulidCouponTableView() {
        couponTableView = LFBTableView(frame: CGRect(x: 0, y: bindingCouponView!.frame.maxY, width: ScreenWidth, height: ScreenHeight - bindingCouponView!.height - NavigationH), style: UITableView.Style.plain)
        couponTableView!.delegate = self
        couponTableView?.dataSource = self
        view.addSubview(couponTableView!)
    }
    // MARK: Method
    fileprivate func loadCouponData() {
        weak var tmpSelf = self
        CouponData.loadCouponData { (data, error) -> Void in
            if error != nil {
                return
            }
            
            if data?.data?.count > 0 {
                for obj in data!.data! {
                    switch obj.status {
                    case 0: tmpSelf!.useCoupons.append(obj)
                        break
                    default: tmpSelf!.unUseCoupons.append(obj)
                        break
                    }
                }
            }
            
            tmpSelf!.couponTableView?.reloadData()
        }
    }
    
    // MARK: Action
    @objc func rightItemClick() {
        let couponRuleVC = CoupinRuleViewController()
        couponRuleVC.loadURLStr = CouponUserRuleURLString
        couponRuleVC.navTitle = "使用规则"
        navigationController?.pushViewController(couponRuleVC, animated: true)
    }
}

// - MARK: UITableViewDelegate, UITableViewDataSource
extension CouponViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if useCoupons.count > 0 && unUseCoupons.count > 0 {
            if 0 == section {
                return useCoupons.count
            } else {
                return unUseCoupons.count
            }
        }
        
        if useCoupons.count > 0 {
            return useCoupons.count
        }
        
        if unUseCoupons.count > 0 {
            return unUseCoupons.count
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if useCoupons.count > 0 && unUseCoupons.count > 0 {
            return 2
        } else if useCoupons.count > 0 || unUseCoupons.count > 0 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CouponCell.cellWithTableView(tableView)
        var coupon: Coupon?
        if useCoupons.count > 0 && unUseCoupons.count > 0 {
            if 0 == (indexPath as NSIndexPath).section {
                coupon = useCoupons[(indexPath as NSIndexPath).row]
            } else {
                coupon = unUseCoupons[(indexPath as NSIndexPath).row]
            }
        } else if useCoupons.count > 0 {
            coupon = useCoupons[(indexPath as NSIndexPath).row]
        } else if unUseCoupons.count > 0 {
            coupon = unUseCoupons[(indexPath as NSIndexPath).row]
        }
        
        cell.coupon = coupon!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if unUseCoupons.count > 0 && useCoupons.count > 0 && 0 == section {
            return 10
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if unUseCoupons.count > 0 && useCoupons.count > 0 {
            if 0 == section {
                let footView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
                footView.backgroundColor = UIColor.clear
                let lineView = UIView(frame: CGRect(x: CouponViewControllerMargin, y: 4.5, width: ScreenWidth - 2 * CouponViewControllerMargin, height: 1))
                lineView.backgroundColor = UIColor.colorWithCustom(230, g: 230, b: 230)
                footView.addSubview(lineView)
                return footView
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
