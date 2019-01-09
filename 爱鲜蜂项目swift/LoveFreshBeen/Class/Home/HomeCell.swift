//
//  HomeCell.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

enum HomeCellTyep: Int {
    case horizontal = 0
    case vertical = 1
}

class HomeCell: UICollectionViewCell {
    //MARK: - 初始化子空间
    fileprivate lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        return backImageView
        }()
    
    fileprivate lazy var goodsImageView: UIImageView = {
        let goodsImageView = UIImageView()
        goodsImageView.contentMode = UIView.ContentMode.scaleAspectFit
        return goodsImageView
        }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.font = HomeCollectionTextFont
        nameLabel.textColor = UIColor.black
        return nameLabel
        }()
    
    fileprivate lazy var fineImageView: UIImageView = {
        let fineImageView = UIImageView()
        fineImageView.image = UIImage(named: "jingxuan.png")
        return fineImageView
        }()
    
    fileprivate lazy var giveImageView: UIImageView = {
        let giveImageView = UIImageView()
        giveImageView.image = UIImage(named: "buyOne.png")
        return giveImageView
        }()
    
    fileprivate lazy var specificsLabel: UILabel = {
        let specificsLabel = UILabel()
        specificsLabel.textColor = UIColor.colorWithCustom(100, g: 100, b: 100)
        specificsLabel.font = UIFont.systemFont(ofSize: 12)
        specificsLabel.textAlignment = .left
        return specificsLabel
        }()
    
    fileprivate var discountPriceView: DiscountPriceView?
    
    fileprivate lazy var buyView: BuyView = {
        let buyView = BuyView()
        return buyView
        }()
    
    
    fileprivate var type: HomeCellTyep? {
        didSet {
            backImageView.isHidden = !(type == HomeCellTyep.horizontal)
            goodsImageView.isHidden = (type == HomeCellTyep.horizontal)
            nameLabel.isHidden = (type == HomeCellTyep.horizontal)
            fineImageView.isHidden = (type == HomeCellTyep.horizontal)
            giveImageView.isHidden = (type == HomeCellTyep.horizontal)
            specificsLabel.isHidden = (type == HomeCellTyep.horizontal)
            discountPriceView?.isHidden = (type == HomeCellTyep.horizontal)
            buyView.isHidden = (type == HomeCellTyep.horizontal)
        }
    }
    
    var addButtonClick:((_ imageView: UIImageView) -> ())?
    
    // MARK: - 便利构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(backImageView)
        addSubview(goodsImageView)
        addSubview(nameLabel)
        addSubview(fineImageView)
        addSubview(giveImageView)
        addSubview(specificsLabel)
        addSubview(buyView)
        
        weak var tmpSelf = self
        buyView.clickAddShopCar = {()
            if tmpSelf?.addButtonClick != nil {         
                tmpSelf!.addButtonClick!(tmpSelf!.goodsImageView)
            }
        }
    }
    
    // MARK: - 模型set方法
    var activities: Activities? {
        didSet {
            self.type = .horizontal
            backImageView.sd_setImage(with: URL(string: activities!.img!), placeholderImage: UIImage(named: "v2_placeholder_full_size"))
        }
    }
    
    var goods: Goods? {
        didSet {
            self.type = .vertical
            goodsImageView.sd_setImage(with: URL(string: goods!.img!), placeholderImage: UIImage(named: "v2_placeholder_square"))
            nameLabel.text = goods?.name
            if goods!.pm_desc == "买一赠一" {
                giveImageView.isHidden = false
            } else {
                
                giveImageView.isHidden = true
            }
            if discountPriceView != nil {
                discountPriceView!.removeFromSuperview()
            }
            discountPriceView = DiscountPriceView(price: goods?.price, marketPrice: goods?.market_price)
            addSubview(discountPriceView!)
            
            specificsLabel.text = goods?.specifics
            buyView.goods = goods
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backImageView.frame = bounds
        goodsImageView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        nameLabel.frame = CGRect(x: 5, y: width, width: width - 15, height: 20)
        fineImageView.frame = CGRect(x: 5, y: nameLabel.frame.maxY, width: 30, height: 15)
        giveImageView.frame = CGRect(x: fineImageView.frame.maxX + 3, y: fineImageView.y, width: 35, height: 15)
        specificsLabel.frame = CGRect(x: nameLabel.x, y: fineImageView.frame.maxY, width: width, height: 20)
        discountPriceView?.frame = CGRect(x: nameLabel.x, y: specificsLabel.frame.maxY, width: 60, height: height - specificsLabel.frame.maxY)
        buyView.frame = CGRect(x: width - 85, y: height - 30, width: 80, height: 25)
    }
    
}
