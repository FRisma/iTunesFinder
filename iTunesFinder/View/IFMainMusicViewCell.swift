//
//  IFElementViewCell.swift
//  iTunesFinder
//
//  Created by Franco Risma on 12/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class IFMainMusicViewCell: UITableViewCell {
    
    public var title = UILabel() {
        didSet {
            self.setNeedsLayout()
        }
    }
    public var subtitle = UILabel() {
        didSet {
            self.setNeedsLayout()
        }
    }
    public var info = UILabel() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    private var thumbnail = UIImageView(frame: CGRect.zero)
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "SettingCell")
        
        title = UILabel.init(frame: CGRect.zero)
        title.font = UIFont.systemFont(ofSize: 16)
        
        subtitle = UILabel.init(frame: CGRect.zero)
        subtitle.font = UIFont.systemFont(ofSize: 14)
        
        info = UILabel.init(frame: CGRect.zero)
        info.font = UIFont.systemFont(ofSize: 9)
        
        thumbnail.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        thumbnail.contentMode = .scaleToFill
        thumbnail.clipsToBounds = true
        
        self.addSubview(title)
        self.addSubview(subtitle)
        self.addSubview(info)
        self.addSubview(thumbnail)
        
        self.applyConstraints()
    }
    
    func applyConstraints() {
        
        thumbnail.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(3)
            make.top.equalTo(self.snp.top).offset(3)
            make.right.lessThanOrEqualTo(self.title.snp.left)
            make.bottom.equalTo(self.snp.bottom).offset(-3)
            make.size.equalTo(60)
        })
        
        title.snp.makeConstraints({ (make) in
            make.left.equalTo(self.thumbnail.snp.right).offset(5)
            make.top.equalTo(self.snp.top).offset(5)
            make.right.equalTo(self.snp.right).offset(-5)
            make.bottom.equalTo(self.subtitle.snp.top)
        })
        
        subtitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.title.snp.bottom).offset(3)
            make.left.equalTo(self.title.snp.left)
            make.right.equalTo(self.snp.right).offset(-5)
            make.centerX.equalTo(self.title)
            make.bottom.equalTo(self.thumbnail.snp.bottom)
        }
    }
    
    public func loadImage(fromURL url:String, placeholderImage :UIImage? = nil) {
        thumbnail.af_setImage(
            withURL: URL(string: url)!,
            placeholderImage: placeholderImage,
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnail.af_cancelImageRequest()
        thumbnail.layer.removeAllAnimations()
        thumbnail.image = nil
    }
    
}
