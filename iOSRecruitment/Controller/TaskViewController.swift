//
//  TaskViewController.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskNoteTextView: UITextView!
    @IBOutlet weak var taskDeadlineTextField: UITextField!
    @IBOutlet weak var updateTaskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func trashButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func updateTaskButtonTapped(_ sender: UIButton) {
    }
}
