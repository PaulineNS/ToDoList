//
//  UIViewController+Alert.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /**
     * Display an alert to enter the list and task name
     */
    func displayAlert(title: String, message: String, placeholder: String ,handlerTaskName: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        let addAction = UIAlertAction(title: "Ajouter", style: .default, handler: { _ in
            guard let textField = alertController.textFields else { return }
            handlerTaskName(textField[0].text)
        })
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
}
