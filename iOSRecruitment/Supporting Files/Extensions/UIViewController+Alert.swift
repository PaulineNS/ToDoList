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
    
    ///Display an alert to enter the list and task name
    func displayTextFieldAlert(title: String, message: String, placeholder: String ,handlerTaskName: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        let addAction = UIAlertAction(title: "Ajouter", style: .default, handler: { _ in
            guard let textField = alertController.textFields else { return }
            handlerTaskName(textField[0].text)
        })
        let addSecondAction = UIAlertAction(title: "Annuler", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(addAction)
        alertController.addAction(addSecondAction)
        present(alertController, animated: true, completion: nil)
    }
    
    ///Display an alertwith choices
    func displayMultiChoiceAlert(title: String, message: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oui", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            completion(false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    ///Display a unique message alert
    func displayMessageAlert(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
