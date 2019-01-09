//
//  ProductsViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ProductsViewController: AnimationViewController {
    
    fileprivate let headViewIdentifier   = "supermarketHeadView"
    fileprivate var lastOffsetY: CGFloat = 0
    fileprivate var isScrollDown         = false
    var productsTableView: LFBTableView?
    weak var delegate: ProductsViewControllerDelegate?
    var refreshUpPull:(() -> ())?
    
    fileprivate var goodsArr: [[Goods]]? {
        didSet {
            productsTableView?.reloadData()
        }
    }
    
    var supermarketData: Supermarket? {
        didSet {
            let aa = SupermarketResouce()
            self.goodsArr = Supermarket.searchCategoryMatchProducts(supermarketData?.data ?? aa)
        }
    }
    
    var categortsSelectedIndexPath: IndexPath? {
        didSet {
            productsTableView?.selectRow(at: IndexPath(row: 0, section: (categortsSelectedIndexPath! as NSIndexPath).row), animated: true, scrollPosition: .top)
        }
    }
    
    
    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(shopCarBuyProductNumberDidChange), name: NSNotification.Name(rawValue: LFBShopCarBuyProductNumberDidChangeNotification), object: nil)
        
        view = UIView(frame: CGRect(x: ScreenWidth * 0.25, y: 0, width: ScreenWidth * 0.75, height: ScreenHeight - NavigationH))
        buildProductsTableView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Build UI
    fileprivate func buildProductsTableView() {
        productsTableView = LFBTableView(frame: view.bounds, style: .plain)
        productsTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        productsTableView?.backgroundColor = LFBGlobalBackgroundColor
        productsTableView?.delegate = self
        productsTableView?.dataSource = self
        productsTableView?.register(SupermarketHeadView.self, forHeaderFooterViewReuseIdentifier: headViewIdentifier)
        productsTableView?.tableFooterView = buildProductsTableViewTableFooterView()
        
        let headView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: Selector(("startRefreshUpPull")))
        productsTableView?.mj_header = headView
        
        view.addSubview(productsTableView!)
    }
    
    fileprivate func buildProductsTableViewTableFooterView() -> UIView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: productsTableView!.width, height: 70))
        imageView.contentMode = UIView.ContentMode.center
        imageView.image = UIImage(named: "v2_common_footer")
        return imageView
    }
    
    // MARK: - 上拉刷新
    func startRefreshUpPull() {
        if refreshUpPull != nil {
            refreshUpPull!()
        }
    }
    
    // MARK: - Action 
    @objc func shopCarBuyProductNumberDidChange() {
        productsTableView?.reloadData()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if goodsArr?.count > 0 {
            return goodsArr![section].count
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return supermarketData?.data?.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProductCell.cellWithTableView(tableView)
        let goods = goodsArr![(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        cell.goods = goods
        
        weak var tmpSelf = self
        cell.addProductClick = { (imageView) -> () in
            tmpSelf?.addProductsAnimation(imageView)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headViewIdentifier) as! SupermarketHeadView
        if supermarketData?.data?.categories?.count > 0 && supermarketData!.data!.categories![section].name != nil {
            headView.titleLabel.text = supermarketData!.data!.categories![section].name
        }
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        
        if delegate != nil && delegate!.responds(to: #selector(ProductsViewControllerDelegate.didEndDisplayingHeaderView(_:))) && isScrollDown {
            delegate!.didEndDisplayingHeaderView!(section)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if delegate != nil && delegate!.responds(to: #selector(ProductsViewControllerDelegate.willDisplayHeaderView(_:))) && !isScrollDown {
            delegate!.willDisplayHeaderView!(section)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goods = goodsArr![(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let productDetailVC = ProductDetailViewController(goods: goods)
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension ProductsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if animationLayers?.count > 0 {
            let transitionLayer = animationLayers![0]
            transitionLayer.isHidden = true
        }
        
        isScrollDown = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
    }
    
}

@objc protocol ProductsViewControllerDelegate: NSObjectProtocol {
    @objc optional func didEndDisplayingHeaderView(_ section: Int)
    @objc optional func willDisplayHeaderView(_ section: Int)
}
