//
//  TaskViewController.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

final class TaskViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var taskNameTextField: UITextField!
    @IBOutlet private weak var taskNoteTextView: UITextView!
    @IBOutlet private weak var taskDeadlineTextField: UITextField!
    @IBOutlet private weak var addTaskButton: UIButton!
    @IBOutlet private weak var doneTaskButton: UIButton!
    @IBOutlet private weak var importantTaskButton: UIButton!
    @IBOutlet private weak var trashButton: UIButton!
    
    // MARK: - Variables
    
    var dismissTaskViewDelegate: DismissTaskViewDelegate?
    var list: List?
    var task: TaskList?
    private var dataBaseManager: DataBaseManager?
    private var datePicker: UIDatePicker?
    private var deadLinedate: String?
    private let minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        taskNameTextField.font = font
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
        prepareTheView()
        manageDatePicker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissTheView()
    }
    
    // MARK: - Actions
    
    @objc private func dateChanged(datePicker: UIDatePicker) {
        deadLinedate = convertDateToString(date: datePicker.date)
        taskDeadlineTextField.text = deadLinedate
    }
    
    @IBAction private func backButtonTapped(_ sender: UIButton) {
        dismissTheView()
    }
    
    @IBAction private func addTaskButtonTapped(_ sender: UIButton) {
        if taskNameTextField.text != "" && createTask() == true {
            dismissTheView()
        } else {
            displayMessageAlert(title: "Ajout impossible", message: "Veuillez ajouter un titre à votre tâche")
        }
    }
    
    @IBAction private func doneTaskButtonTapped(_ sender: UIButton) {
        guard sender.isSelected else { sender.isSelected = true
            taskNameTextField.attributedText = taskNameTextField.text?.strikeThrough(value: 2)
            dataBaseManager?.updateTaskStatus(taskName: taskNameTextField.text ?? "", list: list ?? List(), status: true, forKey: Constants.DataBaseKeys.isDoneKey)
            return }
        sender.isSelected = false
        dataBaseManager?.updateTaskStatus(taskName: taskNameTextField.text ?? "", list: list ?? List(), status: false, forKey: Constants.DataBaseKeys.isDoneKey)
        taskNameTextField.attributedText = taskNameTextField.text?.strikeThrough(value: 0)
    }
    
    
    @IBAction private func importantTaskButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            dataBaseManager?.updateTaskStatus(taskName: taskNameTextField.text ?? "", list: list ?? List(), status: false, forKey: Constants.DataBaseKeys.isImportantKey)
        } else {
            sender.isSelected = true
            dataBaseManager?.updateTaskStatus(taskName: taskNameTextField.text ?? "", list: list ?? List(), status: true, forKey: Constants.DataBaseKeys.isImportantKey)
        }
    }
    
    @IBAction private func deleteTaskButtonTapped(_ sender: UIButton) {
        displayMultiChoiceAlert(title: "Voulez-vous supprimer cette tâche ?", message: "") { (success) in
            guard success == true else {return}
            self.dataBaseManager?.deleteASpecificTask(taskName: self.task?.name ?? "", list: self.list ?? List())
            self.dismissTheView()
        }
    }
    
    // MARK: - Methods
    
    private func prepareTheView() {
        guard task == nil else {
            manageElementVisibility(isUpdateElementsHidden: true, isDisplayElementsHidden: false, isTxtFieldEnable: false, border: .none)
            taskNoteTextView.text = task?.note
            taskNameTextField.text = task?.name
            taskDeadlineTextField.text = task?.deadline
            if task?.isDone == true {
                doneTaskButton.isSelected = true
                taskNameTextField.attributedText = taskNameTextField.text?.strikeThrough(value: 2)
            } else {
                doneTaskButton.isSelected = false
                taskNameTextField.attributedText = taskNameTextField.text?.strikeThrough(value: 0)
            }
            if task?.isImportant == true {
                importantTaskButton.isSelected = true
            } else {
                importantTaskButton.isSelected = false
            }
            return }
        manageElementVisibility(isUpdateElementsHidden: false, isDisplayElementsHidden: true, isTxtFieldEnable: true, border: .roundedRect)
    }
    
    private func manageElementVisibility(isUpdateElementsHidden: Bool, isDisplayElementsHidden: Bool, isTxtFieldEnable: Bool, border: UITextField.BorderStyle) {
        importantTaskButton.isHidden = isDisplayElementsHidden
        doneTaskButton.isHidden = isDisplayElementsHidden
        trashButton.isHidden = isDisplayElementsHidden
        addTaskButton.isHidden = isUpdateElementsHidden
        taskNameTextField.isUserInteractionEnabled = isTxtFieldEnable
        taskNoteTextView.isUserInteractionEnabled = isTxtFieldEnable
        taskDeadlineTextField.isUserInteractionEnabled = isTxtFieldEnable
        taskDeadlineTextField.borderStyle = border
        taskNameTextField.borderStyle = border
    }
    
    private func manageDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.minimumDate = minimumDate
        datePicker?.locale = Locale.init(identifier: "fr_FR")
        taskDeadlineTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(TaskViewController.dateChanged(datePicker:)), for: .valueChanged)
    }
    
    private func createTask() -> Bool {
        guard let taskName = taskNameTextField.text, let ownerList = list, let taskNote = taskNoteTextView.text else { return false }
        var noteTask = taskNote.trimmingCharacters(in: .whitespaces)
        var dateTask = deadLinedate
        if noteTask == "Ajouter une note" || noteTask == "" {
            noteTask = "Pas de note sur cette tâche"
        }
        if dateTask == nil {
            dateTask = "Pas d'échéance"
        }
        guard dataBaseManager?.checkTaskExistenceInList(taskName: taskName, list: list ?? List()) == false else { self.displayMessageAlert(title: "Une tâche portant ce nom existe déjà dans la liste", message: "Veuillez en choisir un autre")
            return false}
        self.dataBaseManager?.createTask(name: taskName, list: ownerList, note: noteTask, deadLine: dateTask ?? "")
        return true
    }
    
    private func dismissTheView() {
        dismissTaskViewDelegate?.leaveTheView()
        self.dismiss(animated: true, completion: nil)
    }
}
