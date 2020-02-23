//
//  UIViewController+Date.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 22/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Change the date format in String
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
