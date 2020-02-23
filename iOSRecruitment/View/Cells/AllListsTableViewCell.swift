//
//  AllListsTableViewCell.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

final class AllListsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var taskNumberLabel: UILabel!
    
    // MARK: - Variables
    
    private var dataBaseManager: DataBaseManager?
    var list: List? {
        didSet {
            listNameLabel.text = list?.name
            guard let list = list else {return}
            guard let numberOfList = dataBaseManager?.fetchTasksDependingList(list: list).count else {return}
            if numberOfList <= 1 {
                taskNumberLabel.text = "\(numberOfList) tâche"
            } else {
                taskNumberLabel.text = "\(numberOfList) tâches"
            }
        }
    }
    
    // MARK: - Awake from Nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
    }
}
