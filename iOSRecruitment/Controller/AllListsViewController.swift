//
//  AllListsViewController.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

final class AllListsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var allListsTableview: UITableView! { didSet { allListsTableview.tableFooterView = UIView() }}
    @IBOutlet private weak var addListButton: UIButton!
    
    // MARK: - Variables
    
    private var dataBaseManager: DataBaseManager?
    private var list: List?
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: Constants.Cell.allListCellNibName, bundle: nil)
        allListsTableview.register(nibName, forCellReuseIdentifier: Constants.Cell.allListCellIdentifier)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.allListsTableview.reloadData()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Segue.allToListSegue else {return}
        guard let listVc = segue.destination as? ListViewController else {return}
        listVc.navigationItem.title = list?.name
        listVc.list = list
    }
    
    // MARK: - Actions
    
    /// Adding a new list to coreData
    @IBAction private func addListButtonTapped(_ sender: UIButton) {
        displayTextFieldAlert(title: "Nouvelle liste", message: "Veuillez lui donner un nom", placeholder: "Liste") { [unowned self] listName in
            guard let listName = listName, !listName.isBlank else { return }
            guard self.dataBaseManager?.checkListExistence(listName: listName) == false else {
                self.displayMessageAlert(title: "Une liste portant ce nom existe déjà", message: "Veuillez en choisir un autre")
                return}
            self.dataBaseManager?.createList(name: listName)
            self.allListsTableview.reloadData()
        }
    }
    
    /// Delete all lists from coredata
    @IBAction private func deleteAllListsButtonTapped(_ sender: UIBarButtonItem) {
        displayMultiChoiceAlert(title: "Voulez-vous vraiment supprimer toutes vos listes ?", message: "") { (success) in
            guard success == true else {return}
            self.dataBaseManager?.deleteAllLists()
            self.allListsTableview.reloadData()
        }
    }
}

// MARK: - TableView DataSource

extension AllListsViewController: UITableViewDataSource {
    
    /// Number of elements in the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBaseManager?.lists.count ?? 0
    }
    
    /// Define tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.allListCellIdentifier, for: indexPath) as? AllListsTableViewCell else { return UITableViewCell() }
        cell.list = dataBaseManager?.lists[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    /// Action after cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listSelected = dataBaseManager?.lists[indexPath.row]
        list = listSelected
        self.performSegue(withIdentifier: Constants.Segue.allToListSegue, sender: nil)
    }
    
    /// Can Edit the tableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Can delete a cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Supprimer") { (action, indexPath) in
            guard let listName = self.dataBaseManager?.lists[indexPath.row].name, let list = self.dataBaseManager?.lists[indexPath.row] else {return}
            self.displayMultiChoiceAlert(title: "Vous êtes sur le point de supprimer cette liste", message: "") { (success) in
                guard success == true else {return}
                self.dataBaseManager?.deleteAllTasks(list: list)
                self.dataBaseManager?.deleteASpecificList(listName: listName)
                self.allListsTableview.reloadData()
            }
        }
        deleteButton.backgroundColor = #colorLiteral(red: 0.3228748441, green: 0.7752146125, blue: 0.8510860205, alpha: 1)
        return [deleteButton]
    }
}

// MARK: - TableView Delegate

extension AllListsViewController: UITableViewDelegate {
    
    /// Get in shape the tableView footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Vous n'avez pas encore de listes"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    /// Display the tableView footer depending the number of elements in favoritesRecipes
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataBaseManager?.lists.isEmpty ?? true ? tableView.bounds.size.height : 0
    }
}
