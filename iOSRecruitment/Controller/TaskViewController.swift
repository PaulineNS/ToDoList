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
    @IBOutlet weak var doneTaskButton: UIButton!
    
    var dataBaseManager: DataBaseManager?
    var didAddNewTask: DidAddNewTask?
    var list: List?
    var task: TaskList?


    override func viewDidLoad() {
        super.viewDidLoad()
        updateTaskButton.isHidden = true
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        taskNameTextField.font = font
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
        prepareTheView()
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
                taskNameTextField.attributedText = crossTheTask(taskName: taskNameTextField.text ?? "")
            } else {
                print("false isDone")
                doneTaskButton.isSelected = false
            }
            if task?.isImportant == true {
//                cell.importantTaskButton.isSelected = true
                print("true isImportant")
            } else {
                print("false isImportant")
//                cell.importantTaskButton.isSelected = false
            }
            
            
        }
    }
    
    func crossTheTask(taskName: String) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: taskName)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func manageElementVisibility(isUpdateElementsHidden: Bool, isDisplayElementsHidden: Bool, isTxtFieldEnable: Bool, border: UITextField.BorderStyle) {


        addTaskButton.isHidden = isUpdateElementsHidden
        updateTaskButton.isHidden = isDisplayElementsHidden
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
    
    @IBAction func updateTaskButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        createTask()
        dismissTheView()
    }
}
