//
//  ImportantTasksViewController.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

final class ImportantTasksViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var importantsTasksTableView: UITableView! { didSet { importantsTasksTableView.tableFooterView = UIView() }}
    
    // MARK: - Variables
    
    private var dataBaseManager: DataBaseManager?
    private var list: List?
    private var task: TaskList?
    
    
    // MARK: -  Controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: Constants.Cell.importantsTasksCellNibName, bundle: nil)
        importantsTasksTableView.register(nibName, forCellReuseIdentifier: Constants.Cell.importantsTasksCellIdentifier)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        importantsTasksTableView.reloadData()
    }
    
    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taskVc = segue.destination as? TaskViewController else {return}
        taskVc.dismissTaskViewDelegate = self
        taskVc.task = task
        taskVc.list = list
    }
}

// MARK: - TableView Delegate

extension ImportantTasksViewController: UITableViewDelegate {
    
    /// Get in shape the tableView footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Vous n'avez pas de tâches importantes"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    /// Display the tableView footer depending the number of elements in favoritesRecipes
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataBaseManager?.fetchImportantsTasks().isEmpty ?? true ? tableView.bounds.size.height : 0
    }
    
}

// MARK: - TableView DataSource

extension ImportantTasksViewController: UITableViewDataSource {
    
    /// Number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBaseManager?.fetchImportantsTasks().count ?? 0
    }
    
    /// Cell defintion
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.importantsTasksCellIdentifier, for: indexPath) as? ImportantsTasksTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configureButtonImportantTaskCell(indexPath: indexPath.row)
        cell.task = dataBaseManager?.fetchImportantsTasks()[indexPath.row]
        return cell
    }
    
    /// Actions after selecting a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskList = dataBaseManager?.fetchImportantsTasks()[indexPath.row].owner else {return }
        let taskSelected = dataBaseManager?.fetchImportantsTasks()[indexPath.row]
        task = taskSelected
        list = taskList
        self.performSegue(withIdentifier: Constants.Segue.importantToTaskSSegue, sender: nil)
    }
}

// MARK: - ImportantsTasksTableViewCellDelegate

extension ImportantTasksViewController: ImportantsTasksTableViewCellDelegate {
    func doneTaskTapped(taskName: String, list: List, done: Bool) {
        dataBaseManager?.updateTaskStatus(taskName: taskName, list: list, status: done, forKey: Constants.DataBaseKeys.isDoneKey)
    }
    
    func importantTaskTapped(taskName: String, list: List, important: Bool) {
        dataBaseManager?.updateTaskStatus(taskName: taskName, list: list, status: important, forKey: Constants.DataBaseKeys.isImportantKey)
        importantsTasksTableView.reloadData()
    }
}

// MARK: - DismissTaskViewDelegate

extension ImportantTasksViewController: DismissTaskViewDelegate {
    func leaveTheView() {
        importantsTasksTableView.reloadData()
    }
}


