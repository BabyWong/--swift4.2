//
//  CoupinRuleViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class CoupinRuleViewController: BaseViewController {
    
    fileprivate let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - NavigationH))
    fileprivate let loadProgressAnimationView: LoadProgressAnimationView = LoadProgressAnimationView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 3))
    var loadURLStr: String? {
        didSet {
            webView.loadRequest(URLRequest(url: URL(string: loadURLStr!)!))
        }
    }
    
    var navTitle: String? {
        didSet {
            navigationItem.title = navTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        buildWebView()
        webView.addSubview(loadProgressAnimationView)
    }
    
    fileprivate func buildWebView() {
        webView.delegate = self
        webView.backgroundColor = UIColor.white
        view.addSubview(webView)
    }
}

extension CoupinRuleViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadProgressAnimationView.startLoadProgressAnimation()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadProgressAnimationView.endLoadProgressAnimation()
    }
}
