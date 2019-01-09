//
//  OrderData.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6
import UIKit

class OrderData: NSObject, DictModelProtocol {
    @objc var page: Int = -1
    @objc var code: Int = -1
    @objc var data: [Order]?

    class func loadOrderData(_ completion:(_ data: OrderData?, _ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource: "MyOrders", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
//            let modelTool = DictModelManager.sharedManager
//            let data = modelTool.objectWithDictionary(dict, cls: OrderData.self) as? OrderData
//            completion(data, nil)
            let dataModel = OrderData.mj_object(withKeyValues: dict)
            completion(dataModel, nil)
        }
    }
    
    override func mj_keyValuesDidFinishConvertingToObject() {
       data = Order.mj_objectArray(withKeyValuesArray: data) as? [Order]
    }
    
    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(Order.self)"]
    }
}

class Order: NSObject {//DictModelProtocol
    @objc var star: Int = -1
    @objc var comment: String?
    @objc var id: String?
    @objc var order_no: String?
    @objc var accept_name: String?
    @objc var user_id: String?
    @objc var pay_code: String?
    @objc var pay_type: String?
    @objc var distribution: String?
    @objc var status: String?
    @objc var pay_status: String?
    @objc var distribution_status: String?
    @objc var postcode: String?
    @objc var telphone: String?
    @objc var country: String?
    @objc var province: String?
    @objc var city: String?
    @objc var address: String?
    @objc var longitude: String?
    @objc var latitude: String?
    @objc var mobile: String?
    @objc var payable_amount: String?
    @objc var real_amount: String?
    @objc var pay_time: String?
    @objc var send_time: String?
    @objc var create_time: String?
    @objc var completion_time: String?
    @objc var order_amount: String?
    @objc var accept_time: String?
    @objc var lastUpdateTime: String?
    @objc var preg_dealer_type: String?
    @objc var user_pay_amount: String?
    @objc var order_goods: [[OrderGoods]]?
    @objc var enableComment: Int = -1
    @objc var isCommented: Int = -1
    @objc var newStatus: Int = -1
    @objc var status_timeline: [OrderStatus]?
    @objc var fee_list: [OrderFeeList]?
    @objc var buy_num: Int = -1
    @objc var showSendCouponBtn: Int = -1
    @objc var dealer_name: String?
    @objc var dealer_address: String?
    @objc var dealer_lng: String?
    @objc var dealer_lat: String?
    @objc var buttons: [OrderButton]?
    @objc var detail_buttons: [OrderButton]?
    @objc var textStatus: String?
    @objc var in_refund: Int = -1
    @objc var checknum: String?
    @objc var postscript: String?
    
//    static func customClassMapping() -> [String : String]? {
//        return ["order_goods" : "\(OrderGoods.self)", "status_timeline" : "\(OrderStatus.self)", "fee_list" : "\(OrderFeeList.self)", "buttons" : "\(OrderButton.self)", "detail_buttons" : "\(OrderButton.self)"]
//    }
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        order_goods = OrderGoods.mj_objectArray(withKeyValuesArray: order_goods) as? [[OrderGoods]]
        status_timeline = OrderStatus.mj_objectArray(withKeyValuesArray: status_timeline) as? [OrderStatus]
        fee_list = OrderFeeList.mj_objectArray(withKeyValuesArray: fee_list) as? [OrderFeeList]
        buttons = OrderButton.mj_objectArray(withKeyValuesArray: buttons) as? [OrderButton]
        detail_buttons = OrderButton.mj_objectArray(withKeyValuesArray: detail_buttons) as? [OrderButton]
    }
}

class OrderGoods: NSObject {
    @objc var goods_id: String?
    @objc var goods_price: String?
    @objc var real_price: String?
    @objc var isgift: Int = -1
    @objc var name: String?
    @objc var specifics: String?
    @objc var brand_name: String?
    @objc var img: String?
    @objc var is_gift: Int = -1
    @objc var goods_nums: String?
}

class OrderStatus: NSObject {
    @objc var status_title: String?
    @objc var status_desc: String?
    @objc var status_time: String?
}

class OrderFeeList: NSObject {
    @objc var text: String?
    @objc var value: String?
}

class OrderButton: NSObject {
    @objc var type: Int = -1
    @objc var text: String?
}














