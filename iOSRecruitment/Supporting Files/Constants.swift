//
//  Constants.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import Foundation

// MARK: - Constants file

struct Constants {
    static let appName = "To Do List"
    
    struct Cell {
        static let allListCellNibName = "AllListsTableViewCell"
        static let allListCellIdentifier = "allListsCell"
        static let listCellNibName = "ListTableViewCell"
        static let listCellIdentifier = "ListCell"
        static let importantsTasksCellNibName = "ImportantsTasksTableViewCell"
        static let importantsTasksCellIdentifier = "ImportantsTasksCell"
    }
    
    struct Segue {
        static let welcomeSegue = "WelcomeToApp"
        static let allToListSegue = "AllToList"
        static let listToTaskSegue = "ListToTask"
        static let importantToTaskSSegue = "ImportantToTask"
    }
    
    struct DataBaseKeys {
        static let isDoneKey = "isDone"
        static let isImportantKey = "isImportant"
    }
}
