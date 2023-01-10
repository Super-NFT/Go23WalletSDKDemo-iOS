//
//  HBarItem.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import UIKit

typealias HBarHandler = (HBarItem)->()

class HBarItem: UIView {
    var titleLabel:UILabel?{
        didSet{
            if let view = titleLabel {
                if view.superview == nil{
                    addSubview(view)
                }
                view.snp.makeConstraints {
                    $0.left.top.right.bottom.equalToSuperview()
                }
            }
        }
    }
    var imageView:UIImageView?{
        didSet{
            if let view = imageView {
                if view.superview == nil{
                    addSubview(view)
                }
                view.snp.makeConstraints {
                    $0.left.top.right.bottom.equalToSuperview()
                }
            }
        }
    }
    var customView:UIView?{
        didSet{
            if let view = customView {
                if view.superview == nil{
                    addSubview(view)
                }
                view.snp.makeConstraints {
                    $0.left.top.right.bottom.equalToSuperview()
                    if !view.frame.isEmpty{
                        $0.width.equalTo(view.hd_width)
                        $0.height.equalTo(view.hd_height)
                    }
                }
            }
        }
    }
    var handler :HBarHandler?{
        didSet{
            if handler != nil {
                
                addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGesture(tap:))))
            }
        }
    }
    
    convenience init(title:String, handler:HBarHandler? = nil) {
        self.init()
        
        initBarItem(title: title, handler: handler)
    }
    
    convenience init(image:UIImage,handler:HBarHandler? = nil) {
        self.init()
        initBarItem(image: image, handler: handler)
    }
    
    convenience init(customView:UIView, handler:HBarHandler? = nil) {
        self.init()
        initBarItem(customView: customView,handler: handler)
    }
    
    func initBarItem(title:String? = nil,image:UIImage? = nil,customView:UIView? = nil, handler:HBarHandler? = nil) {
        self.handler = handler
        
        if let text = title {
            let label = UILabel.init()
            label.text = text
            self.titleLabel = label
        }
        
        if let img = image {
            self.imageView = UIImageView.init(image: img)
        }

        if let view = customView {
            self.customView = view
        }
        
//        if self.handler != nil {
//            self.titleLabel?.isUserInteractionEnabled = true
//            self.imageView?.isUserInteractionEnabled = true
//            self.customView?.isUserInteractionEnabled = true
//            addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGesture(tap:))))
//        }
    }
    
    @objc func tapGesture(tap:UITapGestureRecognizer)  {
        if tap.state == .ended {
            if let handler = self.handler {
                handler(self);
            }
        }
    }
    
}
