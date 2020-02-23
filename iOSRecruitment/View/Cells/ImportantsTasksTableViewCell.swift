//
//  ImportantsTasksTableViewCell.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 23/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

final class ImportantsTasksTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var doneTaskButton: UIButton!
    @IBOutlet weak var importantTaskButton: UIButton!
    
    
    // MARK: - Variables
    
    var delegate: ImportantsTasksTableViewCellDelegate?
    private var dataBaseManager: DataBaseManager?
    private var isTaskDone: Bool?
    private var isTaskImportant: Bool?
    var task: TaskList? {
        didSet {
            taskNameLabel.text = task?.name
            guard let listName  = task?.owner?.name else {return}
            listNameLabel.text = " Liste : \(listName)"
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
        guard let taskName = taskNameLabel.text, let taskStatus = isTaskDone, let list = task?.owner else {return}
        delegate?.doneTaskTapped(taskName: taskName, list: list, done: taskStatus)
    }
    
    
    @IBAction func importantTaskButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            isTaskImportant = false
        } else {
            sender.isSelected = true
            isTaskImportant = true
        }
        guard let taskName = taskNameLabel.text, let taskStatus = isTaskImportant, let list = task?.owner else {return}
        delegate?.importantTaskTapped(taskName: taskName, list: list, important: taskStatus)
    }
    
    // MARK: - Methods

    func configureButtonImportantTaskCell(indexPath: Int) {
        if dataBaseManager?.fetchImportantsTasks()[indexPath].isDone == true {
            doneTaskButton.isSelected = true
            taskNameLabel.attributedText = taskNameLabel.text?.strikeThrough(value: 2)
        } else {
            doneTaskButton.isSelected = false
            taskNameLabel.attributedText = taskNameLabel.text?.strikeThrough(value: 0)
        }
        if dataBaseManager?.fetchImportantsTasks()[indexPath].isImportant == true {
            importantTaskButton.isSelected = true
        } else {
            importantTaskButton.isSelected = false
        }
    }
}


