//
//  CircleView.swift
//  My Social Network
//
//  Created by Manoj Kulkarni on 9/1/17.
//  Copyright © 2017 Manoj Kulkarni. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
