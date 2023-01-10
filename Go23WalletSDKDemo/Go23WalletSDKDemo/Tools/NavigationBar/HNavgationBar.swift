//
//  HNavgationBar.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import UIKit
import SnapKit

let barPadding:CGFloat = 5.0
let barGap:CGFloat = 5.0

@IBDesignable public class HNavgationBar: UIView {

    @IBInspectable var title: String?{
        didSet{
            titleView = createtTitleLabel(title)
        }
    }
    var titleView: UIView?{
        didSet{
            setupTitleView()
        }
    }

    public let statusBarView: UIView = UIView.init()
    public let navgationContentView: UIView =  UIView.init()
    public var shadow: UIView  =  UIView.init()
    
    let navgationHeight: CGFloat = 44
    
    var leftBarItem: HBarItem?{
        didSet{
            leftBarItems.removeAll()
            if leftBarItem != nil {
                leftBarItems.append(leftBarItem!)
            }
        }
    }
    var leftBarItems: [HBarItem] = []{
        didSet{
            setupLeftBarItemViews()
        }
    }
    
    var rightBarItem: HBarItem?{
        didSet{
            rightBarItems.removeAll()
            if rightBarItem != nil {
                rightBarItems.append(rightBarItem!)
            }
        }
    }
    
    var rightBarItems: [HBarItem] = []{
        didSet{
            setupRightBarItemViews()
        }
    }
    
    var barFont: UIFont = UIFont.systemFont(ofSize: 16){
        didSet{
            updateBarFont()
        }
    }
    
    var attributes: [NSAttributedString.Key : Any]? {
        didSet {
            guard let attri = attributes else {
                return
            }
            updateTitleAttribute(attributes: attri)
        }
    }
    
    var barColor: UIColor = UIColor.black{
        didSet{
            updateBarColor()
        }
    }
    
    @IBInspectable var barBgColor: UIColor = UIColor.white{
        didSet{
            self.statusBarView.backgroundColor = barBgColor
            self.navgationContentView.backgroundColor = barBgColor
        }
    }
                
    convenience init(_ superView:UIView) {
        self.init()
        superView.addSubview(self)
    }
    
    deinit {
        print("\(self) deinit")
        removePageNotication()
    }
    
// MARK:
    func setupBaseUI() {
        backgroundColor = UIColor.clear
        insertSubview(self.statusBarView, at: 0)
        insertSubview(self.navgationContentView, at: 1)
        insertSubview(self.shadow, at: 2)
        
        statusBarView.backgroundColor = barBgColor
        navgationContentView.backgroundColor = barBgColor
        shadow.backgroundColor = UIColor.clear

        statusBarView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(HApp.appStatusHeight)
        }
                
        navgationContentView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(statusBarView.snp.bottom)
            $0.height.equalTo(self.navgationHeight)
        }
        shadow.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(HApp.appAPixel)
        }
                
        if let heightConstraint = layoutConstraint(for: .height) {
            heightConstraint.isActive = false
        }else{
            self.snp.remakeConstraints {
                $0.left.top.right.equalToSuperview()
            }
        }
    }
    
    
    public override func didMoveToSuperview() {
        if self.superview == nil {
            return
        }
        setupBaseUI()
        addPageNotifcation()
    }
    
    
// MARK:
    func addPageNotifcation()  {
        removePageNotication()
        NotificationCenter.default.addObserver(self, selector: #selector(statusChanged), name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
    }
    
    func removePageNotication()  {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func statusChanged()  {
        updateNavgationBarHeight(height: HApp.appStatusHeight, animation: true)
    }
    
    
// MARK:- lazy
    func createtTitleLabel(_ text:String?) -> UILabel? {
        if text == nil {
            return nil
        }
        if let label = titleView as? UILabel {
            label.text = text
            return label
        }
        
        let label = UILabel.init()
        label.textColor = barColor
        label.font = barFont
        label.text = text
        label.textAlignment = .center
        return label
    }
}

extension HNavgationBar{
    func setupTitleView()  {
        updateContentSubviews()
    }
    
    func setupLeftBarItemViews() {
        updateContentSubviews()
    }
    
    func setupRightBarItemViews() {
        updateContentSubviews()
    }
    
    func updateContentSubviews()  {
        for view in navgationContentView.subviews {
            view.removeFromSuperview()
        }
                
        for item in leftBarItems {
            navgationContentView.addSubview(item)
        }
        
        for item in rightBarItems {
            navgationContentView.addSubview(item)
        }
        
        for (index,item) in leftBarItems.enumerated() {
            if index == 0 {
                item.make_superConstraint(fromAttribute: .left,constant: barGap)
            }else{
                item.make_constraint(item: leftBarItems[index-1], attribute: .right,toItem: item,toAttribute: .left,constant: barPadding)
            }
            
            item.make_superConstraint(fromAttribute: .centerY)
        }
        
        for (index,item) in rightBarItems.enumerated() {
            if index == 0 {
                item.make_superConstraint(fromAttribute: .right,constant: barGap)
            }else{
                item.make_constraint(item: rightBarItems[index-1], attribute: .left,toItem: item,toAttribute: .right,constant: barPadding)
            }
            item.make_superConstraint(fromAttribute: .centerY)
        }
        
        guard titleView != nil else {
            return
        }
        
        navgationContentView.addSubview(titleView!)
        titleView!.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleView!.make_superConstraint(fromAttribute: .centerX)
        titleView!.make_superConstraint(fromAttribute: .centerY)


        if leftBarItems.count > 0 {
            titleView!.make_constraint(item: titleView!, attribute:.left,relatedBy: .greaterThanOrEqual,toItem:leftBarItems.last,toAttribute: .right,constant: barPadding)
        }
        
        if rightBarItems.count > 0 {
            rightBarItems.last!.make_constraint(item: rightBarItems.last!, attribute:.left,relatedBy: .greaterThanOrEqual,toItem:titleView,toAttribute: .right,constant: barPadding)
        }
    }
    
    func updateTitleAttribute(attributes: [NSAttributedString.Key : Any]) {
        if let label = titleView as? UILabel, let title = self.title {
            label.attributedText = NSAttributedString(string: title, attributes: attributes as [NSAttributedString.Key : Any])
        }
    }
    
    func updateBarColor() {
        if let label = titleView as? UILabel {
            label.textColor = barColor
        }
        
        for barItem in leftBarItems {
            if let label = barItem.titleLabel{
                label.textColor = barColor
            }
        }
        for barItem in rightBarItems {
            if let label = barItem.titleLabel{
                label.textColor = barColor
            }
        }
    }
    
    func updateBarFont() {
        if let label = titleView as? UILabel {
            label.font = barFont
        }
        
        for barItem in leftBarItems {
            if let label = barItem.titleLabel{
                label.font = barFont
            }
        }
        for barItem in rightBarItems {
            if let label = barItem.titleLabel{
                label.font = barFont
            }
        }
    }
}

extension HNavgationBar{
    
    var statusBarHidden:Bool {
        statusBarView.isHidden
    }
    
    var navgationContentHidden:Bool {
        navgationContentView.isHidden
    }
    
    var navgationBarHidden: Bool {
        isHidden
    }
        
    func setNavgationContentHidden(hidden: Bool,animation: Bool) {
        updateNavgationBarHeight(height: 0, animation: true)
    }

    func setNavgationBarHidden(hidden: Bool,animation: Bool) {
        updateNavgationBarHeight(height: 0, animation: true)
    }

    func updateNavgationContentHeight(height: CGFloat, animation: Bool) {
        navgationContentView.layoutConstraint(for: .height)?.constant = height
        excessive(animation: animation) {
            self.navgationContentView.alpha = height / self.navgationHeight;
        };
    }
    
    func updateNavgationBarHeight(height: CGFloat, animation: Bool) {
        self.layoutConstraint(for: .height)?.constant = height
        excessive(animation: animation) {
            self.alpha = height / self.navgationHeight;
        };
    }
    
    func excessive(animation:Bool, animations:@escaping () -> Void) {
        if animation {
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
                animations()
            };
        }else{
            self.setNeedsLayout()
            self.setNeedsDisplay()
            animations()
        }
    }
}
