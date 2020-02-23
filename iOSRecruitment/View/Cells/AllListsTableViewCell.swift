//
//  AllListsTableViewCell.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

class AllListsTableViewCell: UITableViewCell {

    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var taskNumberLabel: UILabel!
    
    var list: List? {
        didSet {
            listNameLabel.text = list?.name
        }
    }
}
