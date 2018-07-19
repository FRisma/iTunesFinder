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
    let containerView = UIView()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title = UILabel.init(frame: CGRect.zero)
        title.numberOfLines = 2
        title.lineBreakMode = .byWordWrapping
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = Utils.UIColorFromRGB(rgbValue: kTvShowFontColor)
        
        episode = UILabel.init(frame: CGRect.zero)
        episode.numberOfLines = 3
        episode.lineBreakMode = .byWordWrapping
        episode.font = UIFont.systemFont(ofSize: 14)
        episode.textColor = Utils.UIColorFromRGB(rgbValue: kTvShowFontColor)
        
        brief = UILabel.init(frame: CGRect.zero)
        brief.numberOfLines = 0
        brief.lineBreakMode = .byWordWrapping
        brief.font = UIFont.systemFont(ofSize: 9)
        brief.textColor = Utils.UIColorFromRGB(rgbValue: kTvShowFontColor)
        
        thumbnail.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        thumbnail.contentMode = .scaleToFill
        thumbnail.clipsToBounds = true
        
        containerView.addSubview(thumbnail)
        containerView.addSubview(title)
        containerView.addSubview(episode)
        containerView.addSubview(brief)
        self.addSubview(containerView)
        
        self.applyConstraints()
    }
    
    func applyConstraints() {
        
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self).offset(-10)
        }
        
        thumbnail.snp.makeConstraints({ (make) in
            make.left.equalTo(self.containerView.snp.left).offset(3)
            make.top.equalTo(self.containerView.snp.top).offset(3)
            make.right.lessThanOrEqualTo(self.title.snp.left)
            make.bottom.equalTo(self.containerView.snp.bottom).offset(-3)
            make.size.equalTo(120)
        })
        
        title.snp.makeConstraints({ (make) in
            make.left.equalTo(self.thumbnail.snp.right).offset(5)
            make.top.equalTo(self.containerView.snp.top).offset(5)
            make.right.equalTo(self.snp.right).offset(-5)
        })
        
        episode.snp.makeConstraints({ (make) in
            make.left.equalTo(self.thumbnail.snp.right).offset(5)
            make.top.equalTo(self.title.snp.bottom).offset(5)
            make.right.equalTo(self.containerView.snp.right).offset(-5)
        })
        
        brief.snp.makeConstraints { (make) in
            make.top.equalTo(self.episode.snp.bottom).offset(3)
            make.left.equalTo(self.title.snp.left)
            make.right.equalTo(self.containerView.snp.right).offset(-5)
            make.bottom.lessThanOrEqualTo(containerView)
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
