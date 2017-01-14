//
//  SwiftExample.swift
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/10.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import Foundation
import UIKit
import PPAsyncDrawingKit

class SwiftExample: UIViewController {
    
    override func viewDidLoad() {
        let image = PPImageView(image: #imageLiteral(resourceName: "avatar"))
        image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.cornerRadius = 25
        view.addSubview(image)
    }
    
}
