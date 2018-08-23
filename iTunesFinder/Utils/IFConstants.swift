
//
//  IFConstants
//  iTunesFinder
//
//  Created by Franco Risma on 16/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

let API_URL             = "https://itunes.apple.com/search"

// Langs

let kMoviesMenuFilter   = "Movies"
let kMusicMenuFilter    = "Music"
let kTvShowMenuFilter   = "Tv Shows"

// Colors
let kTvShowNavigationBarColor   : UInt  = 0xf76f6f
let kTvShowBackgroundColor      : UInt  = 0xf44242
let kTvShowFontColor            : UInt  = 0xfff200
let kMusicNavigationBarColor    : UInt  = 0x3E3C40
let kMusicBackgroundColor       : UInt  = 0x434443
let kMusicFontColor             : UInt  = 0xf97800
let kMoviesNavigationBarColor   : UInt  = 0x477286
let kMoviesBackgroundColor      : UInt  = 0x27556C
let kMoviesFontColor            : UInt  = 0xffffff

extension UIColor {
    public convenience init(fromRGBValue rgb: UInt) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
