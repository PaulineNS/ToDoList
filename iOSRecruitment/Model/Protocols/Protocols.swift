//
//  Protocols.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 23/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol DidAddNewTaskDelegate {
    func addTapped()
}

protocol ListTableViewCellDelegate {
    
    func doneTaskTapped(taskName: String, done: Bool)
    func importantTaskTapped(taskName: String, important: Bool)
}

protocol ImportantsTasksTableViewCellDelegate {
    
    func doneTaskTapped(taskName: String, list :List, done: Bool)
    func importantTaskTapped(taskName: String, list :List, important: Bool)
}
