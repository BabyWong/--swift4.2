//
//  Mine.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class Mine: NSObject , DictModelProtocol{

    @objc var code: Int = -1
    @objc var msg: String?
    @objc var reqid: String?
    @objc var data: MineData?
    
    class func loadMineData(_ completion:(_ data: Mine?, _ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource: "Mine", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
//            let modelTool = DictModelManager.sharedManager
//            let data = modelTool.objectWithDictionary(dict, cls: Mine.self) as? Mine
            let dataModel = Mine.mj_object(withKeyValues: dict)
            completion(dataModel, nil)
        }
    }
    
    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(MineData.self)"]
    }
}

class MineData: NSObject {
    @objc var has_new: Int = -1
    @objc var has_new_user: Int = -1
    @objc var availble_coupon_num = 0
}
