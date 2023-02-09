//
//  Go23Loading.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import UIKit
import Kingfisher

class Go23Loading: UIView {
    static func loading() {
        let window = UIApplication.shared.windows.first
        window?.makeKeyAndVisible()
        if let loadingV = window?.viewWithTag(6874) {
            window?.bringSubviewToFront(loadingV)
            return
        }
        let loading = Go23Loading()
        loading.tag = 6873
        let blockView = UIView(frame: UIScreen.main.bounds)
        blockView.backgroundColor = .clear
        blockView.tag = 6874
        blockView.addSubview(loading)
        if let launchView = window?.viewWithTag(6982) {
            window?.insertSubview(loading, belowSubview: launchView)
        }else {
            window?.addSubview(blockView)
        }
        
        loading.loadingAnimate()
    }
    
    @objc static func blockActionLoading(bgColor: UIColor = .clear) {
        let window = UIApplication.shared.windows.first
        window?.makeKeyAndVisible()
        if let loadingV = window?.viewWithTag(6873) as? Go23Loading {
            window?.bringSubviewToFront(loadingV)
            return
        }
        let loading = Go23Loading()
        loading.tag = 6873
        let blockView = UIView(frame: UIScreen.main.bounds)
        blockView.backgroundColor = bgColor
        blockView.alpha = 0.4
        blockView.tag = 6874
        blockView.addSubview(loading)
        if let launchView = window?.viewWithTag(6982) {
            window?.insertSubview(blockView, belowSubview: launchView)
        }else {
            window?.addSubview(blockView)
        }
        loading.loadingAnimate()
    }
    
    @objc static func blockActionADLoading() {
        let window = UIApplication.shared.windows.first
        window?.makeKeyAndVisible()
        if let loadingV = window?.viewWithTag(6873) as? Go23Loading {
            window?.bringSubviewToFront(loadingV)
            return
        }
        let loading = Go23Loading()
        loading.tag = 6873
        let blockView = UIView(frame: UIScreen.main.bounds)
        blockView.tag = 6874
        blockView.addSubview(loading)
        if let launchView = window?.viewWithTag(6982) {
            window?.insertSubview(blockView, belowSubview: launchView)
        }else {
            window?.addSubview(blockView)
        }
        loading.loadingAnimate()
    }
    
    @objc static func clear() {
        if Thread.isMainThread == true {
            if let window = UIApplication.shared.windows.first,
               let loading = window.viewWithTag(6873) as? Go23Loading {
                loading.removeAnimate()
                loading.removeFromSuperview()
            }
            if let window = UIApplication.shared.windows.first,
               let blockView = window.viewWithTag(6874) {
                blockView.removeFromSuperview()
            }
            if let window = UIApplication.shared.windows.first,
               let launchView = window.viewWithTag(6982) {
                launchView.removeFromSuperview()
            }
        }else {
            DispatchQueue.main.async {
                if let window = UIApplication.shared.windows.first,
                   let loading = window.viewWithTag(6873) as? Go23Loading {
                    loading.removeAnimate()
                    loading.removeFromSuperview()
                }
                if let window = UIApplication.shared.windows.first,
                   let blockView = window.viewWithTag(6874) {
                    blockView.removeFromSuperview()
                }
                if let window = UIApplication.shared.windows.first,
                   let launchView = window.viewWithTag(6982) {
                    launchView.removeFromSuperview()
                }
            }
        }
    }
    
    @objc static func adLoadingclear() {
        if let window = UIApplication.shared.windows.first,
            let loading = window.viewWithTag(6873) as? Go23Loading {
            loading.removeAnimate()
            loading.removeFromSuperview()
        }
        if let window = UIApplication.shared.windows.first,
            let blockView = window.viewWithTag(6874) {
            blockView.removeFromSuperview()
        }
        if let window = UIApplication.shared.windows.first,
           let launchView = window.viewWithTag(6982) {
            launchView.removeFromSuperview()
        }
    }
    
    init() {
        super.init(frame: CGRect(x: ScreenWidth/2-20, y: ScreenHeight/2-20, width: 40, height: 40))
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(centerIcon)
    }
    
    private func loadingAnimate() {
//        var images = [UIImage]()
//        for i in 0..<15 {
//            if let img = UIImage(named: "page_loading\(i)") {
//                images.append(img)
//            }
//        }
//        centerIcon.animationImages = images
        if let bundlePath = Bundle.main.path(forResource: "loading", ofType: "gif"), let bundle = Bundle(path: bundlePath), let gifUrlStr = bundle.path(forResource: "loading", ofType: "gif") {
            let url = URL(fileURLWithPath: gifUrlStr)
            let provider = LocalFileImageDataProvider(fileURL: url)
            centerIcon.kf.setImage(with: provider)
        }

        centerIcon.animationDuration = 0.6
        centerIcon.animationRepeatCount = LONG_MAX
//        centerIcon.startAnimating()
    }
    
    private func removeAnimate() {
        centerIcon.stopAnimating()
    }
    
    private lazy var centerIcon : UIImageView = {
//        let iv = UIImageView(image: UIImage(named: "page_loading0"))
        let iv = UIImageView()
        if let gifUrlStr = Bundle.main.path(forResource: "loading", ofType: "gif") {
            let url = URL(fileURLWithPath: gifUrlStr)
            let provider = LocalFileImageDataProvider(fileURL: url)
            iv.kf.setImage(with: provider)
        }
        iv.frame = CGRect(x: 0, y: -60, width: 40, height: 40)
        return iv
    }()
}


