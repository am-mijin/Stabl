//
//  CustomSlider.swift
//  Stabl
//
//  Created by Mijin Cho on 25/05/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        //keeps original origin and width, changes height, you get the idea
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 50.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    //while we are here, why not change the image here as well? (bonus material)
    override func awakeFromNib() {
        self.setThumbImage(UIImage(named: "slider_thumb"), for: UIControlState())
         
        super.awakeFromNib()
    }

}
