//
//  BaseTabBarItem.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/6/9.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit

class BaseTabBarItem: UITabBarItem {
    override func awakeFromNib() {
        super.awakeFromNib()
        textColor(colorString: "#999999", selectedColorString: "#FF6602")
        switch tag {
        case 1001:
            set(image: "icon_xy1", selectedImage: "icon_xy2")
        case 1002:
            set(image: "icon_xx1", selectedImage: "icon_xx2")
        case 1003:
            set(image: "icon_wd1", selectedImage: "icon_wd2")
           
        default:
            break
        }
        
    }
    
    func set(image:String,selectedImage:String){
        if let normal = UIImage(named: image){
            self.image = normal.withRenderingMode(.alwaysOriginal)
        }
        
        if let selected = UIImage(named: selectedImage){
            self.selectedImage = selected.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func textColor(colorString:String,selectedColorString:String){
        
        guard let textColor = UIColor(hexString: colorString),
            let selectColor = UIColor(hexString: selectedColorString) else{
                return
        }
        setTitleTextAttributes([NSForegroundColorAttributeName:selectColor], for: .selected)
        setTitleTextAttributes([NSForegroundColorAttributeName:textColor], for: .normal)
        
        
    }
}
