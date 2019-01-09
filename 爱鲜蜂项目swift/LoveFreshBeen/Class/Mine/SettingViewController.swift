//
//  SettingViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class SettingViewController: BaseViewController {
    
    fileprivate let subViewHeight: CGFloat = 50
    
    fileprivate var aboutMeView: UIView!
    fileprivate var cleanCacheView: UIView!
    fileprivate var cacheNumberLabel: UILabel!
    fileprivate var logoutView: UIView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        buildaboutMeView()
        buildCleanCacheView()
        buildLogoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        print(self)
    }
    
    // MARK: - Build UI
    fileprivate func setUpUI() {
        navigationItem.title = "设置"
    }
    
    fileprivate func buildaboutMeView() {
        aboutMeView = UIView(frame: CGRect(x: 0, y: 10, width: ScreenWidth, height: subViewHeight))
        aboutMeView.backgroundColor = UIColor.white
        view.addSubview(aboutMeView!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.aboutMeViewClick))
        aboutMeView.addGestureRecognizer(tap)
        
        let aboutLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: subViewHeight))
        aboutLabel.text = "关于小熊"
        aboutLabel.font = UIFont.systemFont(ofSize: 16)
        aboutMeView.addSubview(aboutLabel)
        
        let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView.frame = CGRect(x: ScreenWidth - 20, y: (subViewHeight - 10) * 0.5, width: 5, height: 10)
        aboutMeView.addSubview(arrowImageView)
    }
    
    fileprivate func buildCleanCacheView() {
        cleanCacheView = UIView(frame: CGRect(x: 0, y: subViewHeight + 10, width: ScreenWidth, height: subViewHeight))
        cleanCacheView.backgroundColor = UIColor.white
        view.addSubview(cleanCacheView!)
        
        let cleanCacheLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: subViewHeight))
        cleanCacheLabel.text = "清理缓存"
        cleanCacheLabel.font = UIFont.systemFont(ofSize: 16)
        cleanCacheView.addSubview(cleanCacheLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.cleanCacheViewClick))
        cleanCacheView.addGestureRecognizer(tap)
        
        cacheNumberLabel = UILabel(frame: CGRect(x: 150, y: 0, width: ScreenWidth - 165, height: subViewHeight))
        cacheNumberLabel.textAlignment = NSTextAlignment.right
        cacheNumberLabel.textColor = UIColor.colorWithCustom(180, g: 180, b: 180)
        cacheNumberLabel.text = String().appendingFormat("%.2fM", FileTool.folderSize(LFBCachePath)).cleanDecimalPointZear()
        cleanCacheView.addSubview(cacheNumberLabel)
        
        let lineView = UIView(frame: CGRect(x: 10, y: -0.5, width: ScreenWidth - 10, height: 0.5))
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.08
        cleanCacheView.addSubview(lineView)
    }
    
    fileprivate func buildLogoutView() {
        logoutView = UIView(frame: CGRect(x: 0, y: cleanCacheView.frame.maxY + 20, width: ScreenHeight, height: subViewHeight))
        logoutView.backgroundColor = UIColor.white
        view.addSubview(logoutView)
        
        let logoutLabel = UILabel(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: subViewHeight))
        logoutLabel.text = "退出当前账号"
        logoutLabel.textColor = UIColor.colorWithCustom(60, g: 60, b: 60)
        logoutLabel.font = UIFont.systemFont(ofSize: 15)
        logoutLabel.textAlignment = NSTextAlignment.center
        logoutView.addSubview(logoutLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.logoutViewClick))
        logoutLabel.addGestureRecognizer(tap)
    }
    
    // MARK: - Action
    @objc func aboutMeViewClick() {
        let aboutVc = AboltAuthorViewController()
        navigationController?.pushViewController(aboutVc, animated: true)
    }
    
    @objc func cleanCacheViewClick() {
        weak var tmpSelf = self
        ProgressHUDManager.show()
        FileTool.cleanFolder(LFBCachePath) { () -> () in
            tmpSelf!.cacheNumberLabel.text = "0M"
            ProgressHUDManager.dismiss()
        }
    }
    
    @objc func logoutViewClick() {}
}
