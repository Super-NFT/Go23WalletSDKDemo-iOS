//
//  UIView+Constaint.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import Foundation
import UIKit



extension UIView {
    
    @discardableResult
    func make_superConstraint(fromAttribute:NSLayoutConstraint.Attribute,multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        if (fromAttribute == .width || fromAttribute == .height) {
            return make_dimensionConstraint(attribute: fromAttribute)
        }
        return make_constraint(item: self, attribute: fromAttribute, toItem: itemSupview(self), toAttribute: fromAttribute, multiplier: multiplier, constant: constant)
    }
    
    
    @discardableResult
    func make_superConstraint(edge: UIEdgeInsets,excludingEdge: UIRectEdge? = nil) -> [NSLayoutConstraint] {
        var constraints:[NSLayoutConstraint] = []
        
        if let excluding = excludingEdge{
            if excluding != .top {
                constraints.append(make_constraint(item: self, attribute: .top, toItem: itemSupview(self), toAttribute: .top))
            }
            if excluding != .left {
                constraints.append(make_constraint(item: self, attribute: .left, toItem: itemSupview(self), toAttribute: .left))
            }
            if excluding != .bottom {
                constraints.append(make_constraint(item: self, attribute: .bottom, toItem: itemSupview(self), toAttribute: .bottom))
            }
            if excluding != .right {
                constraints.append(make_constraint(item: self, attribute: .right, toItem: itemSupview(self), toAttribute: .right))
            }
        }else{
            constraints.append(make_constraint(item: self, attribute: .top, toItem: itemSupview(self), toAttribute: .top))
            constraints.append(make_constraint(item: self, attribute: .left, toItem: itemSupview(self), toAttribute: .left))
            constraints.append(make_constraint(item: self, attribute: .bottom, toItem: itemSupview(self), toAttribute: .bottom))
            constraints.append(make_constraint(item: self, attribute: .right, toItem: itemSupview(self), toAttribute: .right))
        }
        return constraints
    }
    
    
    @discardableResult
    func make_dimensionConstraint(attribute:NSLayoutConstraint.Attribute,relatedBy: NSLayoutConstraint.Relation = .equal,constant: CGFloat = 0) -> NSLayoutConstraint {
        return make_constraint(item: self, attribute: attribute,relatedBy: relatedBy,constant: constant)
    }
    
    @discardableResult
    func make_dimensionSizeConstraint(size:CGSize) -> [NSLayoutConstraint] {
        var constraints:[NSLayoutConstraint] = []
        constraints.append(make_constraint(item: self, attribute: .width, constant: size.width))
        constraints.append(make_constraint(item: self, attribute: .height, constant: size.height))
        return constraints
    }
    
    
    @discardableResult
    func make_constraint(item: Any,attribute: NSLayoutConstraint.Attribute,relatedBy: NSLayoutConstraint.Relation = .equal,toItem: Any? = nil ,toAttribute: NSLayoutConstraint.Attribute = .notAnAttribute,multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var installItem: Any? = item
        if let to = toItem {
            installItem = commonSuperView(fromView: item, toView: to)
        }else{
            if attribute != .width && attribute != .height {
                installItem = itemSupview(item)
            }
        }
        
        var installConstant = constant
        
        
        if attribute == .bottom || attribute == .right {
            installConstant = -installConstant;
        }
        
        let layoutConstraint = NSLayoutConstraint.init(item: item, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute: toAttribute, multiplier: multiplier, constant: installConstant)
        
        guard let installView = installItem as? UIView else {
            assert(true, "error")
            return layoutConstraint
        }
        installView.addConstraint(layoutConstraint);
        return layoutConstraint
    }
    
    
    func layoutConstraint(for attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if attribute == .width || attribute == .height{
            for constraint in self.constraints {
                if constraint.firstAttribute == attribute{
                    if let view = constraint.firstItem as? UIView {
                        if view == self{
                            return constraint
                        }
                    }
                }
            }
        }else{
            for constraint in self.superview!.constraints {
                if let view = constraint.firstItem as? UIView {
                    if view == self && constraint.firstAttribute == attribute{
                        return constraint
                    }
                }
            }
        }
        return nil
    }
    
    func commonSuperView(fromView:Any,toView:Any) -> UIView? {
        var commonSuperView:UIView?
        var toSuperView:UIView? = toView as? UIView
        
        while commonSuperView == nil && toSuperView != nil {
            var fromSuperView:UIView? = fromView as? UIView
            while commonSuperView == nil &&  fromSuperView != nil{
                if toSuperView == fromSuperView {
                    commonSuperView = toSuperView
                }
                fromSuperView = fromSuperView?.superview
            }
            toSuperView = toSuperView?.superview
        }
        
        return commonSuperView

    }
    
    
    func itemSupview(_ item:Any) -> UIView? {
        if let view = item as? UIView {
            return view.superview
        }
        
        if #available(iOS 9.0, *), let guide = item as? UILayoutGuide {
            return guide.owningView
        }
        
        return nil
    }
    
}
