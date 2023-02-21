//
//  Go23CircleView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/2/21.
//

import UIKit

class Go23CircleView: UIView {
    
    public var progress: Float = 0 {
        didSet{
            setProgress(progress)
        }
    }
    private var progressColor = UIColor.black
    private var backColor = UIColor.white
    private var start: CGPoint?
    private var end: CGPoint?
    private var colors: [UIColor]?
    private var lineWidth: CGFloat = 5
    private var radius: CGFloat = 10
    private var lastProgress: Float = 0.0
    
    init(_ progressColor: UIColor, backColor: UIColor = .white, lineWidth: CGFloat = 5.0) {
        super.init(frame: .zero)
        self.backColor = backColor
        self.progressColor = progressColor
        self.lineWidth = lineWidth
        initSubviews(false)
    }
    
    init(gradient points: [CGPoint], colors:[UIColor], backColor: UIColor = .white, lineWidth: CGFloat = 5.0) {
        super.init(frame: .zero)
        if points.count == 2 && colors.count >= 2 {
            start = points[0]
            end = points[1]
            self.colors = colors
        }
        self.backColor = backColor
        self.lineWidth = lineWidth
        initSubviews(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews(_ gradient: Bool) {
        layer.addSublayer(backLayer)
        layer.addSublayer(gradientLayer)
        if gradient {
            if start != nil, end != nil, colors != nil {
                gradientLayer.startPoint = start!
                gradientLayer.endPoint = end!
                gradientLayer.colors = colors!.map{ $0.cgColor }
            }
        } else {
            gradientLayer.backgroundColor = progressColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        radius = self.bounds.width / 2.0
        backLayer.path = getCirclePath().cgPath
        gradientLayer.frame = self.bounds
        progressLayer.frame = self.bounds
        gradientLayer.mask = progressLayer

    }
    
    private func getCirclePath(start: Float = 0.0, end: Float = Float.pi * 2.0) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: CGPoint(x: radius , y: radius ), radius: radius - lineWidth / 2.0, startAngle: CGFloat(start) , endAngle: CGFloat(end), clockwise: true)
        return path
    }
    
    func setProgress(_ progress: Float, animated: Bool = false){
        
        let end = Float.pi * 2 * progress - Float.pi / 2.0
        let path = getCirclePath(start: Float.pi / -2.0, end: end)
        if animated {
            progressLayer.removeAllAnimations()
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = 0.25;
            pathAnimation.fromValue = NSNumber(floatLiteral: Double(lastProgress / progress))
            pathAnimation.toValue = NSNumber(floatLiteral: 1)
            pathAnimation.autoreverses = false
            progressLayer.add(pathAnimation, forKey: "strokeEndAnimation")
        }
        progressLayer.path = path.cgPath
        lastProgress = progress
    }
    
    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = lineWidth
        layer.fillColor =  UIColor.clear.cgColor
        layer.strokeStart = 0.0
        layer.strokeEnd = 1.0
        layer.lineCap = .round
        return layer
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
    
    private lazy var backLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = backColor.cgColor
        layer.lineWidth = lineWidth
        layer.fillColor =  UIColor.clear.cgColor
        layer.strokeStart = 0.0
        layer.strokeEnd = 1.0
        return layer
    }()
    

    
}
