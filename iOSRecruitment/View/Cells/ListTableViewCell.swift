//
//  ListTableViewCell.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var doneTaskButton: UIButton!
    @IBOutlet weak var importantTaskButton: UIButton!
    
    var delegate: ListTableViewCellDelegate?
    var isTaskDone: Bool?
    var isTaskImportant: Bool?
    
    var task: TaskList? {
        didSet {
            taskNameLabel.text = task?.name
        }
    }
    
    @IBAction func doneTaskButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            isTaskDone = false
            taskNameLabel.attributedText = taskNameLabel.text?.strikeThrough(value: 0)
        } else {
            sender.isSelected = true
            taskNameLabel.attributedText = taskNameLabel.text?.strikeThrough(value: 2)
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
