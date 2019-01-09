//
//  OrderViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class OrderViewController: BaseViewController {

    var orderTableView: LFBTableView!
    var orders: [Order]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的订单"
        
        bulidOrderTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func bulidOrderTableView() {
        orderTableView = LFBTableView(frame: view.bounds, style: UITableView.Style.plain)
        orderTableView.backgroundColor = view.backgroundColor
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.backgroundColor = UIColor.clear
        orderTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        view.addSubview(orderTableView)
        
        loadOderData()
    }
    
    fileprivate func loadOderData() {
        weak var tmpSelf = self
        OrderData.loadOrderData { (data, error) -> Void in
            tmpSelf!.orders = data?.data
            tmpSelf!.orderTableView.reloadData()
        }
    }

}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource, MyOrderCellDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyOrderCell.myOrderCell(tableView, indexPath: indexPath)
        cell.order = orders![(indexPath as NSIndexPath).row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func orderCellButtonDidClick(_ indexPath: IndexPath, buttonType: Int) {
        print(buttonType, (indexPath as NSIndexPath).row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailVC = OrderStatuslViewController()
        orderDetailVC.order = orders![(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(orderDetailVC, animated: true)
    }
}
