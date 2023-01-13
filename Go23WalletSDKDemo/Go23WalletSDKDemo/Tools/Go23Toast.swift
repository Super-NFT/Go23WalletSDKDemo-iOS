//
//  Go23Toast.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import UIKit

class Go23Toast: UIView {
    
    var contentString: String
    
    override init(frame: CGRect) {
        contentString = ""
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        addSubview(panelView)
        addSubview(contentLabel)
    }
    
    private lazy var panelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#000000").withAlphaComponent(0.7)
        view.layer.cornerRadius = 22.0
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#ffffff")
        label.numberOfLines = 0
        
        return label
    }()
}


extension Go23Toast {
    
    func getStingSize(with content: String) -> CGSize {
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 0
        let viewSize = CGSize(width: 250.0, height: UIScreen.main.bounds.height - 200.0)
        
        let stringRect = content.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.paragraphStyle: paraph, NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 16.0), NSAttributedString.Key.kern: 0.5], context: nil)
        
        return stringRect.size
    }
    
    func setViewSize(with content: String) {
        let margin = 16.0
        let maxWidth = 250.0
        let strSize = getStingSize(with: content)
        let stringWidth = strSize.width > maxWidth ? maxWidth : strSize.width
        var stringHeight = 16.0
        if strSize.height > 30 {
            stringHeight = strSize.height
        }
        
        let viewWidth = stringWidth + margin * 2
        let viewHeight = stringHeight  + margin * 2
        
        self.frame = CGRect(x: (UIScreen.main.bounds.width - viewWidth) / 2.0, y: (UIScreen.main.bounds.height - viewWidth) / 2.0, width: viewWidth, height: viewHeight)
        self.panelView.frame = self.bounds
        self.contentLabel.frame = CGRect(x: margin, y: margin, width: stringWidth, height: stringHeight)
//        self.contentLabel.text = content
//        self.contentLabel.textAlignment = .center
//        self.contentLabel.font = UIFont(name: BarlowCondensed, size: 16)
        self.contentLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.white, alignment: .center, title: content)
    }
    
    func show(_ content: String, after delay: Double) {
        
        var delay = delay
        delay += 0.5
        setViewSize(with: content)
        
        if let window = UIApplication.shared.windows.first {
            window.makeKeyAndVisible()
            self.alpha = 0.0
            window.addSubview(self)
            window.bringSubviewToFront(self)
            self.center.y = 0
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn) {
                self.center.y += 120.0
                self.alpha = 1.0
            } completion: { _ in
                
            }
            
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35, delay: delay, options: .curveEaseOut) {
                    self.alpha = 0.0
                    self.center.y = 0.0
                } completion: { _ in
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    func showInView(_ view: UIView, content: String, after delay: Double) {

        setViewSize(with: content)
        
        self.alpha = 0.0
        view.addSubview(self)
        view.bringSubviewToFront(self)
        
        self.center.y = 0
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn) {
            self.center.y += 120.0
            self.alpha = 1.0
        } completion: { _ in
            
        }
        
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.35, delay: delay, options: .curveEaseOut) {
                self.alpha = 0.0
                self.center.y = 0.0
            } completion: { _ in
                self.removeFromSuperview()
            }
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0.0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

