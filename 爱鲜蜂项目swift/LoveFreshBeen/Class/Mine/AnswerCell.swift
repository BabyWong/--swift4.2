//
//  AnswerCell.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class AnswerCell: UITableViewCell {
    
    static fileprivate let identifier: String = "cellID"
    fileprivate let lineView = UIView()
    
    var question: Question? {
        didSet {
            for i in 0..<question!.texts!.count {
                var textY: CGFloat = 0
                for j in 0..<i {
                    textY += question!.everyRowHeight[j]
                }
                
                let textLabel = UILabel(frame: CGRect(x: 20, y: textY, width: ScreenWidth - 40, height: question!.everyRowHeight[i]))
                textLabel.text = question!.texts![i]
                textLabel.numberOfLines = 0
                textLabel.textColor = UIColor.gray
                textLabel.font = UIFont.systemFont(ofSize: 14)
                
                contentView.addSubview(textLabel)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCell.SelectionStyle.none
        lineView.alpha = 0.25
        lineView.backgroundColor = UIColor.gray
        contentView.addSubview(lineView)
    }
    
    class func answerCell(_ tableView: UITableView) -> AnswerCell {
        
//        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? AnswerCell
//        if cell == nil {
        let cell = AnswerCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
//        }
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineView.frame = CGRect(x: 20, y: 0, width: width - 40, height: 0.5)
    }
}
