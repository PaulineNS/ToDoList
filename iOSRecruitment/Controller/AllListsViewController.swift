//
//  AllListsViewController.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

class AllListsViewController: UIViewController {

    @IBOutlet weak var allListsTableview: UITableView!
    @IBOutlet weak var addListButton: UIButton!
    
    var dataBaseManager: DataBaseManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "AllListsTableViewCell", bundle: nil)
        allListsTableview.register(nibName, forCellReuseIdentifier: "allListsCell")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.dataBaseStack
        dataBaseManager = DataBaseManager(dataBaseStack: coreDataStack)
    }
    
    @IBAction func addListButtonTapped(_ sender: UIButton) {
        displayTaskAlert { [unowned self] listName in
            guard let listName = listName, !listName.isBlank else { return }
            self.dataBaseManager?.createList(name: listName)
            self.allListsTableview.reloadData()
        }
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
        return cell
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
