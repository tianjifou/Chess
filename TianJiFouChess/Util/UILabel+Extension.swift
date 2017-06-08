//
//  UILabel+Extension.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/15.
//  Copyright © 2017年 tianjifou. All rights reserved.
//
import UIKit

extension UILabel {
    
    class  func createLabel(fontSize size:CGFloat,textColor:UIColor) -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: size)
        label.textColor = textColor
        return label
    }
}
