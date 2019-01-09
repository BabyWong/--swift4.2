//
//  AdressCell.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class AdressCell: UITableViewCell {
    
    fileprivate let nameLabel       = UILabel()
    fileprivate let phoneLabel      = UILabel()
    fileprivate let adressLabel     = UILabel()
    fileprivate let lineView        = UIView()
    fileprivate let modifyImageView = UIImageView()
    fileprivate let bottomView      = UIView()
    
    var modifyClickCallBack:((Int) -> Void)?
    
    var adress: Adress? {
        didSet {
            nameLabel.text = adress!.accept_name
            phoneLabel.text = adress!.telphone
            adressLabel.text = adress!.address
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.white
        
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = LFBTextBlackColor
        contentView.addSubview(nameLabel)
        
        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        phoneLabel.textColor = LFBTextBlackColor
        contentView.addSubview(phoneLabel)
        
        adressLabel.font = UIFont.systemFont(ofSize: 13)
        adressLabel.textColor = UIColor.lightGray
        contentView.addSubview(adressLabel)
        
        lineView.backgroundColor = UIColor.lightGray
        lineView.alpha = 0.2
        contentView.addSubview(lineView)
        
        modifyImageView.image = UIImage(named: "v2_address_edit_highlighted")
        modifyImageView.contentMode = UIView.ContentMode.center
        contentView.addSubview(modifyImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(modifyImageViewClick(_:)))
        modifyImageView.isUserInteractionEnabled = true
        modifyImageView.addGestureRecognizer(tap)
        
        bottomView.backgroundColor = UIColor.lightGray
        bottomView.alpha = 0.4
        contentView.addSubview(bottomView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static fileprivate let identifier = "AdressCell"
    
    class func adressCell(_ tableView: UITableView, indexPath: IndexPath, modifyClickCallBack:@escaping ((Int) -> Void)) -> AdressCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AdressCell
        if cell == nil {
            cell = AdressCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
        cell?.modifyClickCallBack = modifyClickCallBack
        cell?.modifyImageView.tag = (indexPath as NSIndexPath).row
        
        return cell!
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        nameLabel.frame = CGRect(x: 10, y: 15, width: 80, height: 20)
        phoneLabel.frame = CGRect(x: nameLabel.frame.maxX + 10, y: 15, width: 150, height: 20)
        adressLabel.frame = CGRect(x: 10, y: phoneLabel.frame.maxY + 10, width: width * 0.6, height: 20)
        lineView.frame = CGRect(x: width * 0.8, y: 10, width: 1, height: height - 20)
        modifyImageView.frame = CGRect(x: width * 0.8 + (width * 0.2 - 40) * 0.5, y: (height - 40) * 0.5, width: 40, height: 40)
        bottomView.frame = CGRect(x: 0, y: height - 1, width: width, height: 1)
    }
    
    // MARK: - Action
    @objc func modifyImageViewClick(_ tap: UIGestureRecognizer) {
        if modifyClickCallBack != nil {
            modifyClickCallBack!(tap.view!.tag)
        }
    }
    
}
