//
//  ImageViewMasked.swift
//  RateGigs
//
//  Created by Bryan Caragay on 1/11/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit

@IBDesignable
class ImageViewMasked: UIImageView {
    var maskImageView = UIImageView()
    
    @IBInspectable
    var maskImage: UIImage?{
        didSet{
            maskImageView.image = maskImage
            maskImageView.frame = bounds
            mask = maskImageView
        }
    }

}
