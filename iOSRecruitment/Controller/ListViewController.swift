//
//  ListViewController.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var allTasksTableView: UITableView! { didSet { allTasksTableView.tableFooterView = UIView() }}
    
    var dataBaseManager: DataBaseManager?
    var list: List?

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ListTableViewCell", bundle: nil)
        allTasksTableView.register(nibName, forCellReuseIdentifier: "ListCell")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taskVc = segue.destination as? TaskViewController else {return}
        taskVc.didAddNewTask = self
        taskVc.list = list
    }
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ListToTask", sender: self)
//        displayAlert(title: "Nouvelle tâche", message: "", placeholder: "Tâche") { [unowned self] taskName in
//            guard let taskName = taskName, !taskName.isBlank else { return }
//            self.dataBaseManager?.createTask(name: taskName)
//            self.allTasksTableView.reloadData()
        }

    
    }
    

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = list else {return 0}
        return dataBaseManager?.fetchTasksDependingList(list: list).count ?? 0
        
//        tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        guard let list = list else {return UITableViewCell()}

        if dataBaseManager?.fetchTasksDependingList(list: list)[indexPath.row].isDone == true {
            cell.doneTaskButton.isSelected = true
        } else {
            cell.doneTaskButton.isSelected = false
        }
        if dataBaseManager?.fetchTasksDependingList(list: list)[indexPath.row].isImportant == true {
            cell.importantTaskButton.isSelected = true
        } else {
            cell.importantTaskButton.isSelected = false
        }
        cell.task = dataBaseManager?.fetchTasksDependingList(list: list)[indexPath.row]
        
        cell.delegate = self

//        tasks[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let listSelected = dataBaseManager?.lists[indexPath.row]
//        list = listSelected
//        self.performSegue(withIdentifier: "AllToList", sender: nil)
//    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Vous n'avez pas encore de taches"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let list = list else {return 0}
        return dataBaseManager?.fetchTasksDependingList(list: list).isEmpty ?? true ? tableView.bounds.size.height : 0

        
//        tasks.isEmpty ?? true ? tableView.bounds.size.height : 0
    }
}

extension ListViewController: DidAddNewTask {
    func addTapped() {
        allTasksTableView.reloadData()
    }
}

extension ListViewController: ListTableViewCellDelegate {
    func doneTaskTapped(taskName: String, done: Bool) {
        guard let list = list else { return }
        dataBaseManager?.updateDoneTask(taskName: taskName, list: list, doneStatus: done, forKey: "isDone")
    }
    
    func importantTaskTapped(taskName: String, important: Bool) {
        guard let list = list else { return }
               dataBaseManager?.updateDoneTask(taskName: taskName, list: list, doneStatus: important, forKey: "isImportant")
    }

    
    
}



