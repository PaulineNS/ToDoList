//
//  ListTableViewCell.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

final class ListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var doneTaskButton: UIButton!
    @IBOutlet weak var importantTaskButton: UIButton!
    
    // MARK: - Variables

    var delegate: ListTableViewCellDelegate?
    private var dataBaseManager: DataBaseManager?
    private var isTaskDone: Bool?
    private var isTaskImportant: Bool?
    var task: TaskList? {
        didSet {
            taskNameLabel.text = task?.name
        }
    }
    
    // MARK: - Awake from Nib

    override func awakeFromNib() {
        super.awakeFromNib()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
    }
    
    // MARK: - Actions

    @IBAction func doneTaskButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            taskNameLabel.attributedText = taskNameLabel.text?.strikeThrough(value: 0)
            isTaskDone = false
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
    
    // MARK: - Methods

    func configureButtonTaskCell(list: List, indexPath: Int) {
        if dataBaseManager?.fetchTasksDependingList(list: list)[indexPath].isDone == true {
            doneTaskButton.isSelected = true
            taskNameLabel.attributedText = taskNameLabel.text?.strikeThrough(value: 2)
        } else {
            doneTaskButton.isSelected = false
            taskNameLabel.attributedText = taskNameLabel.text?.strikeThrough(value: 0)
        }
        if dataBaseManager?.fetchTasksDependingList(list: list)[indexPath].isImportant == true {
            importantTaskButton.isSelected = true
        } else {
            importantTaskButton.isSelected = false
        }
    }
}
