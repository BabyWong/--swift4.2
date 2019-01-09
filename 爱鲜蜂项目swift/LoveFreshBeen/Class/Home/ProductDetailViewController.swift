//
//  ProductDetailViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ProductDetailViewController: BaseViewController {
    
    fileprivate let grayBackgroundColor = UIColor.colorWithCustom(248, g: 248, b: 248)
    
    fileprivate var scrollView: UIScrollView?
    fileprivate var productImageView: UIImageView?
    fileprivate var titleNameLabel: UILabel?
    fileprivate var priceView: DiscountPriceView?
    fileprivate var presentView: UIView?
    fileprivate var detailView: UIView?
    fileprivate var brandTitleLabel: UILabel?
    fileprivate var detailTitleLabel: UILabel?
    fileprivate var promptView: UIView?
    fileprivate let nameView = UIView()
    fileprivate var detailImageView: UIImageView?
    fileprivate var bottomView: UIView?
    fileprivate var yellowShopCar: YellowShopCarView?
    fileprivate var goods: Goods?
    fileprivate var buyView: BuyView?
    fileprivate let shareActionSheet: LFBActionSheet = LFBActionSheet()
    
    init () {
        super.init(nibName: nil, bundle: nil)
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView?.backgroundColor = UIColor.white
        scrollView?.bounces = false
        view.addSubview(scrollView!)
        
        productImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 400))
        productImageView?.contentMode = UIView.ContentMode.scaleAspectFill
        scrollView!.addSubview(productImageView!)
        
        buildLineView(CGRect(x: 0, y: productImageView!.frame.maxY - 1, width: ScreenWidth, height: 1), addView: productImageView!)
        
        let leftMargin: CGFloat = 15
        
        nameView.frame = CGRect(x: 0, y: productImageView!.frame.maxY, width: ScreenWidth, height: 80)
        nameView.backgroundColor = UIColor.white
        scrollView!.addSubview(nameView)
        
        titleNameLabel = UILabel(frame: CGRect(x: leftMargin, y: 0, width: ScreenWidth, height: 60))
        titleNameLabel?.textColor = UIColor.black
        titleNameLabel?.font = UIFont.systemFont(ofSize: 16)
        nameView.addSubview(titleNameLabel!)
        
        buildLineView(CGRect(x: 0, y: 80 - 1, width: ScreenWidth, height: 1), addView: nameView)
        
        presentView = UIView(frame: CGRect(x: 0, y: nameView.frame.maxY, width: ScreenWidth, height: 50))
        presentView?.backgroundColor = grayBackgroundColor
        scrollView?.addSubview(presentView!)
        
        let presentButton = UIButton(frame: CGRect(x: leftMargin, y: 13, width: 55, height: 24))
        presentButton.setTitle("促销", for: UIControl.State())
        presentButton.backgroundColor = UIColor.colorWithCustom(252, g: 85, b: 88)
        presentButton.layer.cornerRadius = 8
        presentButton.setTitleColor(UIColor.white, for: UIControl.State())
        presentView?.addSubview(presentButton)
        
        let presentLabel = UILabel(frame: CGRect(x: 100, y: 0, width: ScreenWidth * 0.7, height: 50))
        presentLabel.textColor = UIColor.black
        presentLabel.font = UIFont.systemFont(ofSize: 14)
        presentLabel.text = "买一赠一 (赠品有限,赠完为止)"
        presentView?.addSubview(presentLabel)
        
        buildLineView(CGRect(x: 0, y: 49, width: ScreenWidth, height: 1), addView: presentView!)
        
        detailView = UIView(frame: CGRect(x: 0, y: presentView!.frame.maxY, width: ScreenWidth, height: 150))
        detailView?.backgroundColor = grayBackgroundColor
        scrollView?.addSubview(detailView!)
        
        let brandLabel = UILabel(frame: CGRect(x: leftMargin, y: 0, width: 80, height: 50))
        brandLabel.textColor = UIColor.colorWithCustom(150, g: 150, b: 150)
        brandLabel.text = "品       牌"
        brandLabel.font = UIFont.systemFont(ofSize: 14)
        detailView?.addSubview(brandLabel)
        
        brandTitleLabel = UILabel(frame: CGRect(x: 100, y: 0, width: ScreenWidth * 0.6, height: 50))
        brandTitleLabel?.textColor = UIColor.black
        brandTitleLabel?.font = UIFont.systemFont(ofSize: 14)
        detailView?.addSubview(brandTitleLabel!)
        
        buildLineView(CGRect(x: 0, y: 50 - 1, width: ScreenWidth, height: 1), addView: detailView!)
        
        let detailLabel = UILabel(frame: CGRect(x: leftMargin, y: 50, width: 80, height: 50))
        detailLabel.text = "产品规格"
        detailLabel.textColor = brandLabel.textColor
        detailLabel.font = brandTitleLabel!.font
        detailView?.addSubview(detailLabel)
        
        detailTitleLabel = UILabel(frame: CGRect(x: 100, y: 50, width: ScreenWidth * 0.6, height: 50))
        detailTitleLabel?.textColor = brandTitleLabel!.textColor
        detailTitleLabel?.font = brandTitleLabel!.font
        detailView?.addSubview(detailTitleLabel!)
        
        buildLineView(CGRect(x: 0, y: 100 - 1, width: ScreenWidth, height: 1), addView: detailView!)
        
        let textImageLabel = UILabel(frame: CGRect(x: leftMargin, y: 100, width: 80, height: 50))
        textImageLabel.textColor = brandLabel.textColor
        textImageLabel.font = brandLabel.font
        textImageLabel.text = "图文详情"
        detailView?.addSubview(textImageLabel)
        
        promptView = UIView(frame: CGRect(x: 0, y: detailView!.frame.maxY, width: ScreenWidth, height: 80))
        promptView?.backgroundColor = UIColor.white
        scrollView?.addSubview(promptView!)
        
        let promptLabel = UILabel(frame: CGRect(x: 15, y: 5, width: ScreenWidth, height: 20))
        promptLabel.text = "温馨提示:"
        promptLabel.textColor = UIColor.black
        promptView?.addSubview(promptLabel)
        
        let promptDetailLabel = UILabel(frame: CGRect(x: 15, y: 20, width: ScreenWidth - 30, height: 60))
        promptDetailLabel.textColor = presentButton.backgroundColor
        promptDetailLabel.numberOfLines = 2
        promptDetailLabel.text = "商品签收后, 如有问题请您在24小时内联系4008484842,并将商品及包装保留好,拍照发给客服"
        promptDetailLabel.font = UIFont.systemFont(ofSize: 14)
        promptView?.addSubview(promptDetailLabel)
        
        buildLineView(CGRect(x: 0, y: ScreenHeight - 51 - NavigationH, width: ScreenWidth, height: 1), addView: view)
        
        bottomView = UIView(frame: CGRect(x: 0, y: ScreenHeight - 50 - NavigationH, width: ScreenWidth, height: 50))
        bottomView?.backgroundColor = grayBackgroundColor
        view.addSubview(bottomView!)
        
        let addProductLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 70, height: 50))
        addProductLabel.text = "添加商品:"
        addProductLabel.textColor = UIColor.black
        addProductLabel.font = UIFont.systemFont(ofSize: 15)
        bottomView?.addSubview(addProductLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(goods: Goods) {
        self.init()
        self.goods = goods
        productImageView?.sd_setImage(with: URL(string: goods.img!), placeholderImage: UIImage(named: "v2_placeholder_square"))
        titleNameLabel?.text = goods.name
        priceView = DiscountPriceView(price: goods.price, marketPrice: goods.market_price)
        priceView?.frame = CGRect(x: 15, y: 40, width: ScreenWidth * 0.6, height: 40)
        nameView.addSubview(priceView!)
        
        if goods.pm_desc == "买一赠一" {
            presentView?.frame.size.height = 50
            presentView?.isHidden = false
        } else {
            presentView?.frame.size.height = 0
            presentView?.isHidden = true
            detailView?.frame.origin.y -= 50
            promptView?.frame.origin.y -= 50
        }
        
        brandTitleLabel?.text = goods.brand_name
        detailTitleLabel?.text = goods.specifics
        
        detailImageView = UIImageView(image: UIImage(named: "aaaa"))
        let scale: CGFloat = 320.0 / ScreenWidth
        detailImageView?.frame = CGRect(x: 0, y: promptView!.frame.maxY, width: ScreenWidth, height: detailImageView!.height / scale)
        scrollView?.addSubview(detailImageView!)
        scrollView?.contentSize = CGSize(width: ScreenWidth, height: detailImageView!.frame.maxY + 50 + NavigationH)
        
        buildNavigationItem(goods.name!)
        
        buyView = BuyView(frame: CGRect(x: 85, y: 12, width: 80, height: 25))
        buyView!.zearIsShow = true
        buyView!.goods = goods
        bottomView?.addSubview(buyView!)
        
        weak var tmpSelf = self
        yellowShopCar = YellowShopCarView(frame: CGRect(x: ScreenWidth - 70, y: 50 - 61 - 10, width: 61, height: 61), shopViewClick: { () -> () in
            let shopCarVC = ShopCartViewController()
            let nav = BaseNavigationController(rootViewController: shopCarVC)
            tmpSelf!.present(nav, animated: true, completion: nil)
        })
        
        bottomView!.addSubview(yellowShopCar!)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
        
        if goods != nil {
            buyView?.goods = goods
        }
        
        (navigationController as! BaseNavigationController).isAnimation = true
    }
    
    // MARK: - Build UI
    fileprivate func buildLineView(_ frame: CGRect, addView: UIView) {
        let lineView = UIView(frame: frame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        addView.addSubview(lineView)
    }
    
    fileprivate func buildNavigationItem(_ titleText: String) {
        self.navigationItem.title = titleText
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton("分享", titleColor: UIColor.colorWithCustom(100, g: 100, b: 100), target: self, action: #selector(rightItemClick))
    }
    
    // MARK: - Action
    @objc func rightItemClick() {
        shareActionSheet.showActionSheetViewShowInView(view) { (shareType) -> () in
            ShareManager.shareToShareType(shareType, vc: self)
        }
    }
}
