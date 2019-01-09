//
//  ShopCartViewController.swift
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


class ShopCartViewController: BaseViewController {
    
    let userShopCar = UserShopCarTool.sharedUserShopCar
    
    fileprivate let shopImageView         = UIImageView()
    fileprivate let emptyLabel            = UILabel()
    fileprivate let emptyButton           = UIButton(type: .custom)
    fileprivate var receiptAdressView: ReceiptAddressView?
    fileprivate var tableHeadView         = UIView()
    fileprivate let signTimeLabel         = UILabel()
    fileprivate let reserveLabel          = UILabel()
    fileprivate let signTimePickerView    = UIPickerView()
    fileprivate let commentsView          = ShopCartCommentsView()
    fileprivate let supermarketTableView  = LFBTableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64 - 50), style: .plain)
    fileprivate let tableFooterView       = ShopCartSupermarketTableFooterView()
    fileprivate var isFristLoadData       = false
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNSNotification()
        
        buildNavigationItem()
        
        buildEmptyUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        weak var tmpSelf = self
        
        if userShopCar.isEmpty() {
            showshopCarEmptyUI()
        } else {
            
            if !ProgressHUDManager.isVisible() {
                ProgressHUDManager.setBackgroundColor(UIColor.colorWithCustom(230, g: 230, b: 230))
                ProgressHUDManager.showWithStatus("正在加载商品信息")
            }
            
            let time = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
                
                tmpSelf!.showProductView()
                ProgressHUDManager.dismiss()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK - Add Notification KVO Action
    fileprivate func addNSNotification() {
        NotificationCenter.default.addObserver(self, selector: Selector(("shopCarProductsDidRemove")), name: NSNotification.Name(rawValue: LFBShopCarDidRemoveProductNSNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: Selector(("shopCarBuyPriceDidChange")), name: NSNotification.Name(rawValue: LFBShopCarBuyPriceDidChangeNotification), object: nil)
    }
    
    func shopCarProductsDidRemove() {
        
        if UserShopCarTool.sharedUserShopCar.isEmpty() {
            showshopCarEmptyUI()
        }
        
        self.supermarketTableView.reloadData()
    }
    
    func shopCarBuyPriceDidChange() {
        tableFooterView.priceLabel.text = UserShopCarTool.sharedUserShopCar.getAllProductsPrice()
    }
    
    // MARK: - Build UI
    fileprivate func buildNavigationItem() {
        navigationItem.title = "购物车"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButton(UIImage(named: "v2_goback")!, target: self, action: #selector(leftNavigitonItemClick))
    }
    
    fileprivate func buildEmptyUI() {
        shopImageView.image = UIImage(named: "v2_shop_empty")
        shopImageView.contentMode = UIView.ContentMode.center
        shopImageView.frame = CGRect(x: (view.width - shopImageView.width) * 0.5, y: view.height * 0.25, width: shopImageView.width, height: shopImageView.height)
        shopImageView.isHidden = true
        view.addSubview(shopImageView)
        
        emptyLabel.text = "亲,购物车空空的耶~赶紧挑好吃的吧"
        emptyLabel.textColor = UIColor.colorWithCustom(100, g: 100, b: 100)
        emptyLabel.textAlignment = NSTextAlignment.center
        emptyLabel.frame = CGRect(x: 0, y: shopImageView.frame.maxY + 55, width: view.width, height: 50)
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)
        
        emptyButton.frame = CGRect(x: (view.width - 150) * 0.5, y: emptyLabel.frame.maxY + 15, width: 150, height: 30)
        emptyButton.setBackgroundImage(UIImage(named: "btn.png"), for: UIControl.State())
        emptyButton.setTitle("去逛逛", for: UIControl.State())
        emptyButton.setTitleColor(UIColor.colorWithCustom(100, g: 100, b: 100), for: UIControl.State())
        emptyButton.addTarget(self, action: #selector(ShopCartViewController.leftNavigitonItemClick), for: UIControl.Event.touchUpInside)
        emptyButton.isHidden = true
        view.addSubview(emptyButton)
    }
    
    fileprivate func showProductView() {
        
        if !isFristLoadData {
            
            buildTableHeadView()
            
            buildSupermarketTableView()
            
            isFristLoadData = true
        }
    }
    
    fileprivate func buildTableHeadView() {
        tableHeadView.backgroundColor = view.backgroundColor
        tableHeadView.frame = CGRect(x: 0, y: 0, width: view.width, height: 250)
        
        buildReceiptAddress()
        
        buildMarketView()
        
        buildSignTimeView()
        
        buildSignComments()
    }
    
    fileprivate func buildSupermarketTableView() {
        supermarketTableView.tableHeaderView = tableHeadView
        tableFooterView.frame = CGRect(x: 0, y: ScreenHeight - 64 - 50, width: ScreenWidth, height: 50)
        view.addSubview(tableFooterView)
        tableFooterView.delegate = self
        supermarketTableView.delegate = self
        supermarketTableView.dataSource = self
        supermarketTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        supermarketTableView.rowHeight = ShopCartRowHeight
        supermarketTableView.backgroundColor = view.backgroundColor
        view.addSubview(supermarketTableView)
    }
    
    fileprivate func buildReceiptAddress() {
        
        receiptAdressView = ReceiptAddressView(frame: CGRect(x: 0, y: 10, width: view.width, height: 70), modifyButtonClickCallBack: { () -> () in
            
        })
        
        tableHeadView.addSubview(receiptAdressView!)
        
        if UserInfo.sharedUserInfo.hasDefaultAdress() {
            receiptAdressView?.adress = UserInfo.sharedUserInfo.defaultAdress()
        } else {
            weak var tmpSelf = self
            AdressData.loadMyAdressData { (data, error) -> Void in
                if error == nil {
                    if data!.data?.count > 0 {
                        UserInfo.sharedUserInfo.setAllAdress(data!.data!)
                        tmpSelf!.receiptAdressView?.adress = UserInfo.sharedUserInfo.defaultAdress()
                    }
                }
            }
        }
    }
    
    fileprivate func buildMarketView() {
        let markerView = ShopCartMarkerView(frame: CGRect(x: 0, y: 90, width: ScreenWidth, height: 60))
        
        tableHeadView.addSubview(markerView)
    }
    
    fileprivate func buildSignTimeView() {
        let signTimeView = UIView(frame: CGRect(x: 0, y: 150, width: view.width, height: ShopCartRowHeight))
        signTimeView.backgroundColor = UIColor.white
        tableHeadView.addSubview(signTimeView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(modifySignTimeViewClick))
        tableHeadView.addGestureRecognizer(tap)
        
        let signTimeTitleLabel = UILabel()
        signTimeTitleLabel.text = "收货时间"
        signTimeTitleLabel.textColor = UIColor.black
        signTimeTitleLabel.font = UIFont.systemFont(ofSize: 15)
        signTimeTitleLabel.sizeToFit()
        signTimeTitleLabel.frame = CGRect(x: 15, y: 0, width: signTimeTitleLabel.width, height: ShopCartRowHeight)
        signTimeView.addSubview(signTimeTitleLabel)
        
        signTimeLabel.frame = CGRect(x: signTimeTitleLabel.frame.maxX + 10, y: 0, width: view.width * 0.5, height: ShopCartRowHeight)
        signTimeLabel.textColor = UIColor.red
        signTimeLabel.font = UIFont.systemFont(ofSize: 15)
        signTimeLabel.text = "闪电送,及时达"
        signTimeView.addSubview(signTimeLabel)
        
        reserveLabel.text = "可预定"
        reserveLabel.backgroundColor = UIColor.white
        reserveLabel.textColor = UIColor.red
        reserveLabel.font = UIFont.systemFont(ofSize: 15)
        reserveLabel.frame = CGRect(x: view.width - 72, y: 0, width: 60, height: ShopCartRowHeight)
        signTimeView.addSubview(reserveLabel)
        
        let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView.frame = CGRect(x: view.width - 15, y: (ShopCartRowHeight - arrowImageView.height) * 0.5, width: arrowImageView.width, height: arrowImageView.height)
        signTimeView.addSubview(arrowImageView)
        
    }
    
    fileprivate func buildSignComments() {
        commentsView.frame = CGRect(x: 0, y: 200, width: view.width, height: ShopCartRowHeight)
        tableHeadView.addSubview(commentsView)
    }
    
    fileprivate func lineView(_ frame: CGRect) -> UIView {
        let lineView = UIView(frame: frame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        return lineView
    }
    
    // MARK: - Private Method
    fileprivate func showshopCarEmptyUI() {
        shopImageView.isHidden = false
        emptyButton.isHidden = false
        emptyLabel.isHidden = false
        supermarketTableView.isHidden = true
    }
    
    // MARK: -  Action
    @objc func leftNavigitonItemClick() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: LFBShopCarBuyProductNumberDidChangeNotification), object: nil, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func modifySignTimeViewClick() {
        print("修改收货时间")
    }
    
    func selectedSignTimeTextFieldDidChange(_ sender: UIButton) {
        
    }
    
    // MARK: - Override SuperMethod
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        commentsView.textField.endEditing(true)
    }
}

// MARK: - ShopCartSupermarketTableFooterViewDelegate
extension ShopCartViewController: ShopCartSupermarketTableFooterViewDelegate {
    
    func supermarketTableFooterDetermineButtonClick() {
        let orderPayVC = OrderPayWayViewController()
        navigationController?.pushViewController(orderPayVC, animated: true)
    }
}

// MARK: - UITableViewDeletate UITableViewDataSource
extension ShopCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserShopCarTool.sharedUserShopCar.getShopCarProductsClassifNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShopCartCell.shopCarCell(tableView)
        cell.goods = UserShopCarTool.sharedUserShopCar.getShopCarProducts()[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        commentsView.textField.endEditing(true)
    }
}





