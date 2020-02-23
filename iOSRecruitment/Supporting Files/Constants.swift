//
//  Constants.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import Foundation

struct Constants {
    static let appName = "To Do List"
    
    struct Cell {
        static let allListCellNibName = "AllListsTableViewCell"
        static let allListCellIdentifier = "allListsCell"
        static let listCellNibName = "ListTableViewCell"
        static let listCellIdentifier = "ListCell"
    }
    
    struct Segue {
        static let welcomeSegue = "WelcomeToApp"
        static let allToListSegue = "AllToList"
        static let listToTaskSegue = "ListToTask"
    }
    
    struct DataBaseKeys {
        static let isDoneKey = "isDone"
        static let isImportantKey = "isImportant"
    }
}
