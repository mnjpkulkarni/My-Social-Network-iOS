//
//  CustomView.swift
//  My Social Network
//
//  Created by Manoj Kulkarni on 8/21/17.
//  Copyright © 2017 Manoj Kulkarni. All rights reserved.
//

import UIKit

class CustomView: UIView {


    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
        
    }

}
