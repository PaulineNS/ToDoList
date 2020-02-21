//
//  ListTableViewCell.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate {
    
    func doneTaskTapped(taskName: String, done: Bool)
    func importantTaskTapped(taskName: String, important: Bool)
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var doneTaskButton: UIButton!
    @IBOutlet weak var importantTaskButton: UIButton!
    
    var delegate: ListTableViewCellDelegate?
    var isTaskDone: Bool?
    var isTaskImportant: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var task: TaskList? {
        didSet {
            taskNameLabel.text = task?.name
        }
    }
    
    @IBAction func doneTaskButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            isTaskDone = false
        } else {
            sender.isSelected = true
            isTaskDone = true
        }
        guard let taskName = taskNameLabel.text, let taskStatus = isTaskDone else {return}
        delegate?.doneTaskTapped(taskName: taskName, done: taskStatus)
    }
    
    
    @IBAction func importantTaskButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            isTaskImportant = false
        } else {
            sender.isSelected = true
            isTaskImportant = true
        }
        guard let taskName = taskNameLabel.text, let taskStatus = isTaskImportant else {return}
        delegate?.importantTaskTapped(taskName: taskName, important: taskStatus)
    }
    
}
