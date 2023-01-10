//
//  Go23Loading.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import UIKit
import SDWebImage
import MBProgressHUD

class Go23Loading: UIView {
    static func loading() {
        let window = UIApplication.shared.keyWindow
        if let _ = window?.viewWithTag(6873) {
            return
        }
        let loading = Go23Loading()
        loading.tag = 6873
        if let launchView = window?.viewWithTag(6982) {
            window?.insertSubview(loading, belowSubview: launchView)
        }else {
            window?.addSubview(loading)
        }
        
        loading.loadingAnimate()
    }
    
    @objc static func blockActionLoading(bgColor: UIColor = .clear) {
        let window = UIApplication.shared.keyWindow
        if let _ = window?.viewWithTag(6873) {
            return
        }
        let loading = Go23Loading()
        loading.tag = 6873
        let blockView = UIView(frame: UIScreen.main.bounds)
        blockView.backgroundColor = bgColor
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
        let window = UIApplication.shared.keyWindow
        if let _ = window?.viewWithTag(6873) {
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
            if let window = UIApplication.shared.keyWindow,
               let loading = window.viewWithTag(6873) as? Go23Loading {
                loading.removeAnimate()
                loading.removeFromSuperview()
            }
            if let window = UIApplication.shared.keyWindow,
               let blockView = window.viewWithTag(6874) {
                blockView.removeFromSuperview()
            }
        }else {
            DispatchQueue.main.async {
                if let window = UIApplication.shared.keyWindow,
                   let loading = window.viewWithTag(6873) as? Go23Loading {
                    loading.removeAnimate()
                    loading.removeFromSuperview()
                }
                if let window = UIApplication.shared.keyWindow,
                   let blockView = window.viewWithTag(6874) {
                    blockView.removeFromSuperview()
                }
            }
        }
    }
    
    @objc static func adLoadingclear() {
        if let window = UIApplication.shared.keyWindow,
            let loading = window.viewWithTag(6873) as? Go23Loading {
            loading.removeAnimate()
            loading.removeFromSuperview()
        }
        if let window = UIApplication.shared.keyWindow,
            let blockView = window.viewWithTag(6874) {
            blockView.removeFromSuperview()
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
        if let gifUrlStr = Bundle.main.path(forResource: "loading", ofType: "gif"),
           let gifData = try? NSData(contentsOfFile: gifUrlStr) {
            let image = UIImage.sd_image(withGIFData: gifData as Data)
            centerIcon.image = image
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
        if let gifUrlStr = Bundle.main.path(forResource: "loading", ofType: "gif"),
           let gifData = try? NSData(contentsOfFile: gifUrlStr) {
            let image = UIImage.sd_image(withGIFData: gifData as Data)
            iv.image = image
        }
        iv.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return iv
    }()
}


extension MBProgressHUD {
    class func showGifAdded(to view:UIView!,userInterface:Bool = true,animated:Bool = true){
        if let gifUrlStr = Bundle.main.path(forResource: "loading", ofType: "gif"),
           let gifData = try? NSData(contentsOfFile: gifUrlStr) {
            let image = UIImage.sd_image(withGIFData: gifData as Data)
            let giftImgView = UIImageView(image: image)
            let hud = MBProgressHUD.showAdded(to: view, animated: animated)
            hud.mode = .customView
            hud.isUserInteractionEnabled = userInterface
            hud.customView = giftImgView
        }
        
    }
}

