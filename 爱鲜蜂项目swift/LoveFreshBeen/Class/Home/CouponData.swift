//
//  CouponData.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class CouponData: NSObject, DictModelProtocol {

    @objc var code: Int = -1
    @objc var msg: String?
    @objc var reqid: String?
    @objc var data: [Coupon]?

    class func loadCouponData(_ completion:(_ data: CouponData?, _ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource: "MyCoupon", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
//            let modelTool = DictModelManager.sharedManager
//            let data = modelTool.objectWithDictionary(dict, cls: CouponData.self) as? CouponData
            let dataModel = CouponData.mj_object(withKeyValues: dict)
            dataModel?.data = Coupon.mj_objectArray(withKeyValuesArray: dataModel?.data) as? [Coupon]
            completion(dataModel, nil)
        }
    }
    
    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(Coupon.self)"]
    }
}

class Coupon: NSObject {
    @objc var id: String?
    @objc var card_pwd: String?
    /// 开始时间
    @objc var start_time: String?
    /// 结束时间
    @objc var end_time: String?
    /// 金额
    @objc var value: String?
    @objc var tid: String?
    /// 是否被使用 0 使用 1 未使用
    @objc var is_userd: String?
    /// 0 可使用 1 不可使用
    @objc var status: Int = -1
    @objc var true_end_time: String?
    /// 标题
    @objc var name: String?
    @objc var point: String?
    @objc var type: String?
    @objc var order_limit_money: String?
    @objc var desc: String?
    @objc var free_freight: String?
    @objc var city: String?
    @objc var ctime: String?
    
    static func customClassMapping() -> [String : String]? {
        return ["desc" : "\(String.self)"]
    }
}

