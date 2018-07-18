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
    
    public var trackName = UILabel() {
        didSet {
            self.setNeedsLayout()
        }
    }
    public var artist = UILabel() {
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
        
        trackName = UILabel.init(frame: CGRect.zero)
        trackName.numberOfLines = 1
        trackName.font = UIFont.systemFont(ofSize: 16)
        
        artist = UILabel.init(frame: CGRect.zero)
        artist.numberOfLines = 1
        artist.font = UIFont.systemFont(ofSize: 14)
        
        thumbnail.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        thumbnail.contentMode = .scaleToFill
        thumbnail.clipsToBounds = true
        
        self.addSubview(trackName)
        self.addSubview(artist)
        self.addSubview(thumbnail)
        
        self.applyConstraints()
    }
    
    func applyConstraints() {
        
        thumbnail.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(3)
            make.top.equalTo(self.snp.top).offset(3)
            make.right.lessThanOrEqualTo(self.trackName.snp.left)
            make.bottom.equalTo(self.snp.bottom).offset(-3)
            make.size.equalTo(50)
        })
        
        trackName.snp.makeConstraints({ (make) in
            make.left.equalTo(self.thumbnail.snp.right).offset(5)
            make.top.equalTo(self.snp.top).offset(5)
            make.right.equalTo(self.snp.right).offset(-5)
            make.bottom.equalTo(self.artist.snp.top)
        })
        
        artist.snp.makeConstraints { (make) in
            make.top.equalTo(self.trackName.snp.bottom).offset(3)
            make.left.equalTo(self.trackName.snp.left)
            make.right.equalTo(self.snp.right).offset(-5)
            make.centerX.equalTo(self.trackName)
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
