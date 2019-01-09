//
//  PageScrollView.swift
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

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
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


class PageScrollView: UIView {
    
    fileprivate let imageViewMaxCount = 3
    fileprivate var imageScrollView: UIScrollView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var timer: Timer?
    fileprivate var placeholderImage: UIImage?
    fileprivate var imageClick:((_ index: Int) -> ())?
    var headData: HeadResources? {
        didSet {
            
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            
            if headData?.data?.focus?.count >= 0 {
                pageControl.numberOfPages = (headData?.data?.focus?.count)!
                pageControl.currentPage = 0
                updatePageScrollView()
                
                startTimer()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildImageScrollView()
        
        buildPageControl()
        
    }
    
    convenience init(frame: CGRect, placeholder: UIImage, focusImageViewClick:@escaping ((_ index: Int) -> Void)) {
        self.init(frame: frame)
        placeholderImage = placeholder
        imageClick = focusImageViewClick
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageScrollView.frame = bounds
        imageScrollView.contentSize = CGSize(width: CGFloat(imageViewMaxCount) * width, height: 0)
        for i in 0...imageViewMaxCount - 1 {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            imageView.isUserInteractionEnabled = true
            imageView.frame = CGRect(x: CGFloat(i) * imageScrollView.width, y: 0, width: imageScrollView.width, height: imageScrollView.height)
        }
        
        let pageW: CGFloat = 80
        let pageH: CGFloat = 20
        let pageX: CGFloat = imageScrollView.width - pageW
        let pageY: CGFloat = imageScrollView.height - pageH
        pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
        
        updatePageScrollView()
    }
    
    // MARK: BuildUI
    fileprivate func buildImageScrollView() {
        imageScrollView = UIScrollView()
        imageScrollView.bounces = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.isPagingEnabled = true
        imageScrollView.delegate = self
        addSubview(imageScrollView)
        
        for _ in 0..<3 {
            let imageView = UIImageView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(PageScrollView.imageViewClick(_:)))
            imageView.addGestureRecognizer(tap)
            imageScrollView.addSubview(imageView)
        }
    }
    
    fileprivate func buildPageControl() {
        pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "v2_home_cycle_dot_normal")!)
        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "v2_home_cycle_dot_selected")!)
        addSubview(pageControl)
    }
    
    //MARK: 更新内容
    fileprivate func updatePageScrollView() {
        for i in 0 ..< imageScrollView.subviews.count {    
            let imageView = imageScrollView.subviews[i] as! UIImageView
            var index = pageControl.currentPage
            
            if i == 0 {
                index -= 1
            } else if 2 == i {
                index += 1
            }
            
            if index < 0 {
                index = self.pageControl.numberOfPages - 1
            } else if index >= pageControl.numberOfPages {
                index = 0
            }
            
            imageView.tag = index
            if headData?.data?.focus?.count > 0 && headData?.data?.focus?.count >  index {
                imageView.sd_setImage(with: URL.init(string: headData?.data?.focus![index].img ?? ""), placeholderImage: placeholderImage)
            }
        }
        
        imageScrollView.contentOffset = CGPoint(x: imageScrollView.width, y: 0)
    }
    

    // MARK: Timer
    fileprivate func startTimer() {
        timer = Timer(timeInterval: 3.0, target: self, selector: #selector(PageScrollView.next as (PageScrollView) -> () -> ()), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func next() {
        imageScrollView.setContentOffset(CGPoint(x: 2.0 * imageScrollView.frame.size.width, y: 0), animated: true)
    }
    
    // MARK: ACTION
    @objc func imageViewClick(_ tap: UITapGestureRecognizer) {
        if imageClick != nil {
            imageClick!(tap.view!.tag)
        }
    }
}

// MARK:- UIScrollViewDelegate
extension PageScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var page: Int = 0
        var minDistance: CGFloat = CGFloat(MAXFLOAT)
        for i in 0..<imageScrollView.subviews.count {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            let distance:CGFloat = abs(imageView.x - scrollView.contentOffset.x)
            
            if distance < minDistance {
                minDistance = distance
                page = imageView.tag
            }
        }
        pageControl.currentPage = page
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageScrollView()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageScrollView()
    }
}
