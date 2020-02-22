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
    var task: TaskList?
    var isSegueFromTableView: Bool?

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
        if isSegueFromTableView == true {
            taskVc.task = task
        }
    }
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        isSegueFromTableView = false
        performSegue(withIdentifier: "ListToTask", sender: self)
        }
    
    @IBAction func deleteTheListButtonTapped(_ sender: Any) {
        displayMultiChoiceAlert(title: "Vous êtes sur le point de supprimer cette liste", message: "") { (success) in
            guard success == true else {return}
            self.dataBaseManager?.deleteASpecificList(listName: self.list?.name ?? "")
            self.navigationController?.popViewController(animated: true)
//            self.dataBaseManager?.deleteAllLists()
//            self.allListsTableview.reloadData()
        }
    }
    
    
    func defineCrossLineValue(taskName: String, value: Int) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: taskName)
        attributeString.addAttribute(NSAttributedString.Key
            .strikethroughStyle, value: value, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
    

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
            cell.taskNameLabel.attributedText = defineCrossLineValue(taskName: cell.taskNameLabel.text ?? "", value: 2)
        } else {
            cell.doneTaskButton.isSelected = false
            cell.taskNameLabel.attributedText = defineCrossLineValue(taskName: cell.taskNameLabel.text ?? "", value: 0)  
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
        self.performSegue(withIdentifier: "ListToTask", sender: nil)
    }
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
        dataBaseManager?.updateTaskStatus(taskName: taskName, list: list, status: done, forKey: "isDone")
    }
    
    func importantTaskTapped(taskName: String, important: Bool) {
        guard let list = list else { return }
               dataBaseManager?.updateTaskStatus(taskName: taskName, list: list, status: important, forKey: "isImportant")
    }

    
    
}



