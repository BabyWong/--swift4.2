//
//  LFBActionSheetManger.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

enum ShareType: Int {
    case weiXinMyFriend = 1
    case weiXinCircleOfFriends = 2
    case sinaWeiBo = 3
    case qqZone = 4
}

class LFBActionSheet: NSObject, UIActionSheetDelegate {
    
    fileprivate var selectedShaerType: ((_ shareType: ShareType) -> ())?
    fileprivate var actionSheet: UIActionSheet?
    
    func showActionSheetViewShowInView(_ inView: UIView, selectedShaerType: @escaping ((_ shareType: ShareType) -> ())) {
        
        actionSheet = UIActionSheet(title: "分享到",
            delegate: self, cancelButtonTitle: "取消",
            destructiveButtonTitle: nil,
            otherButtonTitles: "微信好友", "微信朋友圈", "新浪微博", "QQ空间")
        
        self.selectedShaerType = selectedShaerType
        
        actionSheet?.show(in: inView)
        
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        print(buttonIndex)
        if selectedShaerType != nil {
            
            switch buttonIndex {

            case ShareType.weiXinMyFriend.rawValue:
                selectedShaerType!(.weiXinMyFriend)
                break
                
            case ShareType.weiXinCircleOfFriends.rawValue:
                selectedShaerType!(.weiXinCircleOfFriends)
                break
                
            case ShareType.sinaWeiBo.rawValue:
                selectedShaerType!(.sinaWeiBo)
                break
                
            case ShareType.qqZone.rawValue:
                selectedShaerType!(.qqZone)
                break
                
            default:
                break
            }
        }
    }
    
}
