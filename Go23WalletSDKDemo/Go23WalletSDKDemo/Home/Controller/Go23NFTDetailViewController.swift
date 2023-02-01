//
//  Go23NFTDetailViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/8.
//

import UIKit
import MBProgressHUD
import Go23SDK

class Go23NFTDetailViewController: UIViewController {
        
    var nftModel: Go23WalletNFTModel?
    private var nftDetailModel: Go23NFTDetailModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubviews()
        getNFTDetail()

    }
    private func setNav() {
        
        let backBtn = UIButton()
        backBtn.frame = CGRectMake(0, 0, 44, 44)
        let imgv = UIImageView()
        backBtn.addSubview(imgv)
        imgv.image = UIImage.init(named: "back")
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        backBtn.addTarget(self, action: #selector(backBtnDidClick), for: .touchUpInside)
        
        if self.navgationBar == nil {
            addBarView()
            navgationBar?.title = "Details"
            navgationBar?.attributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]
            navgationBar?.leftBarItem = HBarItem.init(customView: backBtn)
        }
    }
    
    @objc private func backBtnDidClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initSubviews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(footerView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navgationBar!.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        footerView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
             } else {
                 make.bottom.equalTo(0)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(NFTDetailFooterView.cellHeight)
        }
                

    }
    
    private lazy var headerView: NFTDetailHeaderView = {
        let view = NFTDetailHeaderView()
        view.frame = CGRectMake(0, 0, ScreenWidth, NFTDetailHeaderView.cellHeight)
        return view
    }()
    
    private lazy var footerView: NFTDetailFooterView = {
        let view = NFTDetailFooterView()
        view.backgroundColor = .clear
        view.frame = CGRectMake(0, 0, ScreenWidth, NFTDetailFooterView.cellHeight)
        view.transferBlock = { [weak self] in
            let vc = Go23SendNFTViewController()
            vc.nftDetailModel = self?.nftDetailModel
            self?.navigationController?.pushViewController(vc
                                                           , animated: true)
        }
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.tableHeaderView = headerView
//        tableView.tableFooterView = footerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.register(NFTDetailDescCell.self, forCellReuseIdentifier: NFTDetailDescCell.reuseIdentifier())
        tableView.register(NFTDetailAttributesCell.self, forCellReuseIdentifier: NFTDetailAttributesCell.reuseIdentifier())
        tableView.register(NFTDetailDetailsCell.self, forCellReuseIdentifier: NFTDetailDetailsCell.reuseIdentifier())
        tableView.register(NFTNumberCell.self, forCellReuseIdentifier: NFTNumberCell.reuseIdentifier())
        return tableView
    }()
    
    
}

extension Go23NFTDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTNumberCell.reuseIdentifier(), for: indexPath) as? NFTNumberCell, let nftModel = nftDetailModel, nftModel.value > 1
            else {
                return UITableViewCell()
            }
            cell.filled(num: nftModel.value)
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTDetailDescCell.reuseIdentifier(), for: indexPath) as? NFTDetailDescCell
            else {
                return UITableViewCell()
            }
            if let desc = self.nftDetailModel?.desc, desc.count > 0 {
                cell.filled(desc: desc)
            } else {
                cell.filled(desc: "none")
            }
            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTDetailAttributesCell.reuseIdentifier(), for: indexPath) as? NFTDetailAttributesCell, let list = nftDetailModel?.attributes
            else {
                return UITableViewCell()
            }
            if list.count > 0 {
                cell.attributes = list
            }
            return cell
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTDetailDetailsCell.reuseIdentifier(), for: indexPath) as? NFTDetailDetailsCell
            else {
                return UITableViewCell()
            }
            
            cell.filled(address: self.nftDetailModel?.contractAddress ?? "", url: self.nftDetailModel?.externalUrl ?? "none", tokenId: self.nftDetailModel?.tokenId ?? "", chain: self.nftDetailModel?.chainName ?? "", stand: self.nftDetailModel?.tokenStandard ?? "")
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            guard let nftModel = nftDetailModel, nftModel.value > 1 else {
                return 0
            }
            return NFTNumberCell.cellHeight
        } else if indexPath.row == 1 {
            let cell = NFTDetailDescCell()
            if let desc = self.nftDetailModel?.desc, desc.count > 0 {
                let height = cell.getRowHeight(desc: desc)
                print("height +++++ \(height)")
                return height
            }
            let height = cell.getRowHeight(desc: "none")
            print("height +++++ \(height)")
            return height
        } else if indexPath.row == 2 {
            guard let list = self.nftDetailModel?.attributes, list.count > 0 else {
                return 0
            }
            return NFTDetailAttributesCell.cellHeight
        } else if indexPath.row == 3 {
            return NFTDetailDetailsCell.cellHeight
        } else {
            return 0.01
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class NFTDetailHeaderView: UIView {
    
    static var cellHeight: CGFloat {
        return CGFloat(ScreenWidth+56)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        backgroundColor = .white
        addSubview(coverImgv)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(lineV)
        coverImgv.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalToSuperview()
            make.width.height.equalTo(ScreenWidth-40)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImgv.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.height.equalTo(30)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.height.equalTo(20)
        }
        lineV.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(16)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(1)
        }
    }
    
    func filled(cover: String, title: String, desc: String) {
        coverImgv.sd_setImage(with: URL(string: cover), placeholderImage: nil)
        descLabel.text = desc
        titleLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 24), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .left, title: title)
    }
    
    private lazy var coverImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.layer.masksToBounds = true
        imgv.layer.cornerRadius = 8
        return imgv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 24)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        return view
    }()
    
    
}

class NFTDetailFooterView: UIView {
    
    static var cellHeight: CGFloat {
        return 46.0
    }
    
    var transferBlock: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        backgroundColor = .white
        addSubview(transferBtn)
        transferBtn.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(46)
        }
    }
    
    @objc private func transferBtnClick() {
        self.transferBlock?()
    }
    
    private lazy var transferBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setAttributedTitle(String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 24), wordspace: 0.5, color: UIColor.white,alignment: .left, title: "Transfer"), for: .normal)
        btn.addTarget(self, action: #selector(transferBtnClick), for: .touchUpInside)
        return btn
    }()
    
}

class NFTDetailDescCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(lineV)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(20)
            make.height.equalTo(24)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        lineV.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(16)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(1)
        }
    }
    
    func filled(desc: String) {
        descLabel.text = desc
    }
    
    func getRowHeight(desc: String) -> CGFloat {
        return getStringHeight(desc, lineHeight:  17.0, font: UIFont.systemFont(ofSize: 14))  + 66.0
    }
    
    private func getStringHeight(_ content: String,
                                 lineHeight:CGFloat = 27.0,
                                 font: UIFont = UIFont.systemFont(ofSize: 14),
                                 wordWidth: CGFloat = (ScreenWidth - 40.0)) -> CGFloat {
        let paraph = NSMutableParagraphStyle()
        paraph.maximumLineHeight = lineHeight
        paraph.minimumLineHeight = lineHeight
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph, NSAttributedString.Key.font: font]

        let rowHeight = (content.trimmingCharacters(in: .newlines) as NSString).boundingRect(with: CGSize(width: wordWidth, height: 0), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attributes, context: nil).size.height
         return rowHeight
     }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .left, title: "Description")
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        return view
    }()
    
}

class NFTNumberCell: UITableViewCell {
    
    static var cellHeight: CGFloat {
        return 60.0
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        contentView.backgroundColor = .white
        contentView.addSubview(iconImgv)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineV)
        iconImgv.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImgv.snp.right).offset(4)
            make.height.equalTo(24)
        }
        lineV.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(1)
        }
    }
    
    func filled(num: Int) {
        iconImgv.isHidden = false
        titleLabel.isHidden = false
        lineV.isHidden = false
        titleLabel.text = "You own \(num)"
    }
    
    
    private lazy var iconImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "own")
        imgv.isHidden = true
        return imgv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        view.isHidden = true
        return view
    }()
}

class NFTDetailAttributesCell: UITableViewCell {
    
    var attributes: [Go23NFTAttribute]? {
        didSet {
            guard let list = attributes else {
                return
            }
            titleLabel.removeFromSuperview()
            collectionView.removeFromSuperview()
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(10)
                make.leading.equalTo(20)
                make.height.equalTo(24)
            }
            
            contentView.addSubview(collectionView)
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.leading.trailing.bottom.equalToSuperview()
            }
            
            contentView.addSubview(lineV)
            lineV.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(106)
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.height.equalTo(1)
            }
        }
    }
    static var cellHeight: CGFloat {
        return 126.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        contentView.backgroundColor = .white
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: BarlowCondensed, size: 20)
//        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
//        label.text = "Attributes"
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .left, title: "Attributes")
        return label
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NFTDetailAttributesCollectionCell.self, forCellWithReuseIdentifier: NFTDetailAttributesCollectionCell.reuseIdentifier())
        return collectionView
    }()
    
    private lazy var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        return view
    }()
    
}

// MARK: - pragma mark =========== UICollectionViewDelegate ===========

extension NFTDetailAttributesCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.attributes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTDetailAttributesCollectionCell.reuseIdentifier(), for: indexPath) as? NFTDetailAttributesCollectionCell, let list = self.attributes,indexPath.item < list.count else {
            return UICollectionViewCell()
        }
        let model = list[indexPath.item]
        cell.filled(title: model.traitType, desc: model.value)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 120.0, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
}

class NFTDetailAttributesCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        contentView.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        contentView.layer.cornerRadius = 8
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.height.equalTo(20)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.height.equalTo(20)
        }
        
    }
    
    func filled(title: String, desc: String) {
        titleLabel.text = title
        descLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: desc)
        
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .center
        return label
    }()
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.textAlignment = .center
        return label
    }()
    
    
}



class NFTDetailDetailsCell: UITableViewCell {
    static var cellHeight: CGFloat {
        return 320.0
    }
    
    private var address = ""
    private var tokenId = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressTxt)
        contentView.addSubview(addressBtn)
        contentView.addSubview(tokenIdTxt)
        contentView.addSubview(tokenIdBtn)
        contentView.addSubview(webTxt)
        contentView.addSubview(webLabel)
        contentView.addSubview(standTxt)
        contentView.addSubview(standLabel)
        contentView.addSubview(chainTxt)
        contentView.addSubview(chainLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.leading.equalTo(20)
            make.height.equalTo(24)
        }
        
        addressTxt.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.height.equalTo(20)
        }
        addressBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.centerY.equalTo(addressTxt.snp.centerY).offset(0)
            make.height.equalTo(20)
        }
        tokenIdTxt.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(addressTxt.snp.bottom).offset(12)
            make.height.equalTo(20)
        }
        tokenIdBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.centerY.equalTo(tokenIdTxt.snp.centerY).offset(0)
            make.height.equalTo(20)
        }
        
        webTxt.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(tokenIdTxt.snp.bottom).offset(12)
            make.height.equalTo(20)
        }
        webLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.centerY.equalTo(webTxt.snp.centerY).offset(0)
        }
        standTxt.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(webTxt.snp.bottom).offset(12)
            make.height.equalTo(20)
        }
        standLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.centerY.equalTo(standTxt.snp.centerY).offset(0)
        }
        chainTxt.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(standTxt.snp.bottom).offset(12)
            make.height.equalTo(20)
        }
        chainLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.centerY.equalTo(chainTxt.snp.centerY).offset(0)
        }
        
    }
    
    func filled(address: String, url: String, tokenId: String, chain: String, stand: String) {
        self.address = address
        self.tokenId = tokenId
        addressBtn.setAttributedTitle(getAttri(str: String.getSubSecretString(string: address)), for: .normal)
        if url.count > 0 {
            webLabel.text = url
        }
        else {
            webLabel.text = "none"
        }
        var token = tokenId
        if tokenId.count > 16 {
            token = tokenId.substring(to: 16)+"..."
        }
        tokenIdBtn.setAttributedTitle(getAttri(str: token), for: .normal)
        chainLabel.text = "\(chain)"
        standLabel.text = stand
    }
    
    private func getAttri(str: String)->NSMutableAttributedString {
        
        let attri = NSMutableAttributedString()
        attri.add(text: str) { attr in
            attr.font(14)
            attr.color(UIColor.rdt_HexOfColor(hexString: "#262626"))
            attr.alignment(.right)
        }.add(text: "  ") { att in
            
        }
        attri.addImage("copy", CGRectMake(0, 0, 14, 14))
        
        return attri
    }
    
    @objc private func addressClick() {
        UIPasteboard.general.string = self.address
        
        let totast = Go23Toast.init(frame: .zero)
        totast.show("Copied!", after: 1)
    }
    
    @objc private func tokenIdClick() {
        UIPasteboard.general.string = self.tokenId
        
        let totast = Go23Toast.init(frame: .zero)
        totast.show("Copied!", after: 1)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .left, title: "Details")
        return label
    }()
    
    private lazy var addressTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "Contract address"
        return label
    }()
    
    
    private lazy var addressBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 14)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#262626"), for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(addressClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tokenIdTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "Token ID"
        return label
    }()
    
    private lazy var tokenIdBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 14)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#262626"), for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(tokenIdClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var webTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "Website"
        return label
    }()
    
    private lazy var webLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var standTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "Token Standard"
        return label
    }()
    
    private lazy var standLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var chainTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "Blockchain"
        return label
    }()
    
    private lazy var chainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.textAlignment = .right
        return label
    }()
    
}

extension Go23NFTDetailViewController {
    private func getNFTDetail() {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        Go23Loading.loading()
        guard let obj = self.nftModel else {
            return
        }
        shared.getNftDetail(for: obj.tokenId, contractAddress: obj.contractAddress, walletAddress: obj.walletAddress , chainId: obj.chainId) { [weak self] model in
            Go23Loading.clear()
            self?.nftDetailModel = model
            if let obj = model {
                self?.headerView.filled(cover: obj.image, title: obj.name, desc: obj.series)
                self?.tableView.reloadData()
            }
        }
        

    }
        
}



