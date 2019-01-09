
////////////////////////////////////////////////////////////////////
//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| ^_^ |)                              //
//                         O\  =  /O                              //
//                      ____/`---'\____                           //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\---/''  |   |                       //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /--.--\  `. . ___                     //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=---='                              //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//         佛祖保佑            永无BUG              永不修改         //
////////////////////////////////////////////////////////////////////
/**
 *   ┏┓　　　┏┓
 * ┏┛┻━━━┛┻┓
 * ┃　　　　　　　┃
 * ┃　　　━　　　┃
 * ┃　┳┛　┗┳　┃
 * ┃　　　　　　　┃
 * ┃　　　┻　　　┃
 * ┃　　　　　　　┃
 * ┗━┓　　　┏━┛
 *    ┃　　　┃
 *    ┃　　　┃
 *    ┃　　　┗━━━┓
 *    ┃　　　　　　　┣┓
 *    ┃　　　　　　　┏┛
 *    ┗┓┓┏━┳┓┏┛
 *      ┃┫┫　┃┫┫
 *      ┗┻┛　┗┻┛
 *        神兽保佑
 *        代码无BUG!
 */
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var adViewController: ADViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 1.0)
        
//        setUM()
        
        setAppSubject()

        addNotification()

        buildKeyWindow()

        
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Method
    fileprivate func buildKeyWindow() {
        
        window = UIWindow(frame: ScreenBounds)
        window!.makeKeyAndVisible()
        
        let isFristOpen = UserDefaults.standard.object(forKey: "isFristOpenApp")
        
        if isFristOpen == nil {
            window?.rootViewController = GuideViewController()
            UserDefaults.standard.set("isFristOpenApp", forKey: "isFristOpenApp")
        } else {
            loadADRootViewController()
        }
    }
    
    func loadADRootViewController() {
        adViewController = ADViewController()
        
        weak var tmpSelf = self
        MainAD.loadADData { (data, error) -> Void in
            if data?.data?.img_name != nil {
                tmpSelf!.adViewController!.imageName = data!.data!.img_name
                tmpSelf!.window?.rootViewController = self.adViewController
            }
        }
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showMainTabbarControllerSucess(_:)), name: NSNotification.Name(rawValue: ADImageLoadSecussed), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showMainTabbarControllerFale), name: NSNotification.Name(rawValue: ADImageLoadFail), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.shoMainTabBarController), name: NSNotification.Name(rawValue: GuideViewControllerDidFinish), object: nil)
    }
    
    func setUM() {
//        UMSocialGlobal.value(forKey: "569f662be0f55a0efa0001cc")//<#T##String#>) setAppKey(
//        UMSocialWechatHandler.setAppId(<#T##UMSocialHandler#>) setAppId("wxb81a61739edd3054", appSecret: "c62eba630d950ff107e62fe08391d19d", url: "https://github.com/ZhongTaoTian")
//        UMSocialQQHandler.setQQWithAppId("1105057589", appKey: "Zsc4rA9VaOjexv8z", url: "http://www.jianshu.com/users/5fe7513c7a57/latest_articles")
//        UMSocialWechatHandler.openNewSinaSSO(withAppKey: "1939108327", redirectURL: "http://sns.whalecloud.com/sina2/callback")
//        
//        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToWechatSession, UMShareToQzone, UMShareToQQ, UMShareToSina, UMShareToWechatTimeline])
    }
    
    // MARK: - Action
    @objc func showMainTabbarControllerSucess(_ noti: Notification) {
        let adImage = noti.object as! UIImage
        let mainTabBar = MainTabBarController()
        mainTabBar.adImage = adImage
        window?.rootViewController = mainTabBar
    }
    
    @objc func showMainTabbarControllerFale() {
        window!.rootViewController = MainTabBarController()
    }
    
    @objc func shoMainTabBarController() {
        window!.rootViewController = MainTabBarController()
    }
    
    // MARK:- privete Method
    // MARK:主题设置
    fileprivate func setAppSubject() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.backgroundColor = UIColor.white
        tabBarAppearance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        let navBarnAppearance = UINavigationBar.appearance()
        navBarnAppearance.isTranslucent = false
    }
}



