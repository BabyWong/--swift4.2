//
//  AboltAuthorViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class AboltAuthorViewController: BaseViewController {
    
    fileprivate var authorLabel: UILabel!
    fileprivate var gitHubLabel: UILabel!
    fileprivate var sinaWeiBoLabel: UILabel!
    fileprivate var blogLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildAuthorImageView()
        
        bulidTextLabel()
        
        bulidGitHubLabel()
        
        bulidSinaLabel()
        
        bulidBlogLabel()
    
        buildURLButton()
    }
    
    // MARK: Build UI
    fileprivate func buildAuthorImageView() {
        navigationItem.title = "关于作者"
        
        let authorImageView = UIImageView(frame: CGRect(x: (ScreenWidth - 100) * 0.5, y: 50, width: 100, height: 100))
        authorImageView.image = UIImage(named: "author")
        authorImageView.layer.masksToBounds = true
        authorImageView.layer.cornerRadius = 15
        view.addSubview(authorImageView)
    }
    
    fileprivate func bulidTextLabel() {
        authorLabel = UILabel()
        authorLabel.text = "维尼的小熊"
        authorLabel.sizeToFit()
        authorLabel.center.x = ScreenWidth * 0.5
        authorLabel.frame.origin.y = 170
        view.addSubview(authorLabel)
    }
    
    fileprivate func bulidGitHubLabel() {
        //frame: CGRectMake((ScreenWidth - gitHubLabel.width) * 0.5, CGRectGetMaxY(authorLabel.frame) + 10, gitHubLabel.width, gitHubLabel.height)
        gitHubLabel = UILabel()
        bulidTextLabel(gitHubLabel, text: "GitHub: " + "\(GitHubURLString)", tag: 1)
    }
    
    fileprivate func bulidSinaLabel() {
        sinaWeiBoLabel = UILabel()
        bulidTextLabel(sinaWeiBoLabel, text: "新浪微博: " + "\(SinaWeiBoURLString)", tag: 2)
    }
    fileprivate func bulidBlogLabel() {
        blogLabel = UILabel()
        bulidTextLabel(blogLabel, text: "技术博客: " + "\(BlogURLString)", tag: 3)
    }
    
    let buttonTitles = ["小熊的Github", "小熊的微博", "小熊的技术博客"]
    let btnW: CGFloat = 80
    fileprivate func buildURLButton() {
        for i in 0...2 {
            let btn = UIButton()
            btn.setTitle(buttonTitles[i], for: UIControl.State())
            btn.backgroundColor = UIColor.white
            btn.layer.cornerRadius = 5
            btn.tag = i
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            btn.frame = CGRect(x: 30 + CGFloat(i) * ((ScreenWidth - btnW * 3 - 60) / 2 + btnW), y: blogLabel.frame.maxY + 10, width: btnW, height: 30)
            btn.addTarget(self, action: #selector(btnClick(_:)), for: UIControl.Event.touchUpInside)
            btn.setTitleColor(UIColor.black, for: UIControl.State())
            view.addSubview(btn)
        }
    }
    
    fileprivate func bulidTextLabel(_ label: UILabel, text: String, tag: Int) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13)
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.textColor = UIColor.colorWithCustom(100, g: 100, b: 100)
        label.numberOfLines = 0
        
        switch tag {
        case 1: label.frame = CGRect(x: 40, y: authorLabel.frame.maxY + 20, width: gitHubLabel.width, height: gitHubLabel.height + 10)
            break
        case 2: label.frame = CGRect(x: 40, y: gitHubLabel.frame.maxY + 10, width: ScreenWidth, height: sinaWeiBoLabel.height + 10)
            break
        case 3: label.frame = CGRect(x: 40, y: sinaWeiBoLabel.frame.maxY + 10, width: ScreenWidth - 40 - 50, height: 40)
        default:break
        }
        
        label.tag = tag
        view.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(textLabelClick(_:)))
        label.addGestureRecognizer(tap)
    }
    
    // MARK: - Action
    @objc func textLabelClick(_ tap: UITapGestureRecognizer) {
        switch tap.view!.tag {
        case 1: UIApplication.shared.openURL(URL(string: GitHubURLString)!)
            break
        case 2: UIApplication.shared.openURL(URL(string: SinaWeiBoURLString)!)
            break
        default: UIApplication.shared.openURL(URL(string: BlogURLString)!)
            break
        }
    }
    
    @objc func btnClick(_ sender: UIButton) {
        switch sender.tag {
        case 0: UIApplication.shared.openURL(URL(string: GitHubURLString)!)
            break
        case 1: UIApplication.shared.openURL(URL(string: SinaWeiBoURLString)!)
            break
        case 2: UIApplication.shared.openURL(URL(string: BlogURLString)!)
            break
        default: 
            break
        }
    }
    
}
