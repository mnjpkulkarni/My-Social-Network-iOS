//
//  CircularButton.swift
//  My Social Network
//
//  Created by Manoj Kulkarni on 8/21/17.
//  Copyright © 2017 Manoj Kulkarni. All rights reserved.
//

import UIKit

class CircularButton: UIButton {


    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.8).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        imageView?.contentMode = .scaleAspectFit
        
    }

}
