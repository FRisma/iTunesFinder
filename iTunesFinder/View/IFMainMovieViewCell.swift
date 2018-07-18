//
//  IFMainMovieViewCell.swift
//  iTunesFinder
//
//  Created by Franco Risma on 17/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

class IFMainMovieViewCell: UITableViewCell {
    public var title = UILabel() {
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
        title.numberOfLines = 2
        title.lineBreakMode = .byWordWrapping
        title.font = UIFont.systemFont(ofSize: 16)
        
        brief = UILabel.init(frame: CGRect.zero)
        brief.numberOfLines = 0
        brief.lineBreakMode = .byWordWrapping
        brief.font = UIFont.systemFont(ofSize: 14)
        
        thumbnail.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        thumbnail.contentMode = .scaleToFill
        thumbnail.clipsToBounds = true
        
        self.addSubview(thumbnail)
        self.addSubview(title)
        self.addSubview(brief)
        
        self.applyConstraints()
    }
    
    func applyConstraints() {
        
        thumbnail.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
            make.size.equalTo(300)
        })
        
        title.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(5)
            make.top.equalTo(self.snp.top).offset(5)
            make.right.equalTo(self.snp.right).offset(-5)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.brief.snp.top)
        })
        
        brief.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.title).offset(10)
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
