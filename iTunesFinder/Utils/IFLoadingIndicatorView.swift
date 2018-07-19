//
//  IFLoadingIndicatorView.swift
//  iTunesFinder
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

class IFLoadingIndicatorView: UIView {
    
    static let singleton = IFLoadingIndicatorView()
    
    let loadingIndicator: UIActivityIndicatorView!
    
    override private init(frame: CGRect) {
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = UIScreen.main.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        loadingIndicator.center = self.center
        loadingIndicator.hidesWhenStopped = true;
        
        self.addSubview(loadingIndicator)
        self.bringSubview(toFront: loadingIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
    
    override func didMoveToSuperview() {
        if (self.superview != nil) {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.startAnimating()
        }
    }
}
