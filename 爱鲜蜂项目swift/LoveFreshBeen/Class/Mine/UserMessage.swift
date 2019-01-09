//
//  UserMessage.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

enum UserMessageType: Int {
    case system = 0
    case user = 1
}

class UserMessage: NSObject {
    
    @objc var id: String?
    @objc var type = -1
    @objc var title: String?
    @objc var content: String?
    @objc var link: String?
    @objc var city: String?
    @objc var noticy: String?
    @objc var send_time: String?
    
    // 辅助参数
    var subTitleViewHeightNomarl: CGFloat = 60
    var cellHeight: CGFloat = 60 + 60 + 20
    var subTitleViewHeightSpread: CGFloat = 0
    
    class func loadSystemMessage(_ complete: ((_ data: [UserMessage]?, _ error: NSError?) -> ())) {
        
        complete(loadMessage(.system)!, nil)
    }
    
    class func loadUserMessage(_ complete: ((_ data: [UserMessage]?, _ error: NSError?) -> ())) {
        complete(loadMessage(.user), nil)
    }
    
    fileprivate class func userMessage(_ dict: NSDictionary) -> UserMessage {

        let modelTool = DictModelManager.sharedManager
        let message = modelTool.objectWithDictionary(dict, cls: UserMessage.self) as? UserMessage

        return message!
    }
    
    // HWM ADD
    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(Coupon.self)"]
    }
    
    fileprivate class func loadMessage(_ type: UserMessageType) -> [UserMessage]? {
        var data: [UserMessage]? = []
        print(((type == .system) ? "SystemMessage" : "UserMessage"))
        let path = Bundle.main.path(forResource: ((type == .system) ? "SystemMessage" : "UserMessage"), ofType: nil)
        let resData = try? Data(contentsOf: URL(fileURLWithPath: path!))
        if resData != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: resData!, options: .allowFragments)) as! NSDictionary
            data = UserMessage.mj_objectArray(withKeyValuesArray: dict["data"]) as? [UserMessage]
//            if let array = dict.object(forKey: "data") as? NSArray {
//                for dict in array {
//                    let message = UserMessage.userMessage(dict as! NSDictionary)
//                    data?.append(message)
//                }
//            }
        }
        return data
    }
}
