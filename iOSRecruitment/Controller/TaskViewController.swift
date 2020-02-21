//
//  TaskViewController.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

protocol DidAddNewTask {
    func addTapped()
}

class TaskViewController: UIViewController {

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskNoteTextView: UITextView!
    @IBOutlet weak var taskDeadlineTextField: UITextField!
    @IBOutlet weak var updateTaskButton: UIButton!
    @IBOutlet weak var addTaskButton: UIButton!
    
    var dataBaseManager: DataBaseManager?
    var didAddNewTask: DidAddNewTask?
    var list: List?


    override func viewDidLoad() {
        super.viewDidLoad()
        updateTaskButton.isHidden = true
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)

//        manageInteractionWithOutlets()
    }
    
    var isSegueFromNew: Bool?
    
    func manageInteractionWithOutlets() {
        updateTaskButton.isHidden = true
        taskNameTextField.isEnabled = false
        taskNoteTextView.isEditable = false
        taskDeadlineTextField.isEnabled = false
    }
    
    func createTask() {
        guard let taskName = taskNameTextField.text, let ownerList = list else { return }
        print(taskName)
        self.dataBaseManager?.createTask(name: taskName, list: ownerList, note: "")
    }
    
    func dismissTheView() {
        didAddNewTask?.addTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismissTheView()
    }
    
    @IBAction func trashButtonTapped(_ sender: UIButton) {
        dismissTheView()
    }
    
    @IBAction func updateTaskButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        createTask()
        dismissTheView()
    }
}
