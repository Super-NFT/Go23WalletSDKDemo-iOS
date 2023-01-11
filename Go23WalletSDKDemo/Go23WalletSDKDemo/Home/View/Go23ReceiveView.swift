//
//  Go23ReceiveView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/2.
//

import UIKit
import SnapKit
import MBProgressHUD
import Go23SDK

class Go23ReceiveView: UIView {
    
    var token = ""
    
    static var cellHeight = 544.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initSubviews() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(qrCodeImgv)
        addSubview(tokenLabel)
        addSubview(copyImgv)
        addSubview(copyControl)
        addSubview(lineV)
        addSubview(noticeLabel)
        addSubview(imgV)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.width.equalTo(200)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
        qrCodeImgv.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(24)
            make.width.height.equalTo(174)
            make.centerX.equalToSuperview()
        }
        tokenLabel.snp.makeConstraints { make in
            make.top.equalTo(qrCodeImgv.snp.bottom).offset(16)
            make.width.equalTo(188)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
        }
        copyControl.snp.makeConstraints { make in
            make.top.equalTo(qrCodeImgv.snp.bottom).offset(16)
            make.width.equalTo(188)
            make.height.equalTo(32)
            make.centerX.equalToSuperview()
        }
        lineV.snp.makeConstraints { make in
            make.top.equalTo(tokenLabel.snp.bottom).offset(42)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(lineV.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(32)
        }
        
        imgV.snp.makeConstraints { make in
            make.top.equalTo(noticeLabel.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func filled(title: String, qrcode: String ) {
        self.token = qrcode
        titleLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 32), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .left, title: title)
        let attri = NSMutableAttributedString()
        attri.add(text: token) { attr in
//            attr.customFont(12, NotoSans)
            attr.font(12)
            attr.color(UIColor.rdt_HexOfColor(hexString: "#262626"))
            attr.alignment(.center)
            attr.lineSpacing(3)
            
        }.add(text: " ") { att in
            
        }
        attri.addImage("copy", CGRectMake(0, 0, 12, 12))
        tokenLabel.attributedText = attri
        
        qrCodeImgv.image = generateCode(inputMsg: qrcode, fgImage: nil)
        noticeLabel.text = "This address only accepts tokens from \n \(title).Do not send from other Mainnets."
        
    }
    
    func generateCode(inputMsg: String, fgImage: UIImage?) -> UIImage {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        let inputData = inputMsg.data(using: .utf8)
        filter?.setValue(inputData, forKey: "inputMessage")
        guard let outImage = filter?.outputImage else { return UIImage() }
        let hdImage = getHDImage(outImage)
        if fgImage == nil{
            return hdImage
        }
        
        return getResultImage(hdImage: hdImage, fgImage: fgImage!)
    }
    
    fileprivate func getResultImage(hdImage: UIImage, fgImage: UIImage) -> UIImage {
        let hdSize = hdImage.size
        UIGraphicsBeginImageContext(hdSize)
        
        hdImage.draw(in: CGRect(x: 0, y: 0, width: hdSize.width, height: hdSize.height))
        
        let fgWidth: CGFloat = 80
        fgImage.draw(in: CGRect(x: (hdSize.width - fgWidth) / 2, y: (hdSize.height - fgWidth) / 2, width: fgWidth, height: fgWidth))
        
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        
        UIGraphicsEndImageContext()
        
        return resultImage
    }

    fileprivate func getHDImage(_ outImage: CIImage) -> UIImage {
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let ciImage = outImage.transformed(by: transform)
        return UIImage(ciImage: ciImage)
    }
    
    @objc func controlClick() {
        UIPasteboard.general.string = self.token
        
//        let hud = MBProgressHUD.showAdded(to: self, animated: true)
//        hud.mode = .text
//        hud.label.text = "address has copy to pasteboard!"
//        hud.label.font = UIFont(name: NotoSans, size: 16)
//        hud.hide(animated: true, afterDelay: 1)
        
        let totast = Go23Toast.init(frame: .zero)
        totast.show("Copied!", after: 1)
    }
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: BarlowCondensed, size: 32)
//        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
//        label.text = "Scan the QR code to pay \n Mainnet ERC-20"
//        label.textAlignment = .center
////        label.font = UIFont(name: NotoSans, size: 14)
//        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
//        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 0
        paraph.alignment = .center
        paraph.lineSpacing = 6
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor:UIColor.rdt_HexOfColor(hexString: "#262626")]
        let attri = NSAttributedString(string: "Scan the QR code to pay \n Mainnet ERC-20", attributes: attributes as [NSAttributedString.Key : Any])
        label.attributedText = attri
        return label
    }()
    
    private lazy var qrCodeImgv: UIImageView = {
        let imgv = UIImageView()
        return imgv
    }()
    
    private lazy var tokenLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: NotoSans, size: 12)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#595959")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var copyImgv: UIImageView = {
        let imgv = UIImageView()
        
        return imgv
    }()
    
    private lazy var copyControl: UIControl = {
        let control = UIControl()
        control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
        return control
    }()
    
    private lazy var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        return view
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: NotoSans, size: 12.0)
        label.font = UIFont.systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imgV: UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage(named: "popResult")
        return imgv
    }()
}


