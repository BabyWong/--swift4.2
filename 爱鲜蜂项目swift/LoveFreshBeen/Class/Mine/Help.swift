//
//  Help.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class Question: NSObject {
    @objc var title: String?
    @objc var texts: [String]? {
        didSet {
            let maxSize = CGSize(width: ScreenWidth - 40, height: 100000)
            for i in 0..<texts!.count {
                let str = texts![i] as NSString
                let rowHeight: CGFloat = str.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil).size.height + 14
                cellHeight += rowHeight
                everyRowHeight.append(rowHeight)
            }
        }
    }
    
    var everyRowHeight: [CGFloat] = []
    var cellHeight: CGFloat = 0
    
    class func question(_ dict: NSDictionary) -> Question {
        let question = Question()
        question.title = dict.object(forKey: "title") as? String
        question.texts = dict.object(forKey: "texts") as? [String]
        
        return question
    }
    
    class func loadQuestions(_ complete: (([Question]) -> ())) {
        let path = Bundle.main.path(forResource: "HelpPlist", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        
        var questions: [Question] = []
        if array != nil {
            for dic in array! {
                let dicModel = Question.mj_object(withKeyValues: dic) as Question
                questions.append(dicModel)
//                questions.append(Question.question(dic as! NSDictionary))
            }
        }
        complete(questions)
    }
}


