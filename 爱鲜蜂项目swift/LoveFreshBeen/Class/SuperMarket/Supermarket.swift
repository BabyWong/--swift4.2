//
//  SupermarketResouce.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class Supermarket: NSObject, DictModelProtocol {
    @objc var code: Int = -1
    @objc var msg: String?
    @objc var reqid: String?
    @objc var data: SupermarketResouce?
    
    class func loadSupermarketData(_ completion:(_ data: Supermarket?, _ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource: "supermarket", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
//            let modelTool = DictModelManager.sharedManager
//            let data = modelTool.objectWithDictionary(dict, cls: Supermarket.self) as? Supermarket
            let dataModel = Supermarket.mj_object(withKeyValues: dict)
            dataModel?.data?.categories = Categorie.mj_objectArray(withKeyValuesArray: dataModel?.data?.categories) as? [Categorie]
            completion(dataModel, nil)
        }
    }
    
    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(SupermarketResouce.self)"]
    }
    
    class func searchCategoryMatchProducts(_ supermarketResouce: SupermarketResouce) -> [[Goods]]? {
        var arr = [[Goods]]()
        let products = supermarketResouce.products
        for cate in supermarketResouce.categories! {
//           let goodsArr = products!.value(forKey: cate.id!) as! [Goods]
            let goodsArr = Goods.mj_objectArray(withKeyValuesArray: products!.value(forKey: cate.id!)) as! [Goods]
            arr.append(goodsArr)
        }
//        arr = Goods.mj_objectArray(withKeyValuesArray: products) as! [[Goods]]
        return arr
    }
    
    
}

class SupermarketResouce: NSObject {
    @objc var categories: [Categorie]?
    @objc var products: Products?
    @objc var trackid: String?
    
    static func customClassMapping() -> [String : String]? {
        return ["categories" : "\(Categorie.self)", "products" : "\(Products.self)"]
    }
}

class Categorie: NSObject {
    @objc var id: String?
    @objc var name: String?
    @objc var sort: String?
}

class Products: NSObject, DictModelProtocol {
    @objc var a82: [Goods]?
    @objc var a96: [Goods]?
    @objc var a99: [Goods]?
    @objc var a106: [Goods]?
    @objc var a134: [Goods]?
    @objc var a135: [Goods]?
    @objc var a136: [Goods]?
    @objc var a137: [Goods]?
    @objc var a141: [Goods]?
    @objc var a143: [Goods]?
    @objc var a147: [Goods]?
    @objc var a151: [Goods]?
    @objc var a152: [Goods]?
    @objc var a158: [Goods]?
    
    static func customClassMapping() -> [String : String]? {
        return ["a82" : "\(Goods.self)", "a96" : "\(Goods.self)", "a99" : "\(Goods.self)", "a106" : "\(Goods.self)", "a134" : "\(Goods.self)", "a135" : "\(Goods.self)", "a136" : "\(Goods.self)", "a141" : "\(Goods.self)", "a143" : "\(Goods.self)", "a147" : "\(Goods.self)", "a151" : "\(Goods.self)", "a152" : "\(Goods.self)", "a158" : "\(Goods.self)", "a137" : "\(Goods.self)"]
    }
}

