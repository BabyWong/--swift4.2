//
//  AdressData.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class AdressData: NSObject, DictModelProtocol {

    @objc var code: Int = -1
    @objc var msg: String?
    @objc var data: [Adress]?
    
    class func loadMyAdressData(_ completion:(_ data: AdressData?, _ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource: "MyAdress", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
//            let modelTool = DictModelManager.sharedManager
//            let data = modelTool.objectWithDictionary(dict, cls: AdressData.self) as? AdressData
//            completion(data, nil)
            let dataModel = AdressData.mj_object(withKeyValues: dict)
            dataModel?.data = Adress.mj_objectArray(withKeyValuesArray: dataModel?.data) as? [Adress]
            completion(dataModel, nil)
        }
    }
    
    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(Adress.self)"]
    }
    
}


class Adress: NSObject {
    
    @objc var accept_name: String?
    @objc var telphone: String?
    @objc var province_name: String?
    @objc var city_name: String?
    @objc var address: String?
    @objc var lng: String?
    @objc var lat: String?
    @objc var gender: String?
}
