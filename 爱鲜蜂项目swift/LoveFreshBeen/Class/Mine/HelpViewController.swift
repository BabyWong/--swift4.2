//
//  HelpViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

enum HelpCellType: Int {
    case phone = 0
    case question = 1
}

class HelpViewController: BaseViewController {

    let margin: CGFloat = 20
    let backView: UIView = UIView(frame: CGRect(x: 0, y: 10, width: ScreenWidth, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "客服帮助"
        
        backView.backgroundColor = UIColor.white
        view.addSubview(backView)
        
        let phoneLabel = UILabel(frame: CGRect(x: 20, y: 0, width: ScreenWidth - margin, height: 50))
        creatLabel(phoneLabel, text: "客服电话: 400-8484-842", type: .phone)
        
        let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView.frame = CGRect(x: ScreenWidth - 20, y: (50 - 10) * 0.5, width: 5, height: 10)
        backView.addSubview(arrowImageView)
        
        let lineView = UIView(frame: CGRect(x: margin, y: 49.5, width: ScreenWidth - margin, height: 1))
        lineView.backgroundColor = UIColor.gray
        lineView.alpha = 0.2
        backView.addSubview(lineView)
        
        let questionLabel = UILabel(frame: CGRect(x: margin, y: 50, width: ScreenWidth - margin, height: 50))
        creatLabel(questionLabel, text: "常见问题", type: .question)
        
        let arrowImageView2 = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView2.frame = CGRect(x: ScreenWidth - 20, y: (50 - 10) * 0.5 + 50, width: 5, height: 10)
        backView.addSubview(arrowImageView2)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK - Method
    fileprivate func creatLabel(_ label: UILabel, text: String, type: HelpCellType) {
        label.text = text
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 15)
        label.tag = type.hashValue
        backView.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellClick(_:)))
        label.addGestureRecognizer(tap)
    }
    
    // MARK: - Action
    @objc func cellClick(_ tap: UITapGestureRecognizer) {
     
        switch tap.view!.tag {
        case HelpCellType.phone.hashValue :
            let alertView = UIAlertView(title: "", message: "400-8484-842", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "拨打")
            alertView.show()
            break
        case HelpCellType.question.hashValue :
            let helpDetailVC = HelpDetailViewController()
            navigationController?.pushViewController(helpDetailVC, animated: true)
            break
        default : break
        }
        
    }
    
}

extension HelpViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            UIApplication.shared.openURL(URL(string: "tel:4008484842")!)
        }
    }
}
