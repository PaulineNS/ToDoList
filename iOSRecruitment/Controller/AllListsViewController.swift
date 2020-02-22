//
//  AllListsViewController.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

class AllListsViewController: UIViewController {

    @IBOutlet weak var allListsTableview: UITableView! { didSet { allListsTableview.tableFooterView = UIView() }}
    @IBOutlet weak var addListButton: UIButton!
    
    var dataBaseManager: DataBaseManager?
    var list: List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "AllListsTableViewCell", bundle: nil)
        allListsTableview.register(nibName, forCellReuseIdentifier: "allListsCell")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.allListsTableview.reloadData()
    }
    
    
    @IBAction func addListButtonTapped(_ sender: UIButton) {
        displayTextFieldAlert(title: "Nouvelle liste", message: "Veuillez lui donner un nom", placeholder: "Liste") { [unowned self] listName in
            guard let listName = listName, !listName.isBlank else { return }
            
            guard self.dataBaseManager?.checkListExistence(listName: listName) == false else {
                self.displayMessageAlert(title: "Une liste portant ce nom existe déjà", message: "Veuillez en choisir un autre")
                return}
            self.dataBaseManager?.createList(name: listName)
            self.allListsTableview.reloadData()
        }
    }
    
    @IBAction func deleteAllListsButtonTapped(_ sender: UIBarButtonItem) {
        displayMultiChoiceAlert(title: "Voulez-vous vraiment supprimer toutes vos listes ?", message: "") { (success) in
            guard success == true else {return}
            self.dataBaseManager?.deleteAllLists()
            self.allListsTableview.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "AllToList" else {return}
        guard let listVc = segue.destination as? ListViewController else {return}
        listVc.navigationItem.title = list?.name
        listVc.list = list
    }
}

extension AllListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBaseManager?.lists.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "allListsCell", for: indexPath) as? AllListsTableViewCell else {
            return UITableViewCell()
        }
        cell.list = dataBaseManager?.lists[indexPath.row]
        guard let list = dataBaseManager?.lists[indexPath.row] else {return UITableViewCell()}
        cell.taskNumberLabel.text = "\(dataBaseManager?.fetchTasksDependingList(list: list).count ?? 0) tâches"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listSelected = dataBaseManager?.lists[indexPath.row]
        list = listSelected
        self.performSegue(withIdentifier: "AllToList", sender: nil)
    }
}

extension AllListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Vous n'avez pas encore de listes"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataBaseManager?.lists.isEmpty ?? true ? tableView.bounds.size.height : 0
    }
}
