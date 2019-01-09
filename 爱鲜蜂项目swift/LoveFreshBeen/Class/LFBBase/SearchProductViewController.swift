//
//  SearchProductViewController.swift
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

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class SearchProductViewController: AnimationViewController {
    
    fileprivate let contentScrollView = UIScrollView(frame: ScreenBounds)
    fileprivate let searchBar = UISearchBar()
    fileprivate var hotSearchView: SearchView?
    fileprivate var historySearchView: SearchView?
    fileprivate let cleanHistoryButton: UIButton = UIButton()
    fileprivate var searchCollectionView: LFBCollectionView?
    fileprivate var goodses: [Goods]?
    fileprivate var collectionHeadView: NotSearchProductsView?
    fileprivate var yellowShopCar: YellowShopCarView?
    
    // MARK: - Lief Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildContentScrollView()
        
        buildSearchBar()
        
        buildCleanHistorySearchButton()
        
        loadHotSearchButtonData()
        
        loadHistorySearchButtonData()
        
        buildsearchCollectionView()
        
        buildYellowShopCar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
        
        if searchCollectionView != nil && goodses?.count > 0 {
            searchCollectionView!.reloadData()
        }
    }
    
    deinit {
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
    }
    
    // MARK: - Build UI
    fileprivate func buildContentScrollView() {
        contentScrollView.backgroundColor = view.backgroundColor
        contentScrollView.alwaysBounceVertical = true
        contentScrollView.delegate = self
        view.addSubview(contentScrollView)
    }
    
    fileprivate func buildSearchBar() {
        
        (navigationController as! BaseNavigationController).backBtn.frame = CGRect(x: 0, y: 0, width: 10, height: 40)
        
        let tmpView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth * 0.8, height: 30))
        tmpView.backgroundColor = UIColor.white
        tmpView.layer.masksToBounds = true
        tmpView.layer.cornerRadius = 6
        tmpView.layer.borderColor = UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1).cgColor
        tmpView.layer.borderWidth = 0.2
        let image = UIImage.createImageFromView(tmpView)
        
        searchBar.frame = CGRect(x: 0, y: 0, width: ScreenWidth * 0.9, height: 30)
        searchBar.placeholder = "请输入商品名称"
        searchBar.barTintColor = UIColor.white
        searchBar.keyboardType = UIKeyboardType.default
        searchBar.setSearchFieldBackgroundImage(image, for: UIControl.State())
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        
        let navVC = navigationController as! BaseNavigationController
        let leftBtn = navigationItem.leftBarButtonItem?.customView as? UIButton
        leftBtn!.addTarget(self, action: #selector(SearchProductViewController.leftButtonClcik), for: UIControl.Event.touchUpInside)
        navVC.isAnimation = false
    }
    
    fileprivate func buildYellowShopCar() {
        
        weak var tmpSelf = self
        
        yellowShopCar = YellowShopCarView(frame: CGRect(x: ScreenWidth - 70, y: ScreenHeight - 70 - NavigationH, width: 61, height: 61), shopViewClick: { () -> () in
            let shopCarVC = ShopCartViewController()
            let nav = BaseNavigationController(rootViewController: shopCarVC)
            tmpSelf!.present(nav, animated: true, completion: nil)
        })
        yellowShopCar?.isHidden = true
        view.addSubview(yellowShopCar!)
    }
    
    fileprivate func loadHotSearchButtonData() {
        var array: [String]?
        var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        if historySearch == nil {
            historySearch = [String]()
            UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
        }
        weak var tmpSelf = self
        let pathStr = Bundle.main.path(forResource: "SearchProduct", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: pathStr!))
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
            array = (dict.object(forKey: "data")! as! NSDictionary).object(forKey: "hotquery") as? [String]
            if array?.count > 0 {
                hotSearchView = SearchView(frame: CGRect(x: 10, y: 20, width: ScreenWidth - 20, height: 100), searchTitleText: "热门搜索", searchButtonTitleTexts: array!) { (sender) -> () in
                    let str = sender.title(for: UIControl.State())
                    tmpSelf!.writeHistorySearchToUserDefault(str!)
                    tmpSelf!.searchBar.text = sender.title(for: UIControl.State())
                    tmpSelf!.loadProductsWithKeyword(sender.title(for: UIControl.State())!)
                }
                hotSearchView!.frame.size.height = hotSearchView!.searchHeight
                
                contentScrollView.addSubview(hotSearchView!)
            }
        }
    }
    
    fileprivate func loadHistorySearchButtonData() {
        if historySearchView != nil {
            historySearchView?.removeFromSuperview()
            historySearchView = nil
        }
        
        weak var tmpSelf = self;
        let array = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        if array?.count > 0 {
            historySearchView = SearchView(frame: CGRect(x: 10, y: hotSearchView!.frame.maxY + 20, width: ScreenWidth - 20, height: 0), searchTitleText: "历史记录", searchButtonTitleTexts: array!, searchButtonClickCallback: { (sender) -> () in
                tmpSelf!.searchBar.text = sender.title(for: UIControl.State())
                tmpSelf!.loadProductsWithKeyword(sender.title(for: UIControl.State())!)
            })
            historySearchView!.frame.size.height = historySearchView!.searchHeight
            
            contentScrollView.addSubview(historySearchView!)
            updateCleanHistoryButton(false)
        }
    }
    
    fileprivate func buildCleanHistorySearchButton() {
        cleanHistoryButton.setTitle("清 空 历 史", for: UIControl.State())
        cleanHistoryButton.setTitleColor(UIColor.colorWithCustom(163, g: 163, b: 163), for: UIControl.State())
        cleanHistoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cleanHistoryButton.backgroundColor = view.backgroundColor
        cleanHistoryButton.layer.cornerRadius = 5
        cleanHistoryButton.layer.borderColor = UIColor.colorWithCustom(200, g: 200, b: 200).cgColor
        cleanHistoryButton.layer.borderWidth = 0.5
        cleanHistoryButton.isHidden = true
        cleanHistoryButton.addTarget(self, action: #selector(SearchProductViewController.cleanSearchHistorySearch), for: UIControl.Event.touchUpInside)
        contentScrollView.addSubview(cleanHistoryButton)
    }
    
    fileprivate func updateCleanHistoryButton(_ hidden: Bool) {
        if historySearchView != nil {
            cleanHistoryButton.frame = CGRect(x: 0.1 * ScreenWidth, y: historySearchView!.frame.maxY + 20, width: ScreenWidth * 0.8, height: 40)
        }
        cleanHistoryButton.isHidden = hidden
    }
    
    fileprivate func buildsearchCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
        layout.headerReferenceSize = CGSize(width: 0, height: HomeCollectionViewCellMargin)
        
        searchCollectionView = LFBCollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64), collectionViewLayout: layout)
        searchCollectionView!.delegate = self
        searchCollectionView!.dataSource = self
        searchCollectionView!.backgroundColor = LFBGlobalBackgroundColor
        searchCollectionView!.register(HomeCell.self, forCellWithReuseIdentifier: "Cell")
        searchCollectionView?.isHidden = true
        collectionHeadView = NotSearchProductsView(frame: CGRect(x: 0, y: -80, width: ScreenWidth, height: 80))
        searchCollectionView?.addSubview(collectionHeadView!)
        searchCollectionView?.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 30, right: 0)
        searchCollectionView?.register(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        view.addSubview(searchCollectionView!)
    }
    
    // MARK: - Private Method
    fileprivate func writeHistorySearchToUserDefault(_ str: String) {
        var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        for text in historySearch! {
            if text == str {
                return
            }
        }
        historySearch!.append(str)
        UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
        loadHistorySearchButtonData()
    }
    
    // MARK: - Action
    @objc func cleanSearchHistorySearch() {
        var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        historySearch?.removeAll()
        UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
        loadHistorySearchButtonData()
        updateCleanHistoryButton(true)
    }
    
    @objc func leftButtonClcik() {
        searchBar.endEditing(false)
    }
    
    // MARK: - Private Method
    func loadProductsWithKeyword(_ keyWord: String?) {
        if keyWord == nil || keyWord?.count == 0 {
            return
        }
        
        ProgressHUDManager.setBackgroundColor(UIColor.white)
        ProgressHUDManager .showWithStatus("正在全力加载")
        
        weak var tmpSelf = self
        let time = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            SearchProducts.loadSearchData { (data, error) -> Void in
                if data?.data?.count > 0 {
                    tmpSelf?.goodses = data!.data!
                    tmpSelf?.searchCollectionView?.isHidden = false
                    tmpSelf?.yellowShopCar?.isHidden = false
                    tmpSelf?.searchCollectionView?.reloadData()
                    tmpSelf?.collectionHeadView?.setSearchProductLabelText(keyWord!)
                    tmpSelf?.searchCollectionView?.setContentOffset(CGPoint(x: 0, y: -80), animated: false)
                    ProgressHUDManager.dismiss()
                }
            }
        }
    }
}


extension SearchProductViewController: UISearchBarDelegate, UIScrollViewDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count > 0 {
            
            writeHistorySearchToUserDefault(searchBar.text!)
            
            loadProductsWithKeyword(searchBar.text!)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        searchBar.endEditing(false)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchCollectionView?.isHidden = true
            yellowShopCar?.isHidden = true
        }
    }
}


extension SearchProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return goodses?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCell
        cell.goods = goodses![(indexPath as NSIndexPath).row]
        weak var tmpSelf = self
        cell.addButtonClick = ({ (imageView) -> () in
            tmpSelf?.addProductsToBigShopCarAnimation(imageView)
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let itemSize = CGSize(width: (ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, height: 250)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if goodses?.count <= 0 || goodses == nil {
            return CGSize.zero
        }
        
        return CGSize(width: ScreenWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath) as! HomeCollectionFooterView

            footerView.setFooterTitle("无更多商品", textColor: UIColor.colorWithCustom(50, g: 50, b: 50))

            return footerView

        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailVC = ProductDetailViewController(goods: goodses![(indexPath as NSIndexPath).row])
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}





