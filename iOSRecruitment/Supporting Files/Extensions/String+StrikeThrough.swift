//
//  String+CrossLine.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 23/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func strikeThrough(value: Int) -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
               value: value,
                   range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

