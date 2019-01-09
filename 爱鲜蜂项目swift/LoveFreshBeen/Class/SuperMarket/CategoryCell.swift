//
//  CategoryCell.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class CategoryCell: UITableViewCell {
    
    fileprivate static let identifier = "CategoryCell"
    
    // MARK: Lazy Property
    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = LFBTextGreyColol
        nameLabel.highlightedTextColor = UIColor.black
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        return nameLabel
    }()
    
    fileprivate lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "llll")
        backImageView.highlightedImage = UIImage(named: "kkkkkkk")
        return backImageView
        }()
    
    fileprivate lazy var yellowView: UIView = {
        let yellowView = UIView()
        yellowView.backgroundColor = LFBNavigationYellowColor
        
        return yellowView
        }()
    fileprivate lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.colorWithCustom(225, g: 225, b: 225)
        return lineView
        }()
// MARK: 模型setter方法
    var categorie: Categorie? {
        didSet {
            nameLabel.text = categorie?.name
        }
    }
    
// MARK: Method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(backImageView)
        addSubview(lineView)
        addSubview(yellowView)
        addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func cellWithTableView(_ tableView: UITableView) -> CategoryCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CategoryCell
        if cell == nil {
            cell = CategoryCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nameLabel.isHighlighted = selected
        backImageView.isHighlighted = selected
        yellowView.isHidden = !selected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = bounds
        backImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        yellowView.frame = CGRect(x: 0, y: height * 0.1, width: 5, height: height * 0.8)
        lineView.frame = CGRect(x: 0, y: height - 1, width: width, height: 1)
    }

}
