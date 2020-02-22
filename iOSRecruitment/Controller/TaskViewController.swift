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
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var doneTaskButton: UIButton!
    @IBOutlet weak var importantTaskButton: UIButton!
    
    var dataBaseManager: DataBaseManager?
    var didAddNewTask: DidAddNewTask?
    var list: List?
    var task: TaskList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        taskNameTextField.font = font
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
        prepareTheView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissTheView()
    }
    
    func prepareTheView() {
        if task == nil {
            manageElementVisibility(isUpdateElementsHidden: false, isDisplayElementsHidden: true, isTxtFieldEnable: true, border: .roundedRect)
        } else {
            manageElementVisibility(isUpdateElementsHidden: true, isDisplayElementsHidden: false, isTxtFieldEnable: false, border: .none)
            taskNoteTextView.text = task?.note
            taskNameTextField.text = task?.name
            if task?.isDone == true {
                print("true isDone")
                doneTaskButton.isSelected = true
                taskNameTextField.attributedText = defineCrossLineValue(taskName: taskNameTextField.text ?? "", value: 2)
            } else {
                print("false isDone")
                doneTaskButton.isSelected = false
                taskNameTextField.attributedText = defineCrossLineValue(taskName: taskNameTextField.text ?? "", value: 0)
            }
            if task?.isImportant == true {
                importantTaskButton.isSelected = true
                print("true isImportant")
            } else {
                print("false isImportant")
                importantTaskButton.isSelected = false
            }
        }
    }
    
    func defineCrossLineValue(taskName: String, value: Int) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: taskName)
        attributeString.addAttribute(NSAttributedString.Key
            .strikethroughStyle, value: value, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func manageElementVisibility(isUpdateElementsHidden: Bool, isDisplayElementsHidden: Bool, isTxtFieldEnable: Bool, border: UITextField.BorderStyle) {
        
        
        addTaskButton.isHidden = isUpdateElementsHidden
        taskNameTextField.isUserInteractionEnabled = isTxtFieldEnable
        taskNoteTextView.isUserInteractionEnabled = isTxtFieldEnable
        taskDeadlineTextField.isUserInteractionEnabled = isTxtFieldEnable
        taskDeadlineTextField.borderStyle = border
        taskNameTextField.borderStyle = border
    }
    
    var isSegueFromNew: Bool?
    
    
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
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        createTask()
        dismissTheView()
    }
    @IBAction func doneTaskButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            dataBaseManager?.updateTaskStatus(taskName: taskNameTextField.text ?? "", list: list ?? List(), status: false, forKey: "isDone")
            taskNameTextField.attributedText = defineCrossLineValue(taskName: taskNameTextField.text ?? "", value: 0)
        } else {
            sender.isSelected = true
            taskNameTextField.attributedText = defineCrossLineValue(taskName: taskNameTextField.text ?? "", value: 2)
            dataBaseManager?.updateTaskStatus(taskName: taskNameTextField.text ?? "", list: list ?? List(), status: true, forKey: "isDone")
            
        }
    }
    
    @IBAction func importantTaskButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            dataBaseManager?.updateTaskStatus(taskName: taskNameTextField.text ?? "", list: list ?? List(), status: false, forKey: "isImportant")
        } else {
            sender.isSelected = true
            dataBaseManager?.updateTaskStatus(taskName: taskNameTextField.text ?? "", list: list ?? List(), status: true, forKey: "isImportant")
        }
    }
}
