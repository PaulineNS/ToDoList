//
//  ListViewController.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var allTasksTableView: UITableView! { didSet { allTasksTableView.tableFooterView = UIView() }}
    
    // MARK: - Variables
    
    var list: List?
    private var dataBaseManager: DataBaseManager?
    private var task: TaskList?
    private var isSegueFromTableView: Bool?
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: Constants.Cell.listCellNibName, bundle: nil)
        allTasksTableView.register(nibName, forCellReuseIdentifier: Constants.Cell.listCellIdentifier)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taskVc = segue.destination as? TaskViewController else {return}
        taskVc.didAddNewTask = self
        taskVc.list = list
        if isSegueFromTableView == true {
            taskVc.task = task
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func addTaskButtonTapped(_ sender: UIButton) {
        isSegueFromTableView = false
        performSegue(withIdentifier: Constants.Segue.listToTaskSegue, sender: self)
    }
    
    @IBAction private func deleteTheListButtonTapped(_ sender: Any) {
        displayMultiChoiceAlert(title: "Vous êtes sur le point de supprimer cette liste", message: "") { (success) in
            guard success == true else {return}
            self.dataBaseManager?.deleteASpecificList(listName: self.list?.name ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - TableView DataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = list else {return 0}
        return dataBaseManager?.fetchTasksDependingList(list: list).count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        guard let list = list else {return UITableViewCell()}
        if dataBaseManager?.fetchTasksDependingList(list: list)[indexPath.row].isDone == true {
            cell.doneTaskButton.isSelected = true
            cell.taskNameLabel.attributedText = cell.taskNameLabel.text?.strikeThrough(value: 2)
        } else {
            cell.doneTaskButton.isSelected = false
            cell.taskNameLabel.attributedText =  cell.taskNameLabel.text?.strikeThrough(value: 0)
        }
        if dataBaseManager?.fetchTasksDependingList(list: list)[indexPath.row].isImportant == true {
            cell.importantTaskButton.isSelected = true
        } else {
            cell.importantTaskButton.isSelected = false
        }
        cell.task = dataBaseManager?.fetchTasksDependingList(list: list)[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let list = list else {return }
        let taskSelected = dataBaseManager?.fetchTasksDependingList(list: list)[indexPath.row]
        task = taskSelected
        isSegueFromTableView = true
        self.performSegue(withIdentifier: Constants.Segue.listToTaskSegue, sender: nil)
    }
}

// MARK: - TableView Delegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Vous n'avez pas encore de taches"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let list = list else {return 0}
        return dataBaseManager?.fetchTasksDependingList(list: list).isEmpty ?? true ? tableView.bounds.size.height : 0
    }
}

// MARK: - DidAddNewTaskDelegate

extension ListViewController: DidAddNewTaskDelegate {
    func addTapped() {
        allTasksTableView.reloadData()
    }
}

// MARK: - ListTableViewCellDelegate

extension ListViewController: ListTableViewCellDelegate {
    func doneTaskTapped(taskName: String, done: Bool) {
        guard let list = list else { return }
        dataBaseManager?.updateTaskStatus(taskName: taskName, list: list, status: done, forKey: Constants.DataBaseKeys.isDoneKey)
    }
    
    func importantTaskTapped(taskName: String, important: Bool) {
        guard let list = list else { return }
        dataBaseManager?.updateTaskStatus(taskName: taskName, list: list, status: important, forKey: Constants.DataBaseKeys.isImportantKey)
    }
}
