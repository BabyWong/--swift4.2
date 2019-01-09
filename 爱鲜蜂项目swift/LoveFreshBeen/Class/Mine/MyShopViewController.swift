//
//  MyShopViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class MyShopViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的店铺"
        
        let imageView = UIImageView(image: UIImage(named: "v2_store_empty"))
        imageView.center = CGPoint(x: view.center.x, y: view.center.y - 150);
        view.addSubview(imageView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.maxY + 10, width: view.width, height: 30))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.text = "还没有收藏的店铺呦~"
        view.addSubview(titleLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
