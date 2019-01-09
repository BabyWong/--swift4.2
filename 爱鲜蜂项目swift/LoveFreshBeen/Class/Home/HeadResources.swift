//
//  HeadResources.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class HeadResources: NSObject, DictModelProtocol {

    @objc var msg: String?
    @objc var reqid: String?
    @objc var data: HeadData?
    
    class func loadHomeHeadData(_ completion:(_ data: HeadResources?, _ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource: "首页焦点按钮", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
//            let modelTool = DictModelManager.sharedManager
//            let data = modelTool.objectWithDictionary(dict, cls: HeadResources.self) as? HeadResources
            let headResourcesDataModel = HeadResources.mj_object(withKeyValues: dict)
            completion(headResourcesDataModel, nil)
        }
    }

    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(HeadData.self)"]
    }
    
    // 
    override func mj_keyValuesDidFinishConvertingToObject() {
        data?.focus = Activities.mj_objectArray(withKeyValuesArray: data?.focus).copy() as? [Activities]
        data?.icons = Activities.mj_objectArray(withKeyValuesArray: data?.icons).copy() as? [Activities]
        data?.activities = Activities.mj_objectArray(withKeyValuesArray: data?.activities).copy() as? [Activities]
    }
}

class HeadData: NSObject, DictModelProtocol {
    @objc var focus: [Activities]? = [Activities]()
    @objc var icons: [Activities]? = [Activities]()
    @objc var activities: [Activities]? = [Activities]()
    
    static func customClassMapping() -> [String : String]? {
        return ["focus" : "\(Activities.self)", "icons" : "\(Activities.self)", "activities" : "\(Activities.self)"]
    }

}


class Activities: NSObject {
    @objc var id: String?
    @objc var name: String?
    @objc var img: String?
    @objc var topimg: String?
    @objc var jptype: String?
    @objc var trackid: String?
    @objc var mimg: String?
    @objc var customURL: String?
}
