//
//  ShareManager.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ShareManager: NSObject {
    
    static fileprivate let blogURLStr = "http://www.jianshu.com/users/5fe7513c7a57/latest_articles"
    static fileprivate let authorImage = UIImage(named: "author")
    static fileprivate let shareText = "小熊Swift全新开源作品,高仿爱鲜蜂,配有blog讲解思路,喜欢的同学star点起来"
    
    class func shareToShareType(_ shareType: ShareType, vc: UIViewController) {
        
//        switch shareType {
//
//        case .weiXinMyFriend:
//            UMSocialData.default().extConfig.wechatSessionData.url = blogURLStr
//            UMSocialData.default().extConfig.wechatSessionData.title = "小熊Swift开源新作"
//
//
//            let shareURL = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: blogURLStr)
//
//            UMSocialDataService.default().postSNS(withTypes: [UMShareToWechatSession], content: shareText, image: authorImage, location: nil, urlResource: shareURL, presentedController: nil) { (response) -> Void in
//                if response?.responseCode.rawValue == UMSResponseCodeSuccess.rawValue {
//                    showSuccessAlert()
//                } else {
//                    showErrorAlert()
//                }
//            }
//
//            break
//
//        case .weiXinCircleOfFriends:
//
//            UMSocialData.default().extConfig.wechatTimelineData.url = blogURLStr
//            UMSocialData.default().extConfig.wechatTimelineData.title = "小熊Swift开源新作"
//            let shareURL = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: blogURLStr)
//            UMSocialDataService.default().postSNS(withTypes: [UMShareToWechatTimeline], content: shareText, image: authorImage, location: nil, urlResource: shareURL, presentedController: nil, completion: { (response) -> Void in
//                if response?.responseCode.rawValue == UMSResponseCodeSuccess.rawValue {
//                    showSuccessAlert()
//                } else {
//                    showErrorAlert()
//                }
//            })
//
//            break
//
//        case .sinaWeiBo:
//
//            UMSocialDataService.default().postSNS(withTypes: [UMShareToSina], content: shareText + "   下载地址" + "https://github.com/ZhongTaoTian", image: authorImage, location: nil, urlResource: nil, presentedController: vc, completion: { (response) -> Void in
//                if response?.responseCode.rawValue == UMSResponseCodeSuccess.rawValue {
//                    showSuccessAlert()
//                } else {
//                    showErrorAlert()
//                }
//            })
//            break
//
//        case .qqZone:
//
//            UMSocialData.default().extConfig.qzoneData.url = blogURLStr
//            UMSocialData.default().extConfig.qzoneData.title = "小熊Swift开源新作"
//            let shareURL = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: blogURLStr)
//
//            UMSocialDataService.default().postSNS(withTypes: [UMShareToQzone], content: shareText, image: authorImage, location: nil, urlResource: shareURL, presentedController: nil, completion: { (response) -> Void in
//                if response?.responseCode.rawValue == UMSResponseCodeSuccess.rawValue {
//                    showSuccessAlert()
//                } else {
//                    showErrorAlert()
//                }
//            })
//
//
//            break
//        }
    }
    
    class func showSuccessAlert() {
        
        let alert = UIAlertView(title: "成功", message: "分享成功", delegate: nil, cancelButtonTitle: "知道了")
        alert.show()
    }
    
    class func showErrorAlert() {
        
        let alert = UIAlertView(title: "失败", message: "分享失败", delegate: nil, cancelButtonTitle: "知道了")
        alert.show()
        
    }
}
