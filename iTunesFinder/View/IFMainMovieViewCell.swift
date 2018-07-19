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
    
    private let containerView = UIView()
    
    private var thumbnail = UIImageView(frame: CGRect.zero)
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title = UILabel.init(frame: CGRect.zero)
        title.numberOfLines = 2
        title.lineBreakMode = .byWordWrapping
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = Utils.UIColorFromRGB(rgbValue: kMoviesFontColor)
        
        brief = UILabel.init(frame: CGRect.zero)
        brief.numberOfLines = 4
        brief.lineBreakMode = .byWordWrapping
        brief.font = UIFont.systemFont(ofSize: 12)
        brief.textColor = Utils.UIColorFromRGB(rgbValue: kMoviesFontColor)
        
        thumbnail.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        thumbnail.contentMode = .scaleAspectFit
        thumbnail.clipsToBounds = true
        
        self.addSubview(thumbnail)
        self.addSubview(title)
        self.addSubview(brief)
        
        self.applyConstraints()
    }
    
    func applyConstraints() {
        
        thumbnail.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(20)
            make.right.lessThanOrEqualTo(self.title.snp.left)
            make.bottom.equalTo(self).offset(-10)
            make.size.equalTo(90)
        })
        
        title.snp.makeConstraints({ (make) in
            make.left.equalTo(self.thumbnail.snp.right).offset(5)
            make.top.equalTo(self.thumbnail.snp.top).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
        })
        
        brief.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.title)
            make.top.equalTo(self.title.snp.bottom).offset(5)
            make.bottom.equalTo(self).offset(-10)
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
