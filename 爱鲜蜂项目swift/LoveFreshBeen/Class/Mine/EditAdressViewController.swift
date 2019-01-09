//
//  EditAdressViewController.swift
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

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


enum EditAdressViewControllerType: Int {
    case add
    case edit
}

class EditAdressViewController: BaseViewController {
    
    fileprivate let deleteView = UIView()
    fileprivate let scrollView = UIScrollView()
    fileprivate let adressView = UIView()
    fileprivate var contactsTextField: UITextField?
    fileprivate var phoneNumberTextField: UITextField?
    fileprivate var cityTextField: UITextField?
    fileprivate var areaTextField: UITextField?
    fileprivate var adressTextField: UITextField?
    fileprivate var manButton: LeftImageRightTextButton?
    fileprivate var womenButton: LeftImageRightTextButton?
    fileprivate var selectCityPickView: UIPickerView?
    fileprivate var currentSelectedCityIndex = -1
    weak var topVC: MyAdressViewController?
    var vcType: EditAdressViewControllerType?
    var currentAdressRow: Int = -1
    
    fileprivate lazy var cityArray: [String]? = {
        let array = ["北京市", "上海市", "天津市", "广州市", "佛山市", "深圳市", "廊坊市", "武汉市", "苏州市", "无锡市"]
        return array
        }()
    
    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildNavigationItem()
        
        buildScrollView()
        
        buildAdressView()
        
        buildDeleteAdressView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
        
        if currentAdressRow != -1 && vcType == .edit {
            let adress = topVC!.adresses![currentAdressRow]
            contactsTextField?.text = adress.accept_name
            if adress.telphone?.count == 11 {
                let telphone = adress.telphone! as NSString
                phoneNumberTextField?.text = telphone.substring(with: NSMakeRange(0, 3)) + " " + telphone.substring(with: NSMakeRange(3, 4)) + " " + telphone.substring(with: NSMakeRange(7, 4))
            }
            
            if adress.telphone?.count == 13 {
                phoneNumberTextField?.text = adress.telphone
            }
            
            if adress.gender == "1" {
                manButton?.isSelected = true
            } else {
                womenButton?.isSelected = true
            }
            cityTextField?.text = adress.city_name
            let range = (adress.address! as NSString).range(of: " ")
            areaTextField?.text = (adress.address! as NSString).substring(to: range.location)
            adressTextField?.text = (adress.address! as NSString).substring(from: range.location + 1)
            
            deleteView.isHidden = false
        }
        
    }
    
    // MARK: - Method
    fileprivate func buildNavigationItem() {
        
        navigationItem.title = "修改地址"
        
        let rightItemButton = UIBarButtonItem.barButton("保存", titleColor: UIColor.lightGray, target: self, action: #selector(saveButtonClick))
        navigationItem.rightBarButtonItem = rightItemButton
    }
    
    fileprivate func buildDeleteAdressView() {
        deleteView.frame = CGRect(x: 0, y: adressView.frame.maxY + 10, width: view.width, height: 50)
        deleteView.backgroundColor = UIColor.white
        scrollView.addSubview(deleteView)
        
        let deleteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        deleteLabel.text = "删除当前地址"
        deleteLabel.textAlignment = NSTextAlignment.center
        deleteLabel.font = UIFont.systemFont(ofSize: 15)
        deleteView.addSubview(deleteLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteViewClick))
        deleteView.addGestureRecognizer(tap)
        deleteView.isHidden = true
    }
    
    fileprivate func buildScrollView() {
        scrollView.frame = view.bounds
        scrollView.backgroundColor = UIColor.clear
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    fileprivate func buildAdressView() {
        adressView.frame = CGRect(x: 0, y: 10, width: view.width, height: 300)
        adressView.backgroundColor = UIColor.white
        scrollView.addSubview(adressView)
        
        let viewHeight: CGFloat = 50
        let leftMargin: CGFloat = 15
        let labelWidth: CGFloat = 70
        buildUnchangedLabel(CGRect(x: leftMargin, y: 0, width: labelWidth, height: viewHeight), text: "联系人")
        buildUnchangedLabel(CGRect(x: leftMargin, y: 2 * viewHeight, width: labelWidth, height: viewHeight), text: "手机号码")
        buildUnchangedLabel(CGRect(x: leftMargin, y: 3 * viewHeight, width: labelWidth, height: viewHeight), text: "所在城市")
        buildUnchangedLabel(CGRect(x: leftMargin, y: 4 * viewHeight, width: labelWidth, height: viewHeight), text: "所在地区")
        buildUnchangedLabel(CGRect(x: leftMargin, y: 5 * viewHeight, width: labelWidth, height: viewHeight), text: "详细地址")
        
        let lineView = UIView(frame: CGRect(x: leftMargin, y: 49, width: view.width - 10, height: 1))
        lineView.alpha = 0.15
        lineView.backgroundColor = UIColor.lightGray
        adressView.addSubview(lineView)
        
        let textFieldWidth = view.width * 0.6
        let x = leftMargin + labelWidth + 10
        contactsTextField = UITextField()
        buildTextField(contactsTextField!, frame: CGRect(x: x, y: 0, width: textFieldWidth, height: viewHeight), placeholder: "收货人姓名", tag: 1)
        
        phoneNumberTextField = UITextField()
        buildTextField(phoneNumberTextField!, frame: CGRect(x: x, y: 2 * viewHeight, width: textFieldWidth, height: viewHeight), placeholder: "鲜蜂侠联系你的电话", tag: 2)
        
        cityTextField = UITextField()
        buildTextField(cityTextField!, frame: CGRect(x: x, y: 3 * viewHeight, width: textFieldWidth, height: viewHeight), placeholder: "请选择城市", tag: 3)
        
        areaTextField = UITextField()
        buildTextField(areaTextField!, frame: CGRect(x: x, y: 4 * viewHeight, width: textFieldWidth, height: viewHeight), placeholder: "请选择你的住宅,大厦或学校", tag: 4)
        
        adressTextField = UITextField()
        buildTextField(adressTextField!, frame: CGRect(x: x, y: 5 * viewHeight, width: textFieldWidth, height: viewHeight), placeholder: "请输入楼号门牌号等详细信息", tag: 5)
        
        manButton = LeftImageRightTextButton()
        buildGenderButton(manButton!, frame: CGRect(x: phoneNumberTextField!.frame.minX, y: 50, width: 100, height: 50), title: "先生", tag: 101)
        
        womenButton = LeftImageRightTextButton()
        buildGenderButton(womenButton!, frame: CGRect(x: manButton!.frame.maxX + 10, y: 50, width: 100, height: 50), title: "女士", tag: 102)
    }
    
    fileprivate func buildUnchangedLabel(_ frame: CGRect, text: String) {
        let label = UILabel(frame: frame)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = LFBTextBlackColor
        adressView.addSubview(label)
        
        let lineView = UIView(frame: CGRect(x: 15, y: frame.origin.y - 1, width: view.width - 10, height: 1))
        lineView.alpha = 0.15
        lineView.backgroundColor = UIColor.lightGray
        adressView.addSubview(lineView)
    }
    
    fileprivate func buildTextField(_ textField: UITextField, frame: CGRect, placeholder: String, tag: Int) {
        textField.frame = frame
        
        if 2 == tag {
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        if 3 == tag {
            selectCityPickView = UIPickerView()
            selectCityPickView!.delegate = self
            selectCityPickView!.dataSource = self
            textField.inputView = selectCityPickView
            textField.inputAccessoryView = buildInputView()
        }
        
        textField.tag = tag
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.delegate = self
        textField.textColor = LFBTextBlackColor
        adressView.addSubview(textField)
    }
    
    fileprivate func buildInputView() -> UIView {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 40))
        toolBar.backgroundColor = UIColor.white
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 1))
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        toolBar.addSubview(lineView)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.alpha = 0.8
        titleLabel.text = "选择城市"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.frame = CGRect(x: 0, y: 0, width: view.width, height: toolBar.height)
        toolBar.addSubview(titleLabel)
        
        let cancleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: toolBar.height))
        cancleButton.tag = 10
        cancleButton.addTarget(self, action: #selector(selectedCityTextFieldDidChange(_:)), for: UIControl.Event.touchUpInside)
        cancleButton.setTitle("取消", for: UIControl.State())
        cancleButton.setTitleColor(UIColor.colorWithCustom(82, g: 188, b: 248), for: UIControl.State())
        toolBar.addSubview(cancleButton)
        
        let determineButton = UIButton(frame: CGRect(x: view.width - 80, y: 0, width: 80, height: toolBar.height))
        determineButton.tag = 11
        determineButton.addTarget(self, action: #selector(selectedCityTextFieldDidChange(_:)), for: .touchUpInside)
        determineButton.setTitleColor(UIColor.colorWithCustom(82, g: 188, b: 248), for: UIControl.State())
        determineButton.setTitle("确定", for: UIControl.State())
        toolBar.addSubview(determineButton)
        
        return toolBar
    }
    
    fileprivate func buildGenderButton(_ button: LeftImageRightTextButton, frame: CGRect, title: String, tag: Int) {
        button.tag = tag
        button.setImage(UIImage(named: "v2_noselected"), for: UIControl.State())
        button.setImage(UIImage(named: "v2_selected"), for: UIControl.State.selected)
        button.addTarget(self, action: #selector(genderButtonClick(_:)), for: .touchUpInside)
        button.setTitle(title, for: UIControl.State())
        button.frame = frame
        button.setTitleColor(LFBTextBlackColor, for: UIControl.State())
        adressView.addSubview(button)
    }
    
    // MARK: - Action
    @objc func saveButtonClick() {
        if contactsTextField?.text?.count <= 1 {
            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: "我们需要你的大名~")
            return
        }
        
        if !manButton!.isSelected && !womenButton!.isSelected {
            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: "人妖么,不男不女的~")
            return
        }
        
        if phoneNumberTextField!.text?.count != 13 {
            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: "没电话,特么怎么联系你~")
            return
        }
        
        if cityTextField?.text?.count <= 0 {
            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: "你在哪个城市啊~空空的~")
            return
        }
        
        if areaTextField?.text?.count <= 2 {
            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: "你的位置啊~")
            return
        }
        
        if adressTextField?.text?.count <= 2 {
            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: "在哪里呢啊~上哪找你去啊~")
            return
        }
        
        if vcType == .add {
            let adress = Adress()
            setAdressModel(adress)
            if topVC?.adresses?.count == 0 || topVC?.adresses == nil {
                topVC?.adresses = []
            }
            
            topVC!.adresses!.insert(adress, at: 0)
        }
        
        if vcType == .edit {
            let adress = topVC!.adresses![currentAdressRow]
            setAdressModel(adress)
        }
        
        navigationController?.popViewController(animated: true)
        topVC?.adressTableView?.reloadData()
    }
    
    fileprivate func setAdressModel(_ adress: Adress) {
        adress.accept_name = contactsTextField!.text
        adress.telphone = phoneNumberTextField!.text
        adress.gender = manButton!.isSelected ? "1" : "2"
        adress.city_name = cityTextField!.text
        adress.address = areaTextField!.text! + " " + adressTextField!.text!
    }
    
    @objc func genderButtonClick(_ sender: UIButton) {
        
        switch sender.tag {
        case 101:
            manButton?.isSelected = true
            womenButton?.isSelected = false
            break
        case 102:
            manButton?.isSelected = false
            womenButton?.isSelected = true
            break
        default:
            break
        }
    }
    
    @objc func selectedCityTextFieldDidChange(_ sender: UIButton) {
        
        if sender.tag == 11 {
            if currentSelectedCityIndex != -1 {
                cityTextField?.text = cityArray![currentSelectedCityIndex]
            }
        }
        cityTextField!.endEditing(true)
    }
    
    @objc func deleteViewClick() {
        topVC!.adresses!.remove(at: currentAdressRow)
        navigationController?.popViewController(animated: true)
        topVC?.adressTableView?.reloadData()
    }
}


extension EditAdressViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 2 {
            if textField.text?.count == 13 {
                
                return false
                
            } else {
                
                if textField.text?.count == 3 || textField.text?.count == 8 {
                    textField.text = textField.text! + " "
                }
                
                return true
            }
        }
        
        return true
    }
    
}

extension EditAdressViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityArray!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityArray![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSelectedCityIndex = row
    }
    
}

