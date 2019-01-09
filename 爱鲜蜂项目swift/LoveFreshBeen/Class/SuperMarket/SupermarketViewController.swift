//
//  SupermarketViewController.swift
//  LoveFreshBee
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class SupermarketViewController: SelectedAdressViewController {
    
    fileprivate var supermarketData: Supermarket?
    fileprivate var categoryTableView: LFBTableView!
    fileprivate var productsVC: ProductsViewController!
    
    // flag
    fileprivate var categoryTableViewIsLoadFinish = false
    fileprivate var productTableViewIsLoadFinish  = false
  
    // MARK : Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotification()

        showProgressHUD()
                
        bulidCategoryTableView()
        
        bulidProductsViewController()
        
        loadSupermarketData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if productsVC.productsTableView != nil {
            productsVC.productsTableView?.reloadData()
        }
        
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
        navigationController?.navigationBar.barTintColor = LFBNavigationYellowColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(shopCarBuyProductNumberDidChange), name: NSNotification.Name(rawValue: LFBShopCarBuyProductNumberDidChangeNotification), object: nil)   
    }
    
    @objc func shopCarBuyProductNumberDidChange() {
        if productsVC.productsTableView != nil {
            productsVC.productsTableView!.reloadData()
        }
    }
    
    // MARK:- Creat UI
    fileprivate func bulidCategoryTableView() {
        categoryTableView = LFBTableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth * 0.25, height: ScreenHeight), style: .plain)
        categoryTableView.backgroundColor = LFBGlobalBackgroundColor
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.showsHorizontalScrollIndicator = false
        categoryTableView.showsVerticalScrollIndicator = false
        categoryTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: NavigationH, right: 0)
        categoryTableView.isHidden = true;
        view.addSubview(categoryTableView)
    }
    
    fileprivate func bulidProductsViewController() {
        productsVC = ProductsViewController()
        productsVC.delegate = self
        productsVC.view.isHidden = true
        addChild(productsVC)
        view.addSubview(productsVC.view)
        
        weak var tmpSelf = self
        productsVC.refreshUpPull = {
            let time = DispatchTime.now() + Double(Int64(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: { () -> Void in
                Supermarket.loadSupermarketData { (data, error) -> Void in
                    if error == nil {
                        tmpSelf!.supermarketData = data
                        tmpSelf!.productsVC.supermarketData = data
                        tmpSelf?.productsVC.productsTableView?.mj_header.endRefreshing()
                        tmpSelf!.categoryTableView.reloadData()
                        tmpSelf!.categoryTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
                    }
                }
            })
        }
    }
    
    fileprivate func loadSupermarketData() {
        let time = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            weak var tmpSelf = self
            Supermarket.loadSupermarketData { (data, error) -> Void in
                if error == nil {
                    tmpSelf!.supermarketData = data
                    tmpSelf!.categoryTableView.reloadData()
//                    tmpSelf!.categoryTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
                    tmpSelf!.productsVC.supermarketData = data
                    tmpSelf!.categoryTableViewIsLoadFinish = true
                    tmpSelf!.productTableViewIsLoadFinish = true
                    if tmpSelf!.categoryTableViewIsLoadFinish && tmpSelf!.productTableViewIsLoadFinish {
                        tmpSelf!.categoryTableView.isHidden = false
                        tmpSelf!.productsVC.productsTableView!.isHidden = false
                        tmpSelf!.productsVC.view.isHidden = false
                        tmpSelf!.categoryTableView.isHidden = false
                        ProgressHUDManager.dismiss()
                        tmpSelf!.view.backgroundColor = LFBGlobalBackgroundColor
                    }
                }
            }
        }
    }
    
    // MARK: - Private Method
    fileprivate func showProgressHUD() {
        ProgressHUDManager.setBackgroundColor(UIColor.colorWithCustom(230, g: 230, b: 230))
        view.backgroundColor = UIColor.white
        if !ProgressHUDManager.isVisible() {
            ProgressHUDManager.showWithStatus("正在加载中")
        }
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SupermarketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supermarketData?.data?.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoryCell.cellWithTableView(tableView)
        cell.categorie = supermarketData!.data!.categories![(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if productsVC != nil {
            productsVC.categortsSelectedIndexPath = indexPath
        }
    }
    
}

// MARK: - SupermarketViewController
extension SupermarketViewController: ProductsViewControllerDelegate {
    
    func didEndDisplayingHeaderView(_ section: Int) {
        categoryTableView.selectRow(at: IndexPath(row: section + 1, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
    }

    func willDisplayHeaderView(_ section: Int) {
        categoryTableView.selectRow(at: IndexPath(row: section, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
    }
}
