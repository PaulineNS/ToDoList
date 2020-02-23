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
    
    @IBOutlet weak var trashButton: UIBarButtonItem!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allTasksTableView.reloadData()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taskVc = segue.destination as? TaskViewController else {return}
        taskVc.dismissTaskViewDelegate = self
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.3284006715, green: 0.3364258707, blue: 0.3787038028, alpha: 1)
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
    
    /// Delete a list from coreData depending his name
    @IBAction private func deleteTheListButtonTapped(_ sender: Any) {
        displayMultiChoiceAlert(title: "Vous êtes sur le point de supprimer cette liste", message: "") { (success) in
            guard success == true else {return}
            guard let list = self.list else {return}
            self.dataBaseManager?.deleteAllTasks(list: list)
            self.dataBaseManager?.deleteASpecificList(listName: self.list?.name ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - TableView DataSource

extension ListViewController: UITableViewDataSource {
    
    /// Number of cells in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = list else {return 0}
        return dataBaseManager?.fetchTasksDependingList(list: list).count ?? 0
    }
    
    /// Define tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.listCellIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell()}
        guard let list = list else {return UITableViewCell()}
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configureButtonTaskCell(list: list, indexPath: indexPath.row)
        cell.task = dataBaseManager?.fetchTasksDependingList(list: list)[indexPath.row]
        return cell
    }
    
    /// Actions after a cell selection
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
    
    /// Get in shape the tableView footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Vous n'avez pas encore de taches"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    /// Display the tableView footer depending the number of elements in favoritesRecipes
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let list = list else {return 0}
        return dataBaseManager?.fetchTasksDependingList(list: list).isEmpty ?? true ? tableView.bounds.size.height : 0
    }
    
    /// Can Edit the tableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Can delete a cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Supprimer") { (action, indexPath) in
            guard let list = self.list else {return}
            guard let taskName = self.dataBaseManager?.fetchTasksDependingList(list: list)[indexPath.row].name else {return}
            self.displayMultiChoiceAlert(title: "Voulez-vous supprimer cette tâche ?", message: "") { (success) in
            guard success == true else {return}
            self.dataBaseManager?.deleteASpecificTask(taskName: taskName, list: list)
            self.allTasksTableView.reloadData()
            }
        }
        deleteButton.backgroundColor = #colorLiteral(red: 0.3228748441, green: 0.7752146125, blue: 0.8510860205, alpha: 1)
        return [deleteButton]
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

// MARK: - DismissTaskViewDelegate

extension ListViewController: DismissTaskViewDelegate {
    func leaveTheView() {
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.9664614797, green: 0.7589220405, blue: 0.1949376464, alpha: 1)
        navigationItem.setHidesBackButton(false, animated: true)
        allTasksTableView.reloadData()
    }
}

