//
//  QRCodeViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit
import AVFoundation

class QRCodeViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    fileprivate var titleLabel = UILabel()
    fileprivate var captureSession: AVCaptureSession?
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var animationLineView = UIImageView()
    fileprivate var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildNavigationItem()
        
        buildInputAVCaptureDevice()
        
        buildFrameImageView()
        
        buildTitleLabel()
        
        buildAnimationLineView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    // MARK: - Build UI
    fileprivate func buildNavigationItem() {
        navigationItem.title = "店铺二维码"
        
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
    }
    
    fileprivate func buildTitleLabel() {
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.frame = CGRect(x: 0, y: 340, width: ScreenWidth, height: 30)
        titleLabel.textAlignment = NSTextAlignment.center
        view.addSubview(titleLabel)
    }
    
    fileprivate func buildInputAVCaptureDevice() {
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) //AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//        let captureDevice = AVCaptureDevice.devices(for: AVMediaType.video)
        titleLabel.text = "将店铺二维码对准方块内既可收藏店铺"
        var input: AVCaptureInput?
        do {
            input = try? AVCaptureDeviceInput(device: captureDevice!)
        } catch  {
            titleLabel.text = "没有摄像头你描个蛋啊~换真机试试"
            return
        }
        
        if input == nil {
            titleLabel.text = "没有摄像头你描个蛋啊~换真机试试"
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession = AVCaptureSession()
        captureSession?.addInput(input!)
        captureSession?.addOutput(captureMetadataOutput)
        let dispatchQueue = DispatchQueue(label: "myQueue", attributes: [])
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.aztec]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession ?? AVCaptureSession())
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.frame
        view.layer.addSublayer(videoPreviewLayer!)
        captureMetadataOutput.rectOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        captureSession?.startRunning()
    }
    
    fileprivate func buildFrameImageView() {
        
        let lineT = [CGRect(x: 0, y: 0, width: ScreenWidth, height: 100),
            CGRect(x: 0, y: 100, width: ScreenWidth * 0.2, height: ScreenWidth * 0.6),
            CGRect(x: 0, y: 100 + ScreenWidth * 0.6, width: ScreenWidth, height: ScreenHeight - 100 - ScreenWidth * 0.6),
            CGRect(x: ScreenWidth * 0.8, y: 100, width: ScreenWidth * 0.2, height: ScreenWidth * 0.6)]
        for lineTFrame in lineT {
            buildTransparentView(lineTFrame)
        }
        
        let lineR = [CGRect(x: ScreenWidth * 0.2, y: 100, width: ScreenWidth * 0.6, height: 2),
            CGRect(x: ScreenWidth * 0.2, y: 100, width: 2, height: ScreenWidth * 0.6),
            CGRect(x: ScreenWidth * 0.8 - 2, y: 100, width: 2, height: ScreenWidth * 0.6),
            CGRect(x: ScreenWidth * 0.2, y: 100 + ScreenWidth * 0.6, width: ScreenWidth * 0.6, height: 2)]
        
        for lineFrame in lineR {
            buildLineView(lineFrame)
        }
        
        let yellowHeight: CGFloat = 4
        let yellowWidth: CGFloat = 30
        let yellowX: CGFloat = ScreenWidth * 0.2
        let bottomY: CGFloat = 100 + ScreenWidth * 0.6
        let lineY = [CGRect(x: yellowX, y: 100, width: yellowWidth, height: yellowHeight),
            CGRect(x: yellowX, y: 100, width: yellowHeight, height: yellowWidth),
            CGRect(x: ScreenWidth * 0.8 - yellowHeight, y: 100, width: yellowHeight, height: yellowWidth),
            CGRect(x: ScreenWidth * 0.8 - yellowWidth, y: 100, width: yellowWidth, height: yellowHeight),
            CGRect(x: yellowX, y: bottomY - yellowHeight + 2, width: yellowWidth, height: yellowHeight),
            CGRect(x: ScreenWidth * 0.8 - yellowWidth, y: bottomY - yellowHeight + 2, width: yellowWidth, height: yellowHeight),
            CGRect(x: yellowX, y: bottomY - yellowWidth, width: yellowHeight, height: yellowWidth),
            CGRect(x: ScreenWidth * 0.8 - yellowHeight, y: bottomY - yellowWidth, width: yellowHeight, height: yellowWidth)]
        
        for yellowRect in lineY {
            buildYellowLineView(yellowRect)
        }
    }
    
    fileprivate func buildLineView(_ frame: CGRect) {
        let view1 = UIView(frame: frame)
        view1.backgroundColor = UIColor.colorWithCustom(230, g: 230, b: 230)
        view.addSubview(view1)
    }
    
    fileprivate func buildYellowLineView(_ frame: CGRect) {
        let yellowView = UIView(frame: frame)
        yellowView.backgroundColor = LFBNavigationYellowColor
        view.addSubview(yellowView)
    }
    
    fileprivate func buildTransparentView(_ frame: CGRect) {
        let tView = UIView(frame: frame)
        tView.backgroundColor = UIColor.black
        tView.alpha = 0.5
        view.addSubview(tView)
    }
    
    fileprivate func buildAnimationLineView() {
        animationLineView.image = UIImage(named: "yellowlight")
        view.addSubview(animationLineView)
        
        timer = Timer(timeInterval: 2.5, target: self, selector: #selector(startYellowViewAnimation), userInfo: nil, repeats: true)
        let runloop = RunLoop.current
        runloop.add(timer!, forMode: RunLoop.Mode.common)
        timer?.fire()
    }
    
    @objc func startYellowViewAnimation() {
        weak var weakSelf = self
        animationLineView.frame = CGRect(x: ScreenWidth * 0.2 + ScreenWidth * 0.1 * 0.5, y: 100, width: ScreenWidth * 0.5, height: 20)
        UIView.animate(withDuration: 2.5, animations: { () -> Void in
            weakSelf!.animationLineView.frame.origin.y += ScreenWidth * 0.55
        }) 
    }
}
