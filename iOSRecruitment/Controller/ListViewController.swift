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

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ListTableViewCell", bundle: nil)
        allTasksTableView.register(nibName, forCellReuseIdentifier: "ListCell")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
    }
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ListToTask", sender: self)
//        displayTaskAlert(title: "Nouvelle tâche", message: "", placeholder: "Tâche") { [unowned self] taskName in
//            guard let taskName = taskName, !taskName.isBlank else { return }
//            self.dataBaseManager?.createTask(name: taskName)
//            self.allTasksTableView.reloadData()
//        }
    }
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBaseManager?.tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.task = dataBaseManager?.tasks[indexPath.row]
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
        return dataBaseManager?.tasks.isEmpty ?? true ? tableView.bounds.size.height : 0
    }
}

