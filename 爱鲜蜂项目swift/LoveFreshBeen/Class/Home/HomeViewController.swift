//
//  HomeViewController.swift
//  LoveFreshBee
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

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class HomeViewController: SelectedAdressViewController {
    fileprivate var flag: Int = -1
    fileprivate var headView: HomeTableHeadView?
    fileprivate var collectionView: LFBCollectionView!
    fileprivate var lastContentOffsetY: CGFloat = 0
    fileprivate var isAnimation: Bool = false
    fileprivate var headData: HeadResources?
    fileprivate var freshHot: FreshHot?
    
    // MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHomeNotification()
        
        buildCollectionView()
        
        buildTableHeadView()
        
        buildProessHud()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = LFBNavigationYellowColor
        
        if collectionView != nil {
            collectionView.reloadData()
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:- addNotifiation
    func addHomeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.homeTableHeadViewHeightDidChange(_:)), name: NSNotification.Name(rawValue: HomeTableHeadViewHeightDidChange), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.goodsInventoryProblem(_:)), name: NSNotification.Name(rawValue: HomeGoodsInventoryProblem), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.shopCarBuyProductNumberDidChange), name: NSNotification.Name(rawValue: LFBShopCarBuyProductNumberDidChangeNotification), object: nil)
    }
    
    // MARK:- Creat UI
    fileprivate func buildTableHeadView() {
        headView = HomeTableHeadView()
        
        headView?.delegate = self
        weak var tmpSelf = self
        
        HeadResources.loadHomeHeadData { (data, error) -> Void in
            if error == nil {
                tmpSelf?.headView?.headData = data
                tmpSelf?.headData = data
                tmpSelf?.collectionView.reloadData()
            }
        }
        
        collectionView.addSubview(headView!)
        FreshHot.loadFreshHotData { (data, error) -> Void in
            tmpSelf?.freshHot = data
            tmpSelf?.collectionView.reloadData()
            tmpSelf?.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        }
    }
    
    fileprivate func buildCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
        layout.headerReferenceSize = CGSize(width: 0, height: HomeCollectionViewCellMargin)
        
        collectionView = LFBCollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = LFBGlobalBackgroundColor
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.register(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        view.addSubview(collectionView)
        
        let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.headRefresh))
        refreshHeadView?.gifView?.frame = CGRect(x: 0, y: 30, width: 100, height: 100)
        collectionView.mj_header = refreshHeadView
    }
    
    // MARK: 刷新
    @objc func headRefresh() {
        headView?.headData = nil
        headData = nil
        freshHot = nil
        var headDataLoadFinish = false
        var freshHotLoadFinish = false
        
        weak var tmpSelf = self
        let time = DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            HeadResources.loadHomeHeadData { (data, error) -> Void in
                if error == nil {
                    headDataLoadFinish = true
                    tmpSelf?.headView?.headData = data
                    tmpSelf?.headData = data
                    if headDataLoadFinish && freshHotLoadFinish {
                        tmpSelf?.collectionView.reloadData()
                        tmpSelf?.collectionView.mj_header.endRefreshing()
                    }
                }
            }
            
            FreshHot.loadFreshHotData { (data, error) -> Void in
                freshHotLoadFinish = true
                tmpSelf?.freshHot = data
                if headDataLoadFinish && freshHotLoadFinish {
                    tmpSelf?.collectionView.reloadData()
                    tmpSelf?.collectionView.mj_header.endRefreshing()
                }
            }
        }
    }
    
    fileprivate func buildProessHud() {
        ProgressHUDManager.setBackgroundColor(UIColor.colorWithCustom(240, g: 240, b: 240))
        ProgressHUDManager.setFont(UIFont.systemFont(ofSize: 16))
    }
    
    // MARK: Notifiation Action
    @objc func homeTableHeadViewHeightDidChange(_ noti: Notification) {
        collectionView!.contentInset = UIEdgeInsets(top: noti.object as! CGFloat, left: 0, bottom: NavigationH, right: 0)
        collectionView!.setContentOffset(CGPoint(x: 0, y: -(collectionView!.contentInset.top)), animated: false)
        lastContentOffsetY = collectionView.contentOffset.y
    }
    
    @objc func goodsInventoryProblem(_ noti: Notification) {
        if let goodsName = noti.object as? String {
            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: goodsName + "  库存不足了\n先买这么多, 过段时间再来看看吧~")
        }
    }
    
    @objc func shopCarBuyProductNumberDidChange() {
        collectionView.reloadData()
    }
}

// MARK:- HomeHeadViewDelegate TableHeadViewAction
extension HomeViewController: HomeTableHeadViewDelegate {
    func tableHeadView(_ headView: HomeTableHeadView, focusImageViewClick index: Int) {
        if headData?.data?.focus?.count > 0 {
            let path = Bundle.main.path(forResource: "FocusURL", ofType: "plist")
            let array = NSArray(contentsOfFile: path!)
            let webVC = WebViewController(navigationTitle: headData!.data!.focus![index].name!, urlStr: array![index] as! String)
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func tableHeadView(_ headView: HomeTableHeadView, iconClick index: Int) {
        if headData?.data?.icons?.count > 0 {
            let webVC = WebViewController(navigationTitle: headData!.data!.icons![index].name!, urlStr: headData!.data!.icons![index].customURL!)
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
}

// MARK:- UICollectionViewDelegate UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if headData?.data?.activities?.count <= 0 || freshHot?.data?.count <= 0 {
            return 0
        }
        
        if section == 0 {
            return headData?.data?.activities?.count ?? 0
        } else if section == 1 {
            return freshHot?.data?.count ?? 0
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCell
        if headData?.data?.activities?.count <= 0 {
            return cell
        }
        
        if (indexPath as NSIndexPath).section == 0 {
            cell.activities = headData!.data!.activities![(indexPath as NSIndexPath).row]
        } else if (indexPath as NSIndexPath).section == 1 {
            cell.goods = freshHot!.data![(indexPath as NSIndexPath).row]
            weak var tmpSelf = self
            cell.addButtonClick = ({ (imageView) -> () in
                tmpSelf?.addProductsAnimation(imageView)
            })
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if headData?.data?.activities?.count <= 0 || freshHot?.data?.count <= 0 {
            return 0
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSize = CGSize.zero
        if (indexPath as NSIndexPath).section == 0 {
            itemSize = CGSize(width: ScreenWidth - HomeCollectionViewCellMargin * 2, height: 140)
        } else if (indexPath as NSIndexPath).section == 1 {
            itemSize = CGSize(width: (ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, height: 250)
        }
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: ScreenWidth, height: HomeCollectionViewCellMargin)
        } else if section == 1 {
            return CGSize(width: ScreenWidth, height: HomeCollectionViewCellMargin * 2)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: ScreenWidth, height: HomeCollectionViewCellMargin)
        } else if section == 1 {
            return CGSize(width: ScreenWidth, height: HomeCollectionViewCellMargin * 5)
        }
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 && ((indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 1) {
            return
        }
        
        if isAnimation {
            startAnimation(cell, offsetY: 80, duration: 1.0)
        }
    }
    
    fileprivate func startAnimation(_ view: UIView, offsetY: CGFloat, duration: TimeInterval) {
        
        view.transform = CGAffineTransform(translationX: 0, y: offsetY)
        
        UIView.animate(withDuration: duration, animations: { () -> Void in
            view.transform = CGAffineTransform.identity
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 && headData != nil && freshHot != nil && isAnimation {
            startAnimation(view, offsetY: 60, duration: 0.8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (indexPath as NSIndexPath).section == 1 && kind == UICollectionView.elementKindSectionHeader {
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as! HomeCollectionHeaderView
            
            return headView
        }
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath) as! HomeCollectionFooterView
        
        if (indexPath as NSIndexPath).section == 1 && kind == UICollectionView.elementKindSectionFooter {
            footerView.showLabel()
            footerView.tag = 100
        } else {
            footerView.hideLabel()
            footerView.tag = 1
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.moreGoodsClick(_:)))
        footerView.addGestureRecognizer(tap)
        
        return footerView
    }
    
    // MARK: 查看更多商品被点击
    @objc func moreGoodsClick(_ tap: UITapGestureRecognizer) {
        if tap.view?.tag == 100 {
            let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
            tabBarController.setSelectIndex(from: 0, to: 1)
        }

    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if animationLayers?.count > 0 {
            let transitionLayer = animationLayers![0]
            transitionLayer.isHidden = true
        }
        
        if scrollView.contentOffset.y <= scrollView.contentSize.height {
            isAnimation = lastContentOffsetY < scrollView.contentOffset.y
            lastContentOffsetY = scrollView.contentOffset.y
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 {
            let webVC = WebViewController(navigationTitle: headData!.data!.activities![(indexPath as NSIndexPath).row].name!, urlStr: headData!.data!.activities![(indexPath as NSIndexPath).row].customURL!)
            navigationController?.pushViewController(webVC, animated: true)
        } else {
            let productVC = ProductDetailViewController(goods: freshHot!.data![(indexPath as NSIndexPath).row])
            navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

