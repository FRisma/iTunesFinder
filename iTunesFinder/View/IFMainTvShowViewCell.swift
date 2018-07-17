//
//  IFMainTvShowViewCell.swift
//  iTunesFinder
//
//  Created by Franco Risma on 17/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

class IFMainTvShowViewCell: UITableViewCell {
    public var title = UILabel() {
        didSet {
            self.setNeedsLayout()
        }
    }
    public var episode = UILabel() {
        didSet {
            self.setNeedsLayout()
        }
    }
    public var brief = UILabel() {
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
        
        episode = UILabel.init(frame: CGRect.zero)
        episode.font = UIFont.systemFont(ofSize: 14)
        
        brief = UILabel.init(frame: CGRect.zero)
        brief.font = UIFont.systemFont(ofSize: 9)
        
        thumbnail.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        thumbnail.contentMode = .scaleToFill
        thumbnail.clipsToBounds = true
        
        self.addSubview(title)
        self.addSubview(episode)
        self.addSubview(brief)
        self.addSubview(thumbnail)
        
        self.applyConstraints()
    }
    
    func applyConstraints() {
        
        thumbnail.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        title.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(5)
            make.top.equalTo(self.snp.top).offset(5)
            make.right.equalTo(self.snp.right).offset(-5)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.episode.snp.top)
        })
        
        episode.snp.makeConstraints { (make) in
            make.top.equalTo(self.title.snp.bottom).offset(3)
            make.left.equalTo(self.title.snp.left)
            make.right.equalTo(self.snp.right).offset(-5)
            make.bottom.equalTo(self.thumbnail.snp.bottom)
        }
        
        brief.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.episode).offset(10)
            make.bottom.equalTo(self)
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
