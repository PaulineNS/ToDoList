//
//  String+CrossLine.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 23/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

extension String {
    
    ///Strike a string
    func strikeThrough(value: Int) -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: value,
            range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

